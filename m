Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbAWQHO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 11:07:14 -0500
Date: Fri, 23 Jan 2015 17:07:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        guihc.fnst@cn.fujitsu.com, miaoxie@huawei.com, clm@fb.com
Subject: Re: [PULL] [PATCH 0/3] Btrfs, fixes for freezing vs pending changes
Message-ID: <20150123160712.GO13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1421776294.git.dsterba@suse.cz>
 <54C1B2B0.8040406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54C1B2B0.8040406@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 23, 2015 at 10:32:16AM +0800, Qu Wenruo wrote:
> 1) mount option change problem.
> In fact, there is no need to start a transaction to change mount option, 
> since it doesn't change anything
> on-disk.

The commit is to flush all the data that should see the same state
of the mount option.

> What we need is just to keep the mount option doesn't change during 
> transaction.

Yes, that's better.

> So I prefer to add a rwsem to protect mount_opt, each btrfs_transaction 
> will hold the read lock on it
> and upon btrfs_put_transaction(), read unlock it.
> btrfs_parse_option() should wait for write lock to change it.

Ok.

> BTW, current btrfs_parse_options() is not atomic, and for nospace_cache 
> mount option,
> SPACE_CACHE bit is always first set and later cleared, which created a 
> window btrfs_commit_transaction()
> can create space cache. I'll solve it by using copy-n-update method.

That's a unrelated fix to the pending changes, but a needed one.

> 2) Sysfs label/feature change problem
> For this problem, I agree with Miao to keep the behavior the same as 
> "btrfs pro set" command,
> since it will write something on disk.
> And since btrfs_ioctl_set_fslabel() is synchronized, I didn't see the 
> necessity to change it to async using sysfs.

The calling context is different from 'btrfs prop set' and direct ioctl
call. Details in the reply to your RFC mail.

> What do you think about this idea?
> Although, I'm afraid this may revert all your pending_changes 
> patches.... :-<

Given the timeframe of dev cycle, I think the minimal fix to avoid the
sync deadlock will probably go in, as is in the for-linus branch right
now.

Next, the lock-protected mount options would replace current way of
handling the inode_cache and we can see if we find different way how to
get rid of the async commit.
