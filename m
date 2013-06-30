Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37119 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3F3Lgc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 07:36:32 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AF5D17C067F
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 05:36:31 -0600 (MDT)
Date: Sun, 30 Jun 2013 07:36:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Shyam Kaushik <shyam@zadarastorage.com>
Subject: Re: question about transaction-abort-related commits
Message-ID: <20130630113628.GB4288@localhost.localdomain>
References: <CAOcd+r1=aZ-jBcTxgmxU5BiFGCG_10c_vouK6OE=wmG6o8++3g@mail.gmail.com>
 <20130624162401.GJ4288@localhost.localdomain>
 <CAOcd+r3OA4TW6XKBW73uDWGBbQmgma=ZV1ULkH8P8OAVA63_nQ@mail.gmail.com>
 <CAOcd+r1smWp=r2GO6CY3sp2ggpaUkkBKuc9K+rye1kywg3Tfaw@mail.gmail.com>
 <CAOcd+r0kx7_vdSjRrr48bZRkDcr2Ryyoc3GXVNpXgwZf-SkO3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r0kx7_vdSjRrr48bZRkDcr2Ryyoc3GXVNpXgwZf-SkO3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 11:29:14AM +0300, Alex Lyakas wrote:
> Hi Josef,
> 
> On Wed, Jun 26, 2013 at 5:16 PM, Alex Lyakas
> <alex.btrfs@zadarastorage.com> wrote:
> > Hi Josef,
> > Can you please help me with another question.
> >
> > I am looking at your patch:
> > Btrfs: fix chunk allocation error handling
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=0448748849ef7c593be40e2c1404f7974bd3aac6
> >
> > Here you changed the order of btrfs_make_block_group() vs
> > btrfs_alloc_dev_extent(), because we could have allocated from the
> > in-memory block group, before we have inserted the dev extent into a
> > tree. However, with this fix, I hit the deadlock[1] of
> > btrfs_alloc_dev_extent() that also wants to allocate a chunk and
> > recursively calls do_chunk_alloc, but then is stuck on chunk_mutex.
> >
> > Was this patch:
> > Btrfs: don't re-enter when allocating a chunk
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=c6b305a89b1903d63652691ad5eb9f05aa0326b8
> > introduced to fix this deadlock?
> 
> With these two patches ("Btrfs: fix chunk allocation error handling"
> and "Btrfs: don't re-enter when allocating a chunk"), I am hitting
> ENOSPC during metadata chunk allocation.
> 
> Upon entry into "do_chunk_alloc", I have only one METADATA block-group
> as follows:
> total_bytes=8388608
> bytes_used=7938048
> bytes_pinned=446464
> bytes_reserved=4096
> bytes_readonly=0
> bytes_may_use=3362816
> 
> As we see bytes_used+bytes_pinned+bytes_reserved==total_bytes
> 
> What happens next is that within __btrfs_alloc_chunk():
> - find_free_dev_extent() finds a free extent (metadata policy is SINGLE)
> - btrfs_alloc_dev_extent() fails with ENOSPC
> 
> (btrfs_make_block_group() is called after btrfs_alloc_dev_extent()
> with these patches).
> 
> What should be done in such situation, when there is not enough
> METADATA to allocate a device extent item, but we still don't allow
> allocating from the newly-created METADATA block group?
> 

So I had a third patch that you are likely missing that makes sure we try and
allocate chunks sooner specifically for this case

96f1bb57771f71bf1d55d5031a1cf47908494330

and then Miao made it better I think with this

3c76cd84e0c0d3ceb094a1020f8c55c2417e18d3

Thanks,

Josef
