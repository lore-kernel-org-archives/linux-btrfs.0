Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:36779 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbdFUPQm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 11:16:42 -0400
Received: by mail-qt0-f180.google.com with SMTP id i2so11760361qta.3
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 08:16:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGqmi75snUUa3MzBVzu6wcWV6qzPpOBmCU-Ug4xGBVuz_E5gEg@mail.gmail.com>
References: <CAGqmi75fwUz4CcktjTm=KFSUSpmqeb0RDQrAgjL39KGqQMs=rQ@mail.gmail.com>
 <CAGqmi75snUUa3MzBVzu6wcWV6qzPpOBmCU-Ug4xGBVuz_E5gEg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 21 Jun 2017 18:16:00 +0300
Message-ID: <CAGqmi77S7nzv73kNwVGGVuKhJLF7aY9gZYQT+JuN0LPEdY4eAg@mail.gmail.com>
Subject: Re: RFC: Compression - calculate entropy for data set
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've done with heuristic method,
so i post some performance test output:
(I store test data in /run/user/$UID/, and script just ran programm 20000 times)
###
# Performance test will measure initialization time
# And remove it from run time of tests
# This may be inaccurate in some cases
# But this allow see speed difference
./performance_test.sh

Test good compressible data: 128k
AVG Initialization time: 17018ms
avg mean:       3240ms
shannon float:  11537ms
shannon integ:  9933ms
heuristic:      2060ms
gzip -ck -3 /run/user/1000/test_data.bin:       19767ms
lzop -ck -3 /run/user/1000/test_data.bin:       12393ms
lzop -ck -1 /run/user/1000/test_data.bin:       13660ms
- - - - -
Test half compressible data: 128k
AVG Initialization time: 15820ms
avg mean:       3302ms
shannon float:  8680ms
shannon integ:  9659ms
heuristic:      3207ms // 128*20000/1024/3 ~ 800 Mb/s
gzip -ck -3 /run/user/1000/test_data.bin:       57245ms
lzop -ck -3 /run/user/1000/test_data.bin:       14175ms
lzop -ck -1 /run/user/1000/test_data.bin:       15392ms
- - - - -
Test bad compressible data: 128k
AVG Initialization time: 16878ms
avg mean:       4410ms
shannon float:  7113ms
shannon integ:  6777ms
heuristic:      2162ms  // 128*20000/1024/2 ~ 1250 Mb/s
gzip -ck -3 /run/user/1000/test_data.bin:       110578ms
lzop -ck -3 /run/user/1000/test_data.bin:       14238ms
lzop -ck -1 /run/user/1000/test_data.bin:       15332ms
- - - - -
Test good compressible data: 8k
AVG Initialization time: 17526ms
avg mean:       1683ms
shannon float:  5762ms
shannon integ:  2427ms
heuristic:      1858ms
gzip -ck -3 /run/user/1000/test_data.bin:       2745ms
lzop -ck -3 /run/user/1000/test_data.bin:       10221ms
lzop -ck -1 /run/user/1000/test_data.bin:       11960ms
- - - - -
Test half compressible data: 8k
AVG Initialization time: 17513ms
avg mean:       1853ms
shannon float:  1933ms
shannon integ:  2572ms
heuristic:      2571ms
gzip -ck -3 /run/user/1000/test_data.bin:       4167ms
lzop -ck -3 /run/user/1000/test_data.bin:       9502ms
lzop -ck -1 /run/user/1000/test_data.bin:       10923ms
- - - - -
Test bad compressible data: 8k
AVG Initialization time: 18164ms
avg mean:       -28ms
shannon float:  312ms
shannon integ:  1891ms
heuristic:      542ms
gzip -ck -3 /run/user/1000/test_data.bin:       6407ms
lzop -ck -3 /run/user/1000/test_data.bin:       9088ms
lzop -ck -1 /run/user/1000/test_data.bin:       10741ms

So as you can see most of time heuristic test are 5 times faster then
direct compression.
I did some base testing on that (trying  random pieces of data: blocks
from VM images, Photos, Texts, /dev/zero, /dev/urandom)
And heuristic method are pretty accurate, most of magic are happens in [2].


I think that in near time i will try make some kernel patch set for that.
If someone interest in that, you can look code and do some tests on your data
I appreciate any feedback!

Thanks!

P.S.
[1] https://github.com/Nefelim4ag/Entropy_Calculation
[2] https://github.com/Nefelim4ag/Entropy_Calculation/blob/master/heuristic.c

-- 
Have a nice day,
Timofey.
