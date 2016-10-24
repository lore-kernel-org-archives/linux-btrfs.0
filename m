Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54776 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965356AbcJXSLW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 14:11:22 -0400
Date: Mon, 24 Oct 2016 20:11:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PATCH 1/2] btrfs-progs: fsck: Add support to clear v1 free
 space cache.
Message-ID: <20161024181119.GK22935@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
 <20161019151342.GV11398@twin.jikos.cz>
 <2e89c014-bf97-e43e-9d7e-500a8ecdeadf@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2e89c014-bf97-e43e-9d7e-500a8ecdeadf@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 20, 2016 at 09:04:23AM +0800, Qu Wenruo wrote:
> >> +	/* Clear all free space cache inodes and its extent data */
> >> +	while (1) {
> >> +		bg_cache = btrfs_lookup_first_block_group(fs_info, current);
> >> +		if (!bg_cache)
> >> +			break;
> >> +		ret = btrfs_clear_free_space_cache(fs_info, bg_cache);
> >
> > The function can fail for a lot of reasons, what would be the filesystem
> > state when we exit here? Some of the inodes could be cleared completely,
> > the last one partially.  The function copes with a missing inode item
> > but I don't know how many other intermediate states could be left.
> 
> If we exit here, no damage for the filesystem will be done, since we are 
> protected by transaction.
> 
> As you can find, in btrfs_clear_free_space_cache(),
> it will only commit transaction if we fully cleaned the whole inode and 
> its free space header.

Ah I see, each blockgroup is killed inside a transaction. Then there's
one more to invalidate the super block cache generation.

> So we're quite safe here, free space header and inode are cleaned 
> atomically.
> 
> PS: We really need btrfs_abort_transaction(), or when we exit abnormally 
> we will get a lot of backtrace/warning on uncommitted transaction.

Yeah, the userspace is lacking behind kernel code in the transaction
error handling. Patches welcome, this might be a big change all over the
place, so I suggest to do it in smaller batches.
