Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns211617.ip-188-165-215.eu ([188.165.215.42]:45795 "EHLO
	mx.speed47.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752696AbbIQG3a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 02:29:30 -0400
Received: from rc.speed47.net (nginx [192.168.80.2])
	by box.speed47.net (Postfix) with ESMTP id C73A4BC94
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2015 08:29:28 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 17 Sep 2015 08:29:28 +0200
From: =?UTF-8?Q?St=C3=A9phane_Lesimple?= <stephane_btrfs@lesimple.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at linux-4.2.0/fs/btrfs/extent-tree.c:1833 on
 rebalance
In-Reply-To: <0973de930ee87e102c533c719807b748@all.all>
References: <9c864637fe7676a8b7badc5ddd7a4e0c@all.all>
 <2c00c4b7c15e424659fb2e810170e32e@all.all> <55F83181.9010201@fb.com>
 <532aadf0f92d08d3d2b274173548aee1@all.all>
 <pan$e885$1290ceef$c5017ead$b38037f1@cox.net>
 <f81878fadaf2980a72522e54010e0415@all.all> <55F9486F.4040302@googlemail.com>
 <0973de930ee87e102c533c719807b748@all.all>
Message-ID: <dcac037d814833260d68ec58033a5e51@all.all>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 2015-09-16 15:04, Stéphane Lesimple a écrit :
> I also disabled quota because it has almost for sure nothing
> to do with the bug

As it turns out, it seems that this assertion was completely wrong.

I've got balance running for more than 16 hours now, without a crash. 
This is almost 50% of the work done without any issue. Before, a crash 
would happen within minutes, sometimes 1 hour, but not much more. The 
problem is, I didn't change anything to the filesystem, well, appart 
from the benign quota disable. So Qu's question about the qgroups errors 
in fsck made me wonder : if I activate quota again, it'll still continue 
to balance flawlessly, right ?

Well, it doesn't. I just ran btrfs quota enable on my filesystem, it 
completed successfully after some minutes (rescan -s said that no rescan 
was pending). Then less than 5 minutes later, the kernel crashed, at the 
same BUG_ON() than usually :

[60156.062082] BTRFS info (device dm-3): relocating block group 
972839452672 flags 129
[60185.203626] BTRFS info (device dm-3): found 1463 extents
[60414.452890] {btrfs} in insert_inline_extent_backref, got owner < 
BTRFS_FIRST_FREE_OBJECTID
[60414.452894] {btrfs} with bytenr=5197436141568 num_bytes=16384 
parent=5336636473344 root_objectid=3358 owner=1 offset=0 refs_to_add=1 
BTRFS_FIRST_FREE_OBJECTID=256
[60414.452924] ------------[ cut here ]------------
[60414.452928] kernel BUG at fs/btrfs/extent-tree.c:1837!

owner is=1 again at this point in the code (this is still kernel 
4.3.0-rc1 with my added printks).

So I'll disable quota, again, and resume the balance. If I'm right, it 
should proceed without issue for 18 more hours !

Qu, my filesystem is at your disposal :)

-- 
Stéphane.


