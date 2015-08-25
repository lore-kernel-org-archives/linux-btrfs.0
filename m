Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54065 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbHYGu4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 02:50:56 -0400
Date: Mon, 24 Aug 2015 23:50:50 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150825065050.GD20179@merlins.org>
References: <55D1406C.9040607@cn.fujitsu.com>
 <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org>
 <55DA6F06.7030605@cn.fujitsu.com>
 <20150824042800.GJ5602@merlins.org>
 <55DAA77E.10105@cn.fujitsu.com>
 <20150824141013.GM5602@merlins.org>
 <55DBD814.4000801@cn.fujitsu.com>
 <20150825052820.GC20179@merlins.org>
 <55DC0480.7080102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55DC0480.7080102@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 02:00:32PM +0800, Qu Wenruo wrote:
> Thanks for all your work and patient Marc,
 
Haha, no problem, you're doing a lot more work than I am :)

> Good to know there is backup.
> But as there is no higher generation one, so I'd assume that's not a
> normal transaction id failure case.

Right.

> Personally, I'd like to try btrfsck with gen 39537(--tree-root 29687808),
> but that's all my personal curiosity.
> Although my curiosity is driving me from finding a clue how it's
> damaged to try to recover it.

I gave that a shot, same thing:
myth:~# btrfs check --repair --tree-root 29687808 /dev/mapper/crypt_sdd1
enabling repair mode
parent transid verify failed on 29687808 wanted 39538 found 39537
parent transid verify failed on 29687808 wanted 39538 found 39537
parent transid verify failed on 29687808 wanted 39538 found 39537
parent transid verify failed on 29687808 wanted 39538 found 39537
Ignoring transid failure
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
wtf, parent 575708413952
cmds-check.c:4488: add_data_backref: Assertion `back->bytes != max_size` failed.
btrfs[0x8066a83]
btrfs[0x8066ab4]
btrfs[0x80679d8]
btrfs[0x806b4f2]
btrfs[0x806b9ea]
btrfs[0x806c5f9]
btrfs(cmd_check+0x1088)[0x806ee26]
btrfs(main+0x153)[0x80557d6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75154d3]
btrfs[0x80557fc]

> If you think it's OK, then just wipe it, nobody has the right to
> disturb your sleep.
 
That's not a problem :) 
I signed up for bugs when using btrfs, and am happy to help with reports
and getting the tools improved with your help and others' where
possible.

> At least we got some clue here.
> Some parent nodes got corrupted with much higher and non-exists generation.

Right. So should I try to go back in time until it works, but the
previous level doesn't work either:

enabling repair mode
parent transid verify failed on 7312195813376 wanted 39538 found 39535
parent transid verify failed on 7312195813376 wanted 39538 found 39535
parent transid verify failed on 7312195813376 wanted 39538 found 39535
parent transid verify failed on 7312195813376 wanted 39538 found 39535
Ignoring transid failure
parent transid verify failed on 29687808 wanted 39524 found 39537
parent transid verify failed on 29687808 wanted 39524 found 39537
parent transid verify failed on 29687808 wanted 39524 found 39537
parent transid verify failed on 29687808 wanted 39524 found 39537
Ignoring transid failure
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
cmds-check.c:3730: check_owner_ref: Assertion `rec->is_root` failed.
btrfs[0x8066a83]
btrfs[0x8066ab4]
btrfs[0x806acc4]
btrfs[0x806b9ea]
btrfs[0x806c5f9]
btrfs(cmd_check+0x1088)[0x806ee26]
btrfs(main+0x153)[0x80557d6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75104d3]
btrfs[0x80557fc]

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
