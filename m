Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:40129 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752145AbbIPNEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 09:04:22 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id B87F3BC33
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 15:04:20 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 16 Sep 2015 15:04:20 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <55F9486F.4040302@googlemail.com>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
Message-ID: <0973de930ee87e102c533c719807b748@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-16 12:46, Holger Hoffstätte a écrit :
> On 09/16/15 12:28, Stéphane Lesimple wrote:
>> Nice to know that this bug was already somewhat known, but I can
>> confirm that it actually doesn't come from an ext4 conversion on my
>> case.
> 
> In that case the "crossing stripe boundary" messages are false 
> positives
> in btrfs-progs-4.2: 
> http://www.spinics.net/lists/linux-btrfs/msg47059.html
> 
> This should be fixed in the next release.

Out of curiosity I compiled the btrfs-progs-4.2 release patched with the 
diff you're referencing to fix the off-by-one error, and ran a btrfsck 
again.
Indeed those errors disappear and my filesystem seems clean in this 
regard. I also disabled quota because it has almost for sure nothing to 
do with the bug, and now btrsfck is 100% happy:

---------
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
Checking filesystem on 
/dev/mapper/luks-WDC_WD30EZRX-00MMMB0_WD-WCAWZ3013164
UUID: 6bec1608-d9c0-453e-87eb-8b8663c9010d
found 2922178546042 bytes used err is 0
total csum bytes: 2849102736
total tree bytes: 4697341952
total fs tree bytes: 1276395520
total extent tree bytes: 90963968
btree space waste bytes: 640514848
file data blocks allocated: 2959998808064
  referenced 2959997575168
btrfs-progs v4.2-dirty
---------

So this is even more interesting, my filesystem is reported by scrub and 
fsck as being in perfect shape, but still crashes the kernel from time 
to time on balance.

Next step: reboot under 4.3.0-rc1 with my printk's, run a balance, log 
the crash, reboot, balance again, crash again, and compare. If the same 
filesystem spot triggers the crash twice then it would be an undetected 
metadata/filesystem internal integrity corruption, if it crashes at 2 
different spots, then maybe it's some kind of race condition that, for 
some reason, my system hits way more often than others.

-- 
Stéphane.

