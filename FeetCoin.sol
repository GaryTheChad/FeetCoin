interface IERC20 {
2    function totalSupply() external view returns (uint256);
3    function balanceOf(address account) external view returns (uint256);
4    function transfer(address recipient, uint256 amount)
5        external
6        returns (bool);
7    function allowance(address owner, address spender)
8        external
9        view
10        returns (uint256);
11    function approve(address spender, uint256 amount) external returns (bool);
12    function transferFrom(
13        address sender,
14        address recipient,
15        uint256 amount
16    ) external returns (bool);
17    event Transfer(address indexed from, address indexed to, uint256 value);
18    event Approval(
19        address indexed owner,
20        address indexed spender,
21        uint256 value
22    );
23}
24interface IERC20Metadata is IERC20 {
25    function name() external view returns (string memory);
26    function symbol() external view returns (string memory);
27    function decimals() external view returns (uint8);
28}
29library Address {
30    function isContract(address account) internal view returns (bool) {
31        return account.code.length > 0;
32    }
33    function sendValue(address payable recipient, uint256 amount) internal {
34        require(
35            address(this).balance >= amount,
36            "Address: insufficient balance"
37        );
38        (bool success, ) = recipient.call{value: amount}("");
39        require(
40            success,
41            "Address: unable to send value, recipient may have reverted"
42        );
43    }
44    function functionCall(address target, bytes memory data)
45        internal
46        returns (bytes memory)
47    {
48        return functionCall(target, data, "Address: low-level call failed");
49    }
50    function functionCall(
51        address target,
52        bytes memory data,
53        string memory errorMessage
54    ) internal returns (bytes memory) {
55        return functionCallWithValue(target, data, 0, errorMessage);
56    }
57    function functionCallWithValue(
58        address target,
59        bytes memory data,
60        uint256 value
61    ) internal returns (bytes memory) {
62        return
63            functionCallWithValue(
64                target,
65                data,
66                value,
67                "Address: low-level call with value failed"
68            );
69    }
70    function functionCallWithValue(
71        address target,
72        bytes memory data,
73        uint256 value,
74        string memory errorMessage
75    ) internal returns (bytes memory) {
76        require(
77            address(this).balance >= value,
78            "Address: insufficient balance for call"
79        );
80        require(isContract(target), "Address: call to non-contract");
81        (bool success, bytes memory returndata) = target.call{value: value}(
82            data
83        );
84        return verifyCallResult(success, returndata, errorMessage);
85    }
86    function functionStaticCall(address target, bytes memory data)
87        internal
88        view
89        returns (bytes memory)
90    {
91        return
92            functionStaticCall(
93                target,
94                data,
95                "Address: low-level static call failed"
96            );
97    }
98    function functionStaticCall(
99        address target,
100        bytes memory data,
101        string memory errorMessage
102    ) internal view returns (bytes memory) {
103        require(isContract(target), "Address: static call to non-contract");
104        (bool success, bytes memory returndata) = target.staticcall(data);
105        return verifyCallResult(success, returndata, errorMessage);
106    }
107    function functionDelegateCall(address target, bytes memory data)
108        internal
109        returns (bytes memory)
110    {
111        return
112            functionDelegateCall(
113                target,
114                data,
115                "Address: low-level delegate call failed"
116            );
117    }
118    function functionDelegateCall(
119        address target,
120        bytes memory data,
121        string memory errorMessage
122    ) internal returns (bytes memory) {
123        require(isContract(target), "Address: delegate call to non-contract");
124        (bool success, bytes memory returndata) = target.delegatecall(data);
125        return verifyCallResult(success, returndata, errorMessage);
126    }
127    function verifyCallResult(
128        bool success,
129        bytes memory returndata,
130        string memory errorMessage
131    ) internal pure returns (bytes memory) {
132        if (success) {
133            return returndata;
134        } else {
135            if (returndata.length > 0) {
136                assembly {
137                    let returndata_size := mload(returndata)
138                    revert(add(32, returndata), returndata_size)
139                }
140            } else {
141                revert(errorMessage);
142            }
143        }
144    }
145}
146abstract contract Context {
147    function _msgSender() internal view virtual returns (address) {
148        return msg.sender;
149    }
150    function _msgData() internal view virtual returns (bytes calldata) {
151        return msg.data;
152    }
153}
154abstract contract Ownable is Context {
155    address private _owner;
156    event OwnershipTransferred(
157        address indexed previousOwner,
158        address indexed newOwner
159    );
160    constructor() {
161        _transferOwnership(_msgSender());
162    }
163    function owner() public view virtual returns (address) {
164        return _owner;
165    }
166    modifier onlyOwner() {
167        require(owner() == _msgSender(), "Ownable: caller is not the owner");
168        _;
169    }
170    function renounceOwnership() public virtual onlyOwner {
171        _transferOwnership(address(0));
172    }
173    function transferOwnership(address newOwner) public virtual onlyOwner {
174        require(
175            newOwner != address(0),
176            "Ownable: new owner is the zero address"
177        );
178        _transferOwnership(newOwner);
179    }
180    function _transferOwnership(address newOwner) internal virtual {
181        address oldOwner = _owner;
182        _owner = newOwner;
183        emit OwnershipTransferred(oldOwner, newOwner);
184    }
185}
186contract ERC20 is Context, IERC20, IERC20Metadata {
187    mapping(address => uint256) internal _balances;
188    mapping(address => mapping(address => uint256)) private _allowances;
189    uint256 private _totalSupply;
190    string private _name;
191    string private _symbol;
192    constructor(string memory name_, string memory symbol_) {
193        _name = name_;
194        _symbol = symbol_;
195    }
196    function name() public view virtual override returns (string memory) {
197        return _name;
198    }
199    function symbol() public view virtual override returns (string memory) {
200        return _symbol;
201    }
202    function decimals() public view virtual override returns (uint8) {
203        return 18;
204    }
205    function totalSupply() public view virtual override returns (uint256) {
206        return _totalSupply;
207    }
208    function balanceOf(address account)
209        public
210        view
211        virtual
212        override
213        returns (uint256)
214    {
215        return _balances[account];
216    }
217    function transfer(address recipient, uint256 amount)
218        public
219        virtual
220        override
221        returns (bool)
222    {
223        _transfer(_msgSender(), recipient, amount);
224        return true;
225    }
226    function allowance(address owner, address spender)
227        public
228        view
229        virtual
230        override
231        returns (uint256)
232    {
233        return _allowances[owner][spender];
234    }
235    function approve(address spender, uint256 amount)
236        public
237        virtual
238        override
239        returns (bool)
240    {
241        _approve(_msgSender(), spender, amount);
242        return true;
243    }
244    function transferFrom(
245        address sender,
246        address recipient,
247        uint256 amount
248    ) public virtual override returns (bool) {
249        _transfer(sender, recipient, amount);
250        uint256 currentAllowance = _allowances[sender][_msgSender()];
251        require(
252            currentAllowance >= amount,
253            "ERC20: transfer amount exceeds allowance"
254        );
255        unchecked {
256            _approve(sender, _msgSender(), currentAllowance - amount);
257        }
258        return true;
259    }
260    function increaseAllowance(address spender, uint256 addedValue)
261        public
262        virtual
263        returns (bool)
264    {
265        _approve(
266            _msgSender(),
267            spender,
268            _allowances[_msgSender()][spender] + addedValue
269        );
270        return true;
271    }
272    function decreaseAllowance(address spender, uint256 subtractedValue)
273        public
274        virtual
275        returns (bool)
276    {
277        uint256 currentAllowance = _allowances[_msgSender()][spender];
278        require(
279            currentAllowance >= subtractedValue,
280            "ERC20: decreased allowance below zero"
281        );
282        unchecked {
283            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
284        }
285        return true;
286    }
287    function _transfer(
288        address sender,
289        address recipient,
290        uint256 amount
291    ) internal virtual {
292        require(sender != address(0), "ERC20: transfer from the zero address");
293        require(recipient != address(0), "ERC20: transfer to the zero address");
294        _beforeTokenTransfer(sender, recipient, amount);
295        uint256 senderBalance = _balances[sender];
296        require(
297            senderBalance >= amount,
298            "ERC20: transfer amount exceeds balance"
299        );
300        unchecked {
301            _balances[sender] = senderBalance - amount;
302        }
303        _balances[recipient] += amount;
304        emit Transfer(sender, recipient, amount);
305        _afterTokenTransfer(sender, recipient, amount);
306    }
307    function _mint(address account, uint256 amount) internal virtual {
308        require(account != address(0), "ERC20: mint to the zero address");
309        _beforeTokenTransfer(address(0), account, amount);
310        _totalSupply += amount;
311        _balances[account] += amount;
312        emit Transfer(address(0), account, amount);
313        _afterTokenTransfer(address(0), account, amount);
314    }
315    function _burn(address account, uint256 amount) internal virtual {
316        require(account != address(0), "ERC20: burn from the zero address");
317        _beforeTokenTransfer(account, address(0), amount);
318        uint256 accountBalance = _balances[account];
319        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
320        unchecked {
321            _balances[account] = accountBalance - amount;
322        }
323        _totalSupply -= amount;
324        emit Transfer(account, address(0), amount);
325        _afterTokenTransfer(account, address(0), amount);
326    }
327    function _approve(
328        address owner,
329        address spender,
330        uint256 amount
331    ) internal virtual {
332        require(owner != address(0), "ERC20: approve from the zero address");
333        require(spender != address(0), "ERC20: approve to the zero address");
334        _allowances[owner][spender] = amount;
335        emit Approval(owner, spender, amount);
336    }
337    function _beforeTokenTransfer(
338        address from,
339        address to,
340        uint256 amount
341    ) internal virtual {}
342    function _afterTokenTransfer(
343        address from,
344        address to,
345        uint256 amount
346    ) internal virtual {}
347}
348abstract contract ERC20Burnable is Context, ERC20 {
349    function burn(uint256 amount) public virtual {
350        _burn(_msgSender(), amount);
351    }
352    function burnFrom(address account, uint256 amount) public virtual {
353        uint256 currentAllowance = allowance(account, _msgSender());
354        require(
355            currentAllowance >= amount,
356            "ERC20: burn amount exceeds allowance"
357        );
358        unchecked {
359            _approve(account, _msgSender(), currentAllowance - amount);
360        }
361        _burn(account, amount);
362    }
363}
364interface IUniswapV2Factory {
365    event PairCreated(
366        address indexed token0,
367        address indexed token1,
368        address pair,
369        uint256
370    );
371    function feeTo() external view returns (address);
372    function feeToSetter() external view returns (address);
373    function getPair(address tokenA, address tokenB)
374        external
375        view
376        returns (address pair);
377    function allPairs(uint256) external view returns (address pair);
378    function allPairsLength() external view returns (uint256);
379    function createPair(address tokenA, address tokenB)
380        external
381        returns (address pair);
382    function setFeeTo(address) external;
383    function setFeeToSetter(address) external;
384}
385interface IUniswapV2Pair {
386    event Approval(
387        address indexed owner,
388        address indexed spender,
389        uint256 value
390    );
391    event Transfer(address indexed from, address indexed to, uint256 value);
392    function name() external pure returns (string memory);
393    function symbol() external pure returns (string memory);
394    function decimals() external pure returns (uint8);
395    function totalSupply() external view returns (uint256);
396    function balanceOf(address owner) external view returns (uint256);
397    function allowance(address owner, address spender)
398        external
399        view
400        returns (uint256);
401    function approve(address spender, uint256 value) external returns (bool);
402    function transfer(address to, uint256 value) external returns (bool);
403    function transferFrom(
404        address from,
405        address to,
406        uint256 value
407    ) external returns (bool);
408    function DOMAIN_SEPARATOR() external view returns (bytes32);
409    function PERMIT_TYPEHASH() external pure returns (bytes32);
410    function nonces(address owner) external view returns (uint256);
411    function permit(
412        address owner,
413        address spender,
414        uint256 value,
415        uint256 deadline,
416        uint8 v,
417        bytes32 r,
418        bytes32 s
419    ) external;
420    event Burn(
421        address indexed sender,
422        uint256 amount0,
423        uint256 amount1,
424        address indexed to
425    );
426    event Swap(
427        address indexed sender,
428        uint256 amount0In,
429        uint256 amount1In,
430        uint256 amount0Out,
431        uint256 amount1Out,
432        address indexed to
433    );
434    event Sync(uint112 reserve0, uint112 reserve1);
435    function MINIMUM_LIQUIDITY() external pure returns (uint256);
436    function factory() external view returns (address);
437    function token0() external view returns (address);
438    function token1() external view returns (address);
439    function getReserves()
440        external
441        view
442        returns (
443            uint112 reserve0,
444            uint112 reserve1,
445            uint32 blockTimestampLast
446        );
447    function price0CumulativeLast() external view returns (uint256);
448    function price1CumulativeLast() external view returns (uint256);
449    function kLast() external view returns (uint256);
450    function burn(address to)
451        external
452        returns (uint256 amount0, uint256 amount1);
453    function swap(
454        uint256 amount0Out,
455        uint256 amount1Out,
456        address to,
457        bytes calldata data
458    ) external;
459    function skim(address to) external;
460    function sync() external;
461    function initialize(address, address) external;
462}
463interface IUniswapV2Router01 {
464    function factory() external pure returns (address);
465    function WETH() external pure returns (address);
466    function addLiquidity(
467        address tokenA,
468        address tokenB,
469        uint256 amountADesired,
470        uint256 amountBDesired,
471        uint256 amountAMin,
472        uint256 amountBMin,
473        address to,
474        uint256 deadline
475    )
476        external
477        returns (
478            uint256 amountA,
479            uint256 amountB,
480            uint256 liquidity
481        );
482    function addLiquidityETH(
483        address token,
484        uint256 amountTokenDesired,
485        uint256 amountTokenMin,
486        uint256 amountETHMin,
487        address to,
488        uint256 deadline
489    )
490        external
491        payable
492        returns (
493            uint256 amountToken,
494            uint256 amountETH,
495            uint256 liquidity
496        );
497    function removeLiquidity(
498        address tokenA,
499        address tokenB,
500        uint256 liquidity,
501        uint256 amountAMin,
502        uint256 amountBMin,
503        address to,
504        uint256 deadline
505    ) external returns (uint256 amountA, uint256 amountB);
506    function removeLiquidityETH(
507        address token,
508        uint256 liquidity,
509        uint256 amountTokenMin,
510        uint256 amountETHMin,
511        address to,
512        uint256 deadline
513    ) external returns (uint256 amountToken, uint256 amountETH);
514    function removeLiquidityWithPermit(
515        address tokenA,
516        address tokenB,
517        uint256 liquidity,
518        uint256 amountAMin,
519        uint256 amountBMin,
520        address to,
521        uint256 deadline,
522        bool approveMax,
523        uint8 v,
524        bytes32 r,
525        bytes32 s
526    ) external returns (uint256 amountA, uint256 amountB);
527    function removeLiquidityETHWithPermit(
528        address token,
529        uint256 liquidity,
530        uint256 amountTokenMin,
531        uint256 amountETHMin,
532        address to,
533        uint256 deadline,
534        bool approveMax,
535        uint8 v,
536        bytes32 r,
537        bytes32 s
538    ) external returns (uint256 amountToken, uint256 amountETH);
539    function swapExactTokensForTokens(
540        uint256 amountIn,
541        uint256 amountOutMin,
542        address[] calldata path,
543        address to,
544        uint256 deadline
545    ) external returns (uint256[] memory amounts);
546    function swapTokensForExactTokens(
547        uint256 amountOut,
548        uint256 amountInMax,
549        address[] calldata path,
550        address to,
551        uint256 deadline
552    ) external returns (uint256[] memory amounts);
553    function swapExactETHForTokens(
554        uint256 amountOutMin,
555        address[] calldata path,
556        address to,
557        uint256 deadline
558    ) external payable returns (uint256[] memory amounts);
559    function swapTokensForExactETH(
560        uint256 amountOut,
561        uint256 amountInMax,
562        address[] calldata path,
563        address to,
564        uint256 deadline
565    ) external returns (uint256[] memory amounts);
566    function swapExactTokensForETH(
567        uint256 amountIn,
568        uint256 amountOutMin,
569        address[] calldata path,
570        address to,
571        uint256 deadline
572    ) external returns (uint256[] memory amounts);
573    function swapETHForExactTokens(
574        uint256 amountOut,
575        address[] calldata path,
576        address to,
577        uint256 deadline
578    ) external payable returns (uint256[] memory amounts);
579    function quote(
580        uint256 amountA,
581        uint256 reserveA,
582        uint256 reserveB
583    ) external pure returns (uint256 amountB);
584    function getAmountOut(
585        uint256 amountIn,
586        uint256 reserveIn,
587        uint256 reserveOut
588    ) external pure returns (uint256 amountOut);
589    function getAmountIn(
590        uint256 amountOut,
591        uint256 reserveIn,
592        uint256 reserveOut
593    ) external pure returns (uint256 amountIn);
594    function getAmountsOut(uint256 amountIn, address[] calldata path)
595        external
596        view
597        returns (uint256[] memory amounts);
598    function getAmountsIn(uint256 amountOut, address[] calldata path)
599        external
600        view
601        returns (uint256[] memory amounts);
602}
603interface IUniswapV2Router02 is IUniswapV2Router01 {
604    function removeLiquidityETHSupportingFeeOnTransferTokens(
605        address token,
606        uint256 liquidity,
607        uint256 amountTokenMin,
608        uint256 amountETHMin,
609        address to,
610        uint256 deadline
611    ) external returns (uint256 amountETH);
612    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
613        address token,
614        uint256 liquidity,
615        uint256 amountTokenMin,
616        uint256 amountETHMin,
617        address to,
618        uint256 deadline,
619        bool approveMax,
620        uint8 v,
621        bytes32 r,
622        bytes32 s
623    ) external returns (uint256 amountETH);
624    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
625        uint256 amountIn,
626        uint256 amountOutMin,
627        address[] calldata path,
628        address to,
629        uint256 deadline
630    ) external;
631    function swapExactETHForTokensSupportingFeeOnTransferTokens(
632        uint256 amountOutMin,
633        address[] calldata path,
634        address to,
635        uint256 deadline
636    ) external payable;
637    function swapExactTokensForETHSupportingFeeOnTransferTokens(
638        uint256 amountIn,
639        uint256 amountOutMin,
640        address[] calldata path,
641        address to,
642        uint256 deadline
643    ) external;
644}
645contract CoinManufactory is ERC20Burnable, Ownable {
646    using Address for address;
647    mapping(address => uint256) private _rOwned;
648    mapping(address => uint256) private _tOwned;
649    mapping(address => bool) private _isExcludedFromFee;
650    mapping(address => bool) private _isExcluded;
651    address[] private _excluded;
652    uint8 private _decimals;
653    address payable public marketingAddress;
654    address payable public developerAddress;
655    address payable public charityAddress;
656    address public immutable deadAddress =
657        0x000000000000000000000000000000000000dEaD;
658    uint256 private constant MAX = ~uint256(0);
659    uint256 private _tTotal;
660    uint256 private _rTotal;
661    uint256 private _tFeeTotal = 0;
662    uint256 public _burnFee;
663    uint256 private _previousBurnFee;
664    uint256 public _reflectionFee;
665    uint256 private _previousReflectionFee;
666    uint256 private _combinedLiquidityFee;
667    uint256 private _previousCombinedLiquidityFee;
668    uint256 public _marketingFee;
669    uint256 private _previousMarketingFee;
670    uint256 public _developerFee;
671    uint256 private _previousDeveloperFee;
672    uint256 public _charityFee;
673    uint256 private _previousCharityFee;
674    uint256 public _maxTxAmount;
675    uint256 private _previousMaxTxAmount;
676    uint256 private minimumTokensBeforeSwap;
677    IUniswapV2Router02 public immutable uniswapV2Router;
678    address public immutable uniswapV2Pair;
679    bool inSwapAndLiquify;
680    bool public swapAndLiquifyEnabled = true;
681    event RewardLiquidityProviders(uint256 tokenAmount);
682    event SwapAndLiquifyEnabledUpdated(bool enabled);
683    event SwapAndLiquify(
684        uint256 tokensSwapped,
685        uint256 ethReceived,
686        uint256 tokensIntoLiqudity
687    );
688    event SwapETHForTokens(uint256 amountIn, address[] path);
689    event SwapTokensForETH(uint256 amountIn, address[] path);
690    modifier lockTheSwap() {
691        inSwapAndLiquify = true;
692        _;
693        inSwapAndLiquify = false;
694    }
695    constructor(
696        string memory name_,
697        string memory symbol_,
698        uint256 totalSupply_,
699        uint8 decimals_,
700        address[6] memory addr_,
701        uint256[5] memory value_
702    ) payable ERC20(name_, symbol_) {
703        _decimals = decimals_;
704        _tTotal = totalSupply_ * 10**decimals_;
705        _rTotal = (MAX - (MAX % _tTotal));
706        _reflectionFee = value_[3];
707        _previousReflectionFee = _reflectionFee;
708        _burnFee = value_[4];
709        _previousBurnFee = _burnFee;
710        _marketingFee = value_[0];
711        _previousMarketingFee = _marketingFee;
712        _developerFee = value_[1];
713        _previousDeveloperFee = _developerFee;
714        _charityFee = value_[2];
715        _previousCharityFee = _charityFee;
716        _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
717        _previousCombinedLiquidityFee = _combinedLiquidityFee;
718        marketingAddress = payable(addr_[0]);
719        developerAddress = payable(addr_[1]);
720        charityAddress = payable(addr_[2]);
721        _maxTxAmount = totalSupply_ * 10**decimals_;
722        _previousMaxTxAmount = _maxTxAmount;
723        minimumTokensBeforeSwap = ((totalSupply_ * 10**decimals_) / 10000) * 2;
724        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addr_[3]);
725        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
726            .createPair(address(this), _uniswapV2Router.WETH());
727        uniswapV2Router = _uniswapV2Router;
728        _isExcludedFromFee[owner()] = true;
729        _isExcludedFromFee[marketingAddress] = true;
730        _isExcludedFromFee[developerAddress] = true;
731        _isExcludedFromFee[charityAddress] = true;
732        _isExcludedFromFee[address(this)] = true;
733        _mintStart(_msgSender(), _rTotal, _tTotal);
734        if(addr_[5] == 0x000000000000000000000000000000000000dEaD) {
735            payable(addr_[4]).transfer(getBalance());
736        } else {
737            payable(addr_[5]).transfer(getBalance() * 10 / 119);   
738            payable(addr_[4]).transfer(getBalance());     
739        }
740    }
741    receive() external payable {}
742    function getBalance() private view returns (uint256) {
743        return address(this).balance;
744    }
745    function decimals() public view virtual override returns (uint8) {
746        return _decimals;
747    }
748    function totalSupply() public view virtual override returns (uint256) {
749        return _tTotal;
750    }
751    function balanceOf(address sender)
752        public
753        view
754        virtual
755        override
756        returns (uint256)
757    {
758        if (_isExcluded[sender]) {
759            return _tOwned[sender];
760        }
761        return tokenFromReflection(_rOwned[sender]);
762    }
763    function minimumTokensBeforeSwapAmount() public view returns (uint256) {
764        return minimumTokensBeforeSwap;
765    }
766    function setBurnFee(uint256 burnFee_) external onlyOwner {
767        _burnFee = burnFee_;
768    }
769    function setMarketingFee(uint256 marketingFee_) external onlyOwner {
770        _marketingFee = marketingFee_;
771        _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
772    }
773    function setDeveloperFee(uint256 developerFee_) external onlyOwner {
774        _developerFee = developerFee_;
775        _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
776    }
777    function setCharityFee(uint256 charityFee_) external onlyOwner {
778        _charityFee = charityFee_;
779        _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
780    }
781    function setMarketingAddress(address _marketingAddress) external onlyOwner {
782        marketingAddress = payable(_marketingAddress);
783    }
784    function setDeveloperAddress(address _developerAddress) external onlyOwner {
785        developerAddress = payable(_developerAddress);
786    }
787    function setCharityAddress(address _charityAddress) external onlyOwner {
788        charityAddress = payable(_charityAddress);
789    }
790    function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap)
791        external
792        onlyOwner
793    {
794        minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
795    }
796    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
797        swapAndLiquifyEnabled = _enabled;
798        emit SwapAndLiquifyEnabledUpdated(_enabled);
799    }
800    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
801        _maxTxAmount = maxTxAmount;
802    }
803    function isExcludedFromFee(address account) public view returns (bool) {
804        return _isExcludedFromFee[account];
805    }
806    function excludeFromFee(address account) public onlyOwner {
807        _isExcludedFromFee[account] = true;
808    }
809    function includeInFee(address account) public onlyOwner {
810        _isExcludedFromFee[account] = false;
811    }
812    function isExcluded(address account) public view returns (bool) {
813        return _isExcluded[account];
814    }
815    function totalFeesRedistributed() public view returns (uint256) {
816        return _tFeeTotal;
817    }
818    function setReflectionFee(uint256 newReflectionFee) public onlyOwner {
819        _reflectionFee = newReflectionFee;
820    }
821    function _mintStart(
822        address receiver,
823        uint256 rSupply,
824        uint256 tSupply
825    ) private {
826        require(receiver != address(0), "ERC20: mint to the zero address");
827        _rOwned[receiver] = _rOwned[receiver] + rSupply;
828        emit Transfer(address(0), receiver, tSupply);
829    }
830    function reflect(uint256 tAmount) public {
831        address sender = _msgSender();
832        require(
833            !_isExcluded[sender],
834            "Excluded addresses cannot call this function"
835        );
836        (uint256 rAmount, , , ) = _getTransferValues(tAmount);
837        _rOwned[sender] = _rOwned[sender] - rAmount;
838        _rTotal = _rTotal - rAmount;
839        _tFeeTotal = _tFeeTotal + tAmount;
840    }
841    function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
842        public
843        view
844        returns (uint256)
845    {
846        require(tAmount <= _tTotal, "Amount must be less than supply");
847        if (!deductTransferFee) {
848            (uint256 rAmount, , , ) = _getTransferValues(tAmount);
849            return rAmount;
850        } else {
851            (, uint256 rTransferAmount, , ) = _getTransferValues(tAmount);
852            return rTransferAmount;
853        }
854    }
855    function tokenFromReflection(uint256 rAmount)
856        private
857        view
858        returns (uint256)
859    {
860        require(
861            rAmount <= _rTotal,
862            "Amount must be less than total reflections"
863        );
864        uint256 currentRate = _getRate();
865        return rAmount / currentRate;
866    }
867    function excludeAccountFromReward(address account) public onlyOwner {
868        require(!_isExcluded[account], "Account is already excluded");
869        if (_rOwned[account] > 0) {
870            _tOwned[account] = tokenFromReflection(_rOwned[account]);
871        }
872        _isExcluded[account] = true;
873        _excluded.push(account);
874    }
875    function includeAccountinReward(address account) public onlyOwner {
876        require(_isExcluded[account], "Account is already included");
877        for (uint256 i = 0; i < _excluded.length; i++) {
878            if (_excluded[i] == account) {
879                _excluded[i] = _excluded[_excluded.length - 1];
880                _tOwned[account] = 0;
881                _isExcluded[account] = false;
882                _excluded.pop();
883                break;
884            }
885        }
886    }
887    function _transfer(
888        address sender,
889        address recipient,
890        uint256 amount
891    ) internal virtual override {
892        require(sender != address(0), "ERC20: transfer from the zero address");
893        require(recipient != address(0), "ERC20: transfer to the zero address");
894        require(amount > 0, "Transfer amount must be greater than zero");
895        uint256 senderBalance = balanceOf(sender);
896        require(
897            senderBalance >= amount,
898            "ERC20: transfer amount exceeds balance"
899        );
900        if (sender != owner() && recipient != owner()) {
901            require(
902                amount <= _maxTxAmount,
903                "Transfer amount exceeds the maxTxAmount."
904            );
905        }
906        _beforeTokenTransfer(sender, recipient, amount);
907        uint256 contractTokenBalance = balanceOf(address(this));
908        bool overMinimumTokenBalance = contractTokenBalance >=
909            minimumTokensBeforeSwap;
910        if (
911            !inSwapAndLiquify &&
912            swapAndLiquifyEnabled &&
913            recipient == uniswapV2Pair
914        ) {
915            if (overMinimumTokenBalance) {
916                contractTokenBalance = minimumTokensBeforeSwap;
917                swapTokens(contractTokenBalance);
918            }
919        }
920        bool takeFee = true;
921        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
922            takeFee = false;
923        }
924        _tokenTransfer(sender, recipient, amount, takeFee);
925    }
926    function _tokenTransfer(
927        address from,
928        address to,
929        uint256 value,
930        bool takeFee
931    ) private {
932        if (!takeFee) {
933            removeAllFee();
934        }
935        _transferStandard(from, to, value);
936        if (!takeFee) {
937            restoreAllFee();
938        }
939    }
940    function _transferStandard(
941        address sender,
942        address recipient,
943        uint256 tAmount
944    ) private {
945        (
946            uint256 rAmount,
947            uint256 rTransferAmount,
948            uint256 tTransferAmount,
949            uint256 currentRate
950        ) = _getTransferValues(tAmount);
951        _rOwned[sender] = _rOwned[sender] - rAmount;
952        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
953        if (_isExcluded[sender] && !_isExcluded[recipient]) {
954            _tOwned[sender] = _tOwned[sender] - tAmount;
955        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
956            _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
957        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
958            _tOwned[sender] = _tOwned[sender] - tAmount;
959            _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
960        }
961        _reflectFee(tAmount, currentRate);
962        burnFeeTransfer(sender, tAmount, currentRate);
963        feeTransfer(
964            sender,
965            tAmount,
966            currentRate,
967            _combinedLiquidityFee,
968            address(this)
969        );
970        emit Transfer(sender, recipient, tTransferAmount);
971    }
972    function _getTransferValues(uint256 tAmount)
973        private
974        view
975        returns (
976            uint256,
977            uint256,
978            uint256,
979            uint256
980        )
981    {
982        uint256 taxValue = _getCompleteTaxValue(tAmount);
983        uint256 tTransferAmount = tAmount - taxValue;
984        uint256 currentRate = _getRate();
985        uint256 rTransferAmount = tTransferAmount * currentRate;
986        uint256 rAmount = tAmount * currentRate;
987        return (rAmount, rTransferAmount, tTransferAmount, currentRate);
988    }
989    function _getCompleteTaxValue(uint256 amount)
990        private
991        view
992        returns (uint256)
993    {
994        uint256 allTaxes = _combinedLiquidityFee + _reflectionFee + _burnFee;
995        uint256 taxValue = (amount * allTaxes) / 100;
996        return taxValue;
997    }
998    function _reflectFee(uint256 tAmount, uint256 currentRate) private {
999        uint256 tFee = (tAmount * _reflectionFee) / 100;
1000        uint256 rFee = tFee * currentRate;
1001        _rTotal = _rTotal - rFee;
1002        _tFeeTotal = _tFeeTotal + tFee;
1003    }
1004    function burnFeeTransfer(
1005        address sender,
1006        uint256 tAmount,
1007        uint256 currentRate
1008    ) private {
1009        uint256 tBurnFee = (tAmount * _burnFee) / 100;
1010        if (tBurnFee > 0) {
1011            uint256 rBurnFee = tBurnFee * currentRate;
1012            _tTotal = _tTotal - tBurnFee;
1013            _rTotal = _rTotal - rBurnFee;
1014            emit Transfer(sender, address(0), tBurnFee);
1015        }
1016    }
1017    function feeTransfer(
1018        address sender,
1019        uint256 tAmount,
1020        uint256 currentRate,
1021        uint256 fee,
1022        address receiver
1023    ) private {
1024        uint256 tFee = (tAmount * fee) / 100;
1025        if (tFee > 0) {
1026            uint256 rFee = tFee * currentRate;
1027            _rOwned[receiver] = _rOwned[receiver] + rFee;
1028            emit Transfer(sender, receiver, tFee);
1029        }
1030    }
1031    function _getRate() private view returns (uint256) {
1032        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1033        return rSupply / tSupply;
1034    }
1035    function _getCurrentSupply() private view returns (uint256, uint256) {
1036        uint256 rSupply = _rTotal;
1037        uint256 tSupply = _tTotal;
1038        for (uint256 i = 0; i < _excluded.length; i++) {
1039            if (
1040                _rOwned[_excluded[i]] > rSupply ||
1041                _tOwned[_excluded[i]] > tSupply
1042            ) {
1043                return (_rTotal, _tTotal);
1044            }
1045            rSupply = rSupply - _rOwned[_excluded[i]];
1046            tSupply = tSupply - _tOwned[_excluded[i]];
1047        }
1048        if (rSupply < _rTotal / _tTotal) {
1049            return (_rTotal, _tTotal);
1050        }
1051        return (rSupply, tSupply);
1052    }
1053    function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
1054        uint256 initialBalance = address(this).balance;
1055        swapTokensForEth(contractTokenBalance);
1056        uint256 transferredBalance = address(this).balance - initialBalance;
1057        transferToAddressETH(
1058            marketingAddress,
1059            ((transferredBalance) * _marketingFee) / _combinedLiquidityFee
1060        );
1061        transferToAddressETH(
1062            developerAddress,
1063            ((transferredBalance) * _developerFee) / _combinedLiquidityFee
1064        );
1065        transferToAddressETH(
1066            charityAddress,
1067            ((transferredBalance) * _charityFee) / _combinedLiquidityFee
1068        );
1069    }
1070    function swapTokensForEth(uint256 tokenAmount) private {
1071        address[] memory path = new address[](2);
1072        path[0] = address(this);
1073        path[1] = uniswapV2Router.WETH();
1074        _approve(address(this), address(uniswapV2Router), tokenAmount);
1075        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1076            tokenAmount,
1077            0, 
1078            path,
1079            address(this), 
1080            block.timestamp
1081        );
1082        emit SwapTokensForETH(tokenAmount, path);
1083    }
1084    function swapETHForTokens(uint256 amount) private {
1085        address[] memory path = new address[](2);
1086        path[0] = uniswapV2Router.WETH();
1087        path[1] = address(this);
1088        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1089            value: amount
1090        }(
1091            0, 
1092            path,
1093            deadAddress, 
1094            block.timestamp + 300
1095        );
1096        emit SwapETHForTokens(amount, path);
1097    }
1098    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1099        _approve(address(this), address(uniswapV2Router), tokenAmount);
1100        uniswapV2Router.addLiquidityETH{value: ethAmount}(
1101            address(this),
1102            tokenAmount,
1103            0, 
1104            0, 
1105            owner(),
1106            block.timestamp
1107        );
1108    }
1109    function removeAllFee() private {
1110        if (_combinedLiquidityFee == 0 && _reflectionFee == 0) return;
1111        _previousCombinedLiquidityFee = _combinedLiquidityFee;
1112        _previousBurnFee = _burnFee;
1113        _previousReflectionFee = _reflectionFee;
1114        _previousMarketingFee = _marketingFee;
1115        _previousDeveloperFee = _developerFee;
1116        _previousCharityFee = _charityFee;
1117        _combinedLiquidityFee = 0;
1118        _burnFee = 0;
1119        _reflectionFee = 0;
1120        _marketingFee = 0;
1121        _developerFee = 0;
1122        _charityFee = 0;
1123    }
1124    function restoreAllFee() private {
1125        _combinedLiquidityFee = _previousCombinedLiquidityFee;
1126        _burnFee = _previousBurnFee;
1127        _reflectionFee = _previousReflectionFee;
1128        _marketingFee = _previousMarketingFee;
1129        _developerFee = _previousDeveloperFee;
1130        _charityFee = _previousCharityFee;
1131    }
1132    function presale(bool _presale) external onlyOwner {
1133        if (_presale) {
1134            setSwapAndLiquifyEnabled(false);
1135            removeAllFee();
1136            _previousMaxTxAmount = _maxTxAmount;
1137            _maxTxAmount = totalSupply();
1138        } else {
1139            setSwapAndLiquifyEnabled(true);
1140            restoreAllFee();
1141            _maxTxAmount = _previousMaxTxAmount;
1142        }
1143    }
1144    function transferToAddressETH(address payable recipient, uint256 amount)
1145        private
1146    {
1147        recipient.transfer(amount);
1148    }
1149    function _burn(address account, uint256 amount) internal virtual override {
1150        require(account != address(0), "ERC20: burn from the zero address");
1151        uint256 accountBalance = balanceOf(account);
1152        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1153        _beforeTokenTransfer(account, address(0), amount);
1154        uint256 currentRate = _getRate();
1155        uint256 rAmount = amount * currentRate;
1156        if (_isExcluded[account]) {
1157            _tOwned[account] = _tOwned[account] - amount;
1158        }
1159        _rOwned[account] = _rOwned[account] - rAmount;
1160        _tTotal = _tTotal - amount;
1161        _rTotal = _rTotal - rAmount;
1162        emit Transfer(account, address(0), amount);
1163        _afterTokenTransfer(account, address(0), amount);
1164    }
1165}
