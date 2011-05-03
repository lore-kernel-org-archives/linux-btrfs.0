From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 13:43:04 +0200
Message-ID: <4DBFEA48.3000406@birkenwald.de>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org> <1304420831-sup-4737@think> <4DBFE75C.2000104@birkenwald.de> <1304422493-sup-6212@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304422493-sup-6212@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Using compression is not a problem, but in order to reduce the maximum
> amount of ram we need to uncompress an extent, we enforce a max size on
> the extent.  So you'll tend to have more extents, but they should be
> close together on disk.
> 
> Could you please do a filefrag -v on the file?  Lets see how bad it
> really is.


root@schleppi:~# filefrag -v
/usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1
Filesystem type is: 9123683e
File size of /usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1 is
9361528 (2286 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  4542111              32
   1      32  4542134  4542142     32
   2      64  4573263  4542165     32
   3      96  4573285  4573294     32
   4     128  4579639  4573316     32
   5     160  4579664  4579670     32
   6     192  4581178  4579695     32
   7     224  4579811  4581209     32
   8     256  4579836  4579842     32
   9     288  4579861  4579867     32
  10     320  4579884  4579892     32
  11     352  4580698  4579915     32
  12     384  4580720  4580729     32
  13     416  4580746  4580751     32
  14     448  4580768  4580777     32
  15     480  4580793  4580799     32
  16     512  4580819  4580824     32
  17     544  4581238  4580850     32
  18     576  4600396  4581269     32
  19     608  4600422  4600427     32
  20     640  4600447  4600453     32
  21     672  4600472  4600478     32
  22     704  4600498  4600503     32
  23     736  4600523  4600529     32
  24     768  4601483  4600554     32
  25     800  4601509  4601514     32
  26     832  4601534  4601540     32
  27     864  4601558  4601565     32
  28     896  4601583  4601589     32
  29     928  4601608  4601614     32
  30     960  4618420  4601639     32
  31     992  4618443  4618451     32
  32    1024  4541221  4618474     32
  33    1056  4618463  4541252     32
  34    1088  4618485  4618494     32
  35    1120  4618505  4618516     32
  36    1152  4579536  4618536     32
  37    1184  4579688  4579567     32
  38    1216  4579740  4579719     32
  39    1248  4618526  4579771     32
  40    1280  4618544  4618557     32
  41    1312  4618563  4618575     32
  42    1344  4618583  4618594     32
  43    1376  4618605  4618614     32
  44    1408  4618626  4618636     32
  45    1440  4618652  4618657     32
  46    1472  4618677  4618683     32
  47    1504  4618703  4618708     32
  48    1536  4618728  4618734     32
  49    1568  4618754  4618759     32
  50    1600  4618774  4618785     32
  51    1632  4618782  4618805     32
  52    1664  4561195  4618813     32
  53    1696  4600548  4561226     32
  54    1728  4618793  4600579     32
  55    1760  4618807  4618824     32
  56    1792  4539912  4618838     32
  57    1824  4542619  4539943     32
  58    1856  4556887  4542650     32
  59    1888  4601632  4556918     32
  60    1920  4558150  4601663     32
  61    1952  4561224  4558181     32
  62    1984  4618816  4561255     32
  63    2016  4618835  4618847     32
  64    2048  4618861  4618866     32
  65    2080  4618881  4618892     32
  66    2112  4618901  4618912     32
  67    2144  4618917  4618932     32
  68    2176  4539241  4618948     32
  69    2208  4539915  4539272     32
  70    2240  4539985  4539946     32
  71    2272  4540096  4540016     14 eof
/usr/lib/x86_64-linux-gnu/gcc/x86_64-linux-gnu/4.4/cc1: 72 extents found

Bernhard
