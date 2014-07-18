Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54256 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760545AbaGRIqi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 04:46:38 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 05A4D3EE0AE
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 17:46:37 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 0A72DAC0A00
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 17:46:36 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id A0A971DB8037
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 17:46:35 +0900 (JST)
Message-ID: <53C8DEB0.1060404@jp.fujitsu.com>
Date: Fri, 18 Jul 2014 17:45:36 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kevin Brandstatter <icarusthecow@gmail.com>
Subject: [BUG] "Quota Ignored On write" problem still exist with 3.16-rc5
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef, Chris,

I found "Quota Ignored On write" problem still exist with 3.16-rc5,
which Kevin reported before.

Kevin's report:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35292.html

The result of bisect:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35304.html

> I bisected and found the bad commit is the following patch.
> 
> ===============================================================================
> commit fcebe4562dec83b3f8d3088d77584727b09130b2
> Author: Josef Bacik <jba...@fb.com>
> Date:   Tue May 13 17:30:47 2014 -0700
> 
>     Btrfs: rework qgroup accounting
> ===============================================================================
> 
> Josef, please take a look at this patch.

Reproducer:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg35299.html

Could you tell me the progress of fixing this bug?
In addition, could you fix it by 3.16?

command log:
===============================================================================
# ./test.sh
+ uname -a
Linux luna.soft.fujitsu.com 3.16.0-rc5 #2 SMP Tue Jul 15 13:39:46 JST 2014 x86_64 x86_64 x86_64 GNU/Linux
+ df -T /test7
Filesystem     Type  1K-blocks  Used Available Use% Mounted on
/dev/sdc7      btrfs  29296640  1536  27169536   1% /test7
+ btrfs quota ena /test7
+ cd /test7
+ btrfs sub cre test
Create subvolume './test'
+ btrfs sub l -a /test7
ID 270 gen 66 top level 5 path test
+ btrfs qg lim 1G test                          # limit test subvol to 1GB
+ btrfs qg show -pcre /test7
qgroupid rfer  excl  max_rfer   max_excl parent  child
-------- ----  ----  --------   -------- ------  -----
0/5      16384 16384 0          0        ---     ---
0/270    16384 16384 1073741824 0        ---     ---
+ dd if=/dev/zero of=test/file0 bs=1M count=2000
2000+0 records in
2000+0 records out
2097152000 bytes (2.1 GB) copied, 9.67876 s, 217 MB/s   # write 2GB. It's a bug!
+ sync
+ ls -lisaR /test7
/test7:
total 20
256 16 drwxr-xr-x   1 root root    8 Jul 18 15:12 .
  2  4 drwxr-xr-x. 43 root root 4096 Jul 16 08:34 ..
256  0 drwxr-xr-x   1 root root   10 Jul 18 15:17 test

/test7/test:
total 2048016
256       0 drwxr-xr-x 1 root root         10 Jul 18 15:17 .
256      16 drwxr-xr-x 1 root root          8 Jul 18 15:12 ..
257 2048000 -rw-r--r-- 1 root root 2097152000 Jul 18 15:17 file0
+ btrfs qg show -pcre /test7
qgroupid rfer       excl       max_rfer   max_excl parent  child
-------- ----       ----       --------   -------- ------  -----
0/5      16384      16384      0          0        ---     ---
0/270    2097168384 2097168384 1073741824 0        ---     ---
+ btrfs quota dis /test7
+ btrfs sub del test
Transaction commit: none (default)
Delete subvolume '/test7/test'
+ set +x
#
===============================================================================

  NOTE:
  The reproducer here (./test.sh) is a bit different from above-mentioned
  one because of some reason.

Thanks,
Satoru

