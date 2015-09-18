Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:51410 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753160AbbIRKP2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 06:15:28 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 18 Sep 2015 12:15:25 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <2ce9b35f73732b145e0f80b18f230a52@all.all>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
 <pan$5599c$cb01bfb8$910004c8$d38ea6b6@cox.net>
 <d2f30d85fa83b8b98af3c7e5a862044d@all.all> <55FA2D9A.1060405@cn.fujitsu.com>
 <e80ea6421a1f6a5f84c5d1032fc6a3e8@all.all> <55FA60C5.5090002@cn.fujitsu.com>
 <7a6f2d794fb6cbf7d598b92e3470201c@all.all> <55FA759E.6030707@cn.fujitsu.com>
 <3386a8bfa1a5796460306a53a668e47e@all.all> <55FA98D8.5010301@gmx.com>
 <53a5553a9c5301789e246144bb264e43@all.all> <55FB61E9.4000300@cn.fujitsu.com>
 <2ce9b35f73732b145e0f80b18f230a52@all.all>
Message-ID: <c605d4d156f9a880b216e89ca0705269@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-18 09:36, Stéphane Lesimple a écrit :
> Sure, I did a quota disable / quota enable before running the snapshot
> debug procedure, so the qgroups were clean again when I started :
> 
> qgroupid          rfer          excl     max_rfer     max_excl parent  
> child
> --------          ----          ----     --------     -------- ------  
> -----
> 0/5              16384         16384         none         none ---     
> ---
> 0/1906   1657848029184 1657848029184         none         none ---     
> ---
> 0/1909    124950921216  124950921216         none         none ---     
> ---
> 0/1911   1054587293696 1054587293696         none         none ---     
> ---
> 0/3270     23727300608   23727300608         none         none ---     
> ---
> 0/3314     23221784576   23221784576         none         none ---     
> ---
> 0/3341      7479275520    7479275520         none         none ---     
> ---
> 0/3367     24185790464   24185790464         none         none ---     
> ---
> 
> The test is running, I expect to post the results within an hour or 
> two.

Well, my system crashed twice while running the procedure...
By "crashed" I mean : the machine no longer pings, and nothing is logged 
in kern.log unfortunately :

[ 7096.735731] BTRFS info (device dm-3): qgroup scan completed 
(inconsistency flag cleared)
[ 7172.614851] BTRFS info (device dm-3): qgroup scan completed 
(inconsistency flag cleared)
[ 7242.870259] BTRFS info (device dm-3): qgroup scan completed 
(inconsistency flag cleared)
[ 7321.466931] BTRFS info (device dm-3): qgroup scan completed 
(inconsistency flag cleared)
[    0.000000] Initializing cgroup subsys cpuset

The even stranger part is that the last 2 stdout dump files exist but 
are empty :

-rw-r--r-- 1 root root   21 Sep 18 10:29 snap32.step5
-rw-r--r-- 1 root root 3.2K Sep 18 10:29 snap32.step6
-rw-r--r-- 1 root root 3.2K Sep 18 10:29 snap33.step1
-rw-r--r-- 1 root root 3.3K Sep 18 10:29 snap33.step3
-rw-r--r-- 1 root root   21 Sep 18 10:30 snap33.step5
-rw-r--r-- 1 root root 3.3K Sep 18 10:30 snap33.step6
-rw-r--r-- 1 root root 3.3K Sep 18 10:30 snap34.step1
-rw-r--r-- 1 root root    0 Sep 18 10:30 snap34.step3 <==
-rw-r--r-- 1 root root    0 Sep 18 10:30 snap34.step5 <==

The mentioned steps are as follows :

0) Rsync data from the next ext4 "snapshot" to the subvolume
1) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
2) Create the needed readonly snapshot on btrfs
3) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==
4) Avoid doing IO if possible until step 6)
5) Do 'btrfs quota rescan -⁠w' and save it <==
6) Do 'sync; btrfs qgroup show -⁠prce -⁠-⁠raw' and save the output <==

The resulting files are available here: 
http://speed47.net/tmp2/qgroup.tar.gz
The run2 is the more complete one, during run1 the machine crashed even 
faster.
It's interesting to note, however, that it seems to have crashed the 
same way and at the same step in the process.

As the machine is now, qgroups seems OK :

~# btrfs qgroup show -pcre --raw /tank/
qgroupid          rfer          excl     max_rfer     max_excl parent  
child
--------          ----          ----     --------     -------- ------  
-----
0/5              32768         32768         none         none ---     
---
0/1906   3315696058368 3315696058368         none         none ---     
---
0/1909    249901842432  249901842432         none         none ---     
---
0/1911   2109174587392 2109174587392         none         none ---     
---
0/3270     47454601216   47454601216         none         none ---     
---
0/3314     46408499200         32768         none         none ---     
---
0/3341     14991097856         32768         none         none ---     
---
0/3367     48371580928   48371580928         none         none ---     
---
0/5335     56523751424     280592384         none         none ---     
---
0/5336     60175253504    2599960576         none         none ---     
---
0/5337     45751746560     250888192         none         none ---     
---
0/5338     45804650496     186531840         none         none ---     
---
0/5339     45875167232     190521344         none         none ---     
---
0/5340     45933486080        327680         none         none ---     
---
0/5341     45933502464        344064         none         none ---     
---
0/5342     46442815488      35454976         none         none ---     
---
0/5343     46442520576      30638080         none         none ---     
---
0/5344     46448312320      36495360         none         none ---     
---
0/5345     46425235456      86204416         none         none ---     
---
0/5346     46081941504     119398400         none         none ---     
---
0/5347     46402715648      55615488         none         none ---     
---
0/5348     46403534848      50528256         none         none ---     
---
0/5349     45486301184      91463680         none         none ---     
---
0/5351     46414635008        393216         none         none ---     
---
0/5352     46414667776        294912         none         none ---     
---
0/5353     46414667776        294912         none         none ---     
---
0/5354     46406148096      24829952         none         none ---     
---
0/5355     46415986688      33103872         none         none ---     
---
0/5356     46406262784      23216128         none         none ---     
---
0/5357     46408245248      17408000         none         none ---     
---
0/5358     46416052224      25280512         none         none ---     
---
0/5359     46406336512      23158784         none         none ---     
---
0/5360     46408335360      25157632         none         none ---     
---
0/5361     46406402048      24395776         none         none ---     
---
0/5362     46415273984      32260096         none         none ---     
---
0/5363     46408499200         32768         none         none ---     
---
0/5364     14949441536     139812864         none         none ---     
---
0/5365     14996299776     176889856         none         none ---     
---
0/5366     14958616576     143065088         none         none ---     
---
0/5367     14919172096     100171776         none         none ---     
---
0/5368     14945968128     142409728         none         none ---     
---
0/5369     14991097856         32768         none         none ---     
---


But I'm pretty sure I can get that (u64)-1 value again by deleting 
snapshots. Shall I ? Or do you have something else for me to run before 
that ?

So, as a quick summary of this big thread, it seems I've been hitting 3 
bugs, all reproductible :
- kernel BUG on balance (this original thread)
- negative or zero "excl" qgroups
- hard freezes without kernel trace when playing with snapshots and 
quota

Still available to dig deeper where needed.

-- 
Stéphane.

