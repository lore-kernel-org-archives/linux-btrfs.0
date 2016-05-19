Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:47147 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbcESUVp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 16:21:45 -0400
Date: Thu, 19 May 2016 22:21:32 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, dsj@fb.com,
        Jakob =?iso-8859-1?Q?Sch=FCrz?= <wertstoffe@nurfuerspam.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] Btrfs: fix handling of faults from btrfs_copy_from_user
Message-ID: <20160519202132.GA7921@angband.pl>
References: <20160516210655.sfsjtj5oleeksaxq@floor.thefacebook.com>
 <20160517151451.GA3882@angband.pl>
 <20160517162344.3znjdtgvfke2ouke@floor.thefacebook.com>
 <20160517204726.GA4851@angband.pl>
 <20160519201020.i6kxgvnma7dp2vdk@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160519201020.i6kxgvnma7dp2vdk@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 04:10:20PM -0400, Chris Mason wrote:
> On Tue, May 17, 2016 at 10:47:27PM +0200, Adam Borowski wrote:
> > On Tue, May 17, 2016 at 12:23:44PM -0400, Chris Mason wrote:
> > > On Tue, May 17, 2016 at 05:14:51PM +0200, Adam Borowski wrote:
> > > > On Mon, May 16, 2016 at 05:06:55PM -0400, Chris Mason wrote:
> > > > > And now for the patch:
> > > > [...]
> > > > 
> > > > I then tried your test case, and alas:
> > > > 
> > > > Here's another run on an untainted kernel built with frame pointers etc:
> > > > 
> > > > ./dammitdave foo
> > > > [  236.500280] WARNING: CPU: 3 PID: 2940 at fs/btrfs/extent-tree.c:4233 btrfs_free_reserved_data_space_noquota+0xdd/0x160
> > > > rm foo
> > > > [  323.851851] BTRFS info (device sda1): btrfs_destroy_inode: leftover csum_bytes
> > > 
> > > Hmmm, some of your traces mentioned compression, do you have compression
> > > enabled?
> > 
> > Yeah, I mount with noatime,compress=lzo.
> > 
> > > I'll try to reproduce here, but could you try the same test on v4.5?
> > 
> > I've ran it for half an hour on vanilla 4.5.4 without any patches, no
> > failures of any kind.
>  >
> > > gdb> list *__btrfs_buffered_write+0x748
> > 
> > 0xffffffff8152eb78 is in __btrfs_buffered_write (fs/btrfs/file.c:1564).
> 
> Hmpf, even with forcing btrfs_delalloc_reserve_metadata to randomly
> fail, I can't trigger this warning.  Something else is going on.
> 
> For now I'm going to send in the fault patch, I'm confident this new
> warning is something unrelated.

After having balanced my sda1, I can't reproduce this anymore, even after
having re-allocated all chunks.

As the original bug produced different results (like, no warnings other than
btrfs_destroy_inode:csum_bytes), it indeed looks like an unrelated
regression of some kind.

I re-checked both real loads and dammitdave yesterday:
* 4.5.4 works ok
* 4.6.0 without your patch warns btrfs_destroy_inode
* 4.6.0 with the patch works ok
thus, it at least fixes that one.

Tested-by: Adam Borowski <kilobyte@angband.pl>

-- 
An imaginary friend squared is a real enemy.
