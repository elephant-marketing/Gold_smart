# Gold_smart


# [Токен](https://rinkeby.etherscan.io/address/0x3b0cc7b421bebdee953d5744902fa10095484647)

Публичные поля:
`name` - название токена
`symbol` - краткое название токена (3-4 символа)
`decimals` - количество знаков после запятой
`owner` - адрес владельца смарт-контракта токена
`initialSupply` - начальное количество токенов
`totalSupply` - общее количество токенов
`allowed` - список вида "адрес обладателя токенов -> адрес распоряжающегося токенами -> дозволенная для распоряжения сумма"
`balances` - хранит баланс в токенах
`finishMinting` - возвращает возможен ли выпуск токенов
`crowdsaleAddress` - адреса смарт-контрактов PreICO и ICO, обладающими правами на дистрибьюцию

Методы:
`balanceOf` - список обладателей токенов и их количества токенов
`transfer` - отправляет токены с адреса отправителя на указанный адрес получателя
`totalSupply` - возвращает количество выпущенных токенов
`approve` - наделяет указанный адрес правами на распоряжение указанной суммой токенов отправителя
`allowance` - возвращает количество токенов обладателя, которым может распоряжаться отправитель
`increaseApproval` - увеличивает количество токенов обладателя, которым может распоряжаться отправитель
`decreaseApproval` - снижает количество токенов обладателя, которым может распоряжаться отправитель
`transferFrom` - отправляет токены с указанного адреса обладателя на указанный адрес получателя при условии наличия соответствующих прав
`burn` - сжигает указанное количество токенов отправителя
`mintingFinished` - завершает выпуск токенов навсегда
`pause` - ограничивает операции с токенами
`unpause` - разрешает операции с токенами
`mintFromICO`  - выпускает токены для контракта Sale
`setSaleAddress` - устанавливает адрес Sale для токена


# [PreICOCrowdSale](https://rinkeby.etherscan.io/address/0xd39361a6da8744f640a137e5881619b56917f80a)

Публичные поля:
`owner` - адрес владельца смарт-контракта PreICO/ICO
`token` - адрес смарт-контракта продаваемого токена
`backEndOperator` - оператор управления контрактом
`weisRaised` - количество привлеченных средств в ICO в wei
`hardCapPreSale` - верхний порог привлечения средств на PreICO
`softCapPreSale` - нижний порог привлечения средств на PreICO
`dollarPrice` -  курс эфира к доллару
`startPreSale` - дата начала PreICO
`endPreSale` - дата окончания PreICO
`investedEther` - количество эфира, который инвестировал инвестор
`whitelist` - список  адресов, допущенных для участия
`investors` - список авторизованных инвесторов
`buyPrice` - устанавливает цену токена в wei
`soldTokensPreSale` - количество проданных на этапе распродажи токенов

Методы:

`setBackEndAddress` - устанавливает адрес backEndOperator
`setStartPreSale` - устанавливает начало PreICO
`setEndPreSale` - устанавливает окончание PreICO
`setBuyPrice` - устанавливает курс эфира к доллару
`authorize` - добавляет адрес в список допущенных для участия в PreICO
`revoke` - удаляет адрес из списка допущенных для участия в PreICO
`fallback` - продает токены при переводе эфира
`isPreSale` - проверяет, истек ли этап PreICO
`transferEthFromContract` - функция отправки собранного эфира с контракта
`refundPreICO` - возвращает средства инвесторам, если не был достигнут preICOsoftcap


# [ICO_Stage_One](https://rinkeby.etherscan.io/address/0x6d7599fed35c7bff32bb0ae70cf5f949786bf2f2)


Публичные поля:
`owner` - адрес владельца смарт-контракта Sale/ICO
`token` - адрес смарт-контракта продаваемого токена
`backEndOperator` - оператор управления контрактом
`weisRaised` - количество привлеченных средств в ICO в wei
`hardCap1Stage` - верхний порог привлечения средств на Sale
`softCap1Stage` - нижний порог привлечения средств на Sale
`dollarPrice` -  курс эфира к доллару
`start1StageSale` - дата начала Sale
`end1StageSale` - дата окончания Sale
`investedEther` - количество эфира, который инвестировал инвестор
`whitelist` - список  адресов, допущенных для участия
`investors` - список авторизованных инвесторов
`buyPrice` - устанавливает цену токена в wei
`soldTokens` - количество проданных на этапе распродажи токенов

Методы:

`setBackEndAddress` - устанавливает адрес backEndOperator
`setStartOneSale` - устанавливает начало Sale
`setEndOneSale` - устанавливает окончание Sale
`setBuyPrice` - устанавливает курс эфира к доллару
`authorize` - добавляет адрес в список допущенных для участия в Sale
`revoke` - удаляет адрес из списка допущенных для участия в Sale
`fallback` - продает токены при переводе эфира
`isOneStageSale` - проверяет, истек ли этап Sale
`transferEthFromContract` - функция отправки собранного эфира с контракта
`refund1ICO` - возвращает средства инвесторам, если не был достигнут softCap1Stage


# [ICO_Stage_Two](https://rinkeby.etherscan.io/verifyContract?a=0x1eb33847819c9a131b99f84a4d8245c5e853ae64)

Публичные поля:
`owner` - адрес владельца смарт-контракта Sale
`token` - адрес смарт-контракта продаваемого токена
`backEndOperator` - оператор управления контрактом
`weisRaised` - количество привлеченных средств в ICO в wei
`hardCap2Stage` - верхний порог привлечения средств на Sale
`softCap2Stage` - нижний порог привлечения средств на Sale
`dollarPrice` -  курс эфира к доллару
`start2StageSale` - дата начала Sale
`end2StageSale` - дата окончания Sale
`investedEther` - количество эфира, который инвестировал инвестор
`whitelist` - список  адресов, допущенных для участия
`investors` - список авторизованных инвесторов
`buyPrice` - устанавливает цену токена в wei
`soldTokens` - количество проданных на этапе распродажи токенов

Методы:

`setBackEndAddress` - устанавливает адрес backEndOperator
`setStartTwoSale` - устанавливает начало Sale
`setEndTwoSale` - устанавливает окончание Sale
`setBuyPrice` - устанавливает курс эфира к доллару
`authorize` - добавляет адрес в список допущенных для участия в Sale
`revoke` - удаляет адрес из списка допущенных для участия в Sale
`fallback` - продает токены при переводе эфира
`isTwoStageSale` - проверяет, истек ли этап Sale
`transferEthFromContract` - функция отправки собранного эфира с контракта
`refund1ICO` - возвращает средства инвесторам, если не был достигнут preICOsoftcap



# Инструкция по размещению токена и контракта сейла в сети Ethereum(на примере тестовой сети Rinkeby)

Инструкция по внесению смарт-контракта в блокчейн через Remix(необходима установка Metamask).

`1` Вставить код Token.sol в редактор кода (remix.ethereum.org);

`2` Нажать кнопку Deploy, расположенную в интерфейсе справа во вкладке Run;

`3` В консоли снизу после успешного внесения смарт-контракта токена в блокчейн, появится запись о выполнении. Необходимо кликнуть на Details и в списке найти хэш транзакции
По этому хэшу найти транзакцию на https://etherscan.io/;

`4` В транзакции будет указан адрес смарт-контракта - копируем;

`5` Вставить код PreICO(ICO_stage1 или ICO_stage2).sol в редактор кода (remix.ethereum.org), в качестве аргумента вставить адрес задеплоенного ранее токена и текущую цену ETH к USD, целым числом, без дробной части;

`6` Нажать кнопку Deploy, расположенную в интерфейсе справаво вкладке Run;

`7` Скопировать адрес созданного контракта PreICO(ICO_stage1 или ICO_stage2),и в интерфейсе контракта Token вызвать функцию setSaleAddress куда в качестве параметра вствить адрес PreICO(ICO_stage1 или ICO_stage2) контракта;

`8` Контракты Token и PreICO(ICO_stage1 или ICO_stage2) готов к работе;

