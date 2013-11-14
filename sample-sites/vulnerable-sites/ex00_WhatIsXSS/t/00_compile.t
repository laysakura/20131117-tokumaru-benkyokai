use strict;
use warnings;
use Test::More;


use ex00_WhatIsXSS;
use ex00_WhatIsXSS::Web;
use ex00_WhatIsXSS::Web::View;
use ex00_WhatIsXSS::Web::ViewFunctions;

use ex00_WhatIsXSS::DB::Schema;
use ex00_WhatIsXSS::Web::Dispatcher;


pass "All modules can load.";

done_testing;
