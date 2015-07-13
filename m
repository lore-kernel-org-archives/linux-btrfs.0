Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9555 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbbGMRCk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 13:02:40 -0400
Date: Mon, 13 Jul 2015 13:02:34 -0400
From: Chris Mason <clm@fb.com>
To: Alex Lyakas <alex@zadarastorage.com>
CC: Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: question about should_cow_block() and BTRFS_HEADER_FLAG_WRITTEN
Message-ID: <20150713170234.GB17513@ret.masoncoding.com>
References: <D9085F65B8B44087B5F6144AC9356BBB@alyakaslap>
 <CAL3q7H6Escicg5PWCd4gw_88TXTEWznqBKRGES0f0gzTU-=HeQ@mail.gmail.com>
 <CAOcd+r3x3vprnMLFzhX4XBt12dq26DCBmHLiDz-z9YvVOKx-Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r3x3vprnMLFzhX4XBt12dq26DCBmHLiDz-z9YvVOKx-Ww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 13, 2015 at 06:55:29PM +0200, Alex Lyakas wrote:
> Filipe,
> Thanks for the explanation. Those reasons were not so obvious for me.
> 
> Would it make sense not to COW the block in case-1, if we are mounted
> with "notreelog"? Or, perhaps, to check that the block does not belong
> to a log tree?
> 

Hi Alex,

The crc rules are the most important, we have to make sure the block
isn't changed while it is in flight.  Also, think about something like
this:

transaction write block A, puts pointer to it in the btree, generation Y

<hard disk properly completes the IO>

transaction rewrites block A, same generation Y

<hard disk drops the IO on the floor and never does it>

Later on, we try to read block A again.  We find it has the correct crc
and the correct generation number, but the contents are actually wrong.

> The second case is more difficult. One problem is that
> BTRFS_HEADER_FLAG_WRITTEN flag ends up on disk. So if we write a block
> due to memory pressure (this is what I see happening), we complete the
> writeback, release the extent buffer, and pages are evicted from the
> page cache of btree_inode. After some time we read the block again
> (because we want to modify it in the same transaction), but its header
> is already marked as BTRFS_HEADER_FLAG_WRITTEN on disk. Even though at
> this point it should be safe to avoid COW, we will re-COW.
> 
> Would it make sense to have some runtime-only mechanism to lock-out
> the write-back for an eb? I.e., if we know that eb is not under
> writeback, and writeback is locked out from starting, we can redirty
> the block without COW. Then we allow the writeback to start when it
> wants to.
> 
> In one of my test runs, btrfs had 6.4GB of metadata (before
> raid-induced overhead), but during a particular transaction total of
> 10GB of metadata (again, before raid-induced overhead) was written to
> disk. (Thisis  total of all ebs having
> header->generation==curr_transid, not only during commit of the
> transaction). This particular run was with "notreelog".
> 
> Machine had 8GB of RAM. Linux allows the btree_inode to grow its
> page-cache upto ~6.9GB (judging by btree_inode->i_mapping->nrpages).
> But even though the used amount of metadata is less than that, this
> re-COW'ing of already-COW'ed blocks seems to cause page-cache
> trashing...

Interesting.  We've addressed this in the past with changes to the
writepage(s) callback for the btree, basically skipping memory pressure
related writeback if there isn't that much dirty.  There is a lot of
room to improve those decisions, like preferring to write leaves over
nodes, especially full leaves that are not likely to change again.

-chris
