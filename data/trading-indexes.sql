-- Creating these indexes after loading data
-- will make things run much faster!!!

CREATE INDEX indON trading.prices (ticker, market_date);
CREATE INDEX ON trading.transactions (txn_date, ticker);
CREATE INDEX ON trading.transactions (txn_date, member_id);
CREATE INDEX ON trading.transactions (member_id);
CREATE INDEX ON trading.transactions (ticker);