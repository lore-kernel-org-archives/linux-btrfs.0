Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:41655 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932635Ab2HVPGX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 11:06:23 -0400
Date: Wed, 22 Aug 2012 17:01:09 +0200
From: David Sterba <dave@jikos.cz>
To: Peter Marheine <peter@taricorp.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Hung I/O, Kernel BUG with corrupt leaf (bad key order)
Message-ID: <20120822150109.GT17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CACvadSXOQK4ASWbocfnZnOAHbLa-Mr=j_0Dhw-ez_awddQNjRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACvadSXOQK4ASWbocfnZnOAHbLa-Mr=j_0Dhw-ez_awddQNjRA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 01:20:36PM -0500, Peter Marheine wrote:
> Hi all,
> 
> I'm running btrfs in a 3-disk RAID1 configuration. After a hard
> power-off, I'm seeing a lot of hung I/O tasks on this volume,
> apparently due to a corrupt leaf. I first noticed the problem on
> kernel 3.4.7, and it's persisted with 3.4.8. Relevant parts of the
> kernel log follow.

What was the filesystem activity when the power-off happened?

> 
> [   85.179621] block group 38684065792 has an wrong amount of free space
> [   85.179667] btrfs: failed to load free space cache for block group
> 38684065792
> [  136.969477] btrfs: corrupt leaf, bad key order:
> block=1478255230976,root=1, slot=26
> [  136.998953] btrfs: corrupt leaf, bad key order:
> block=1478255230976,root=1, slot=26
> [  137.000492] btrfs: corrupt leaf, bad key order:
> block=1478255230976,root=1, slot=26
> [  137.000708] btrfs: corrupt leaf, bad key order:
> block=1478255230976,root=1, slot=26
> [  153.912922] btrfs: corrupt leaf, bad key order:
> block=1478255230976,root=1, slot=26
> [  153.913020] ------------[ cut here ]------------
> [  153.913055] kernel BUG at fs/btrfs/inode.c:828!

 809 static noinline int cow_file_range(struct inode *inode,
 810                                    struct page *locked_page,
 811                                    u64 start, u64 end, int *page_started,
 812                                    unsigned long *nr_written,
 813                                    int unlock)
 814 {
[...]
 828         BUG_ON(btrfs_is_free_space_inode(root, inode));

plus the 'block group' warning above, this seems to be the but that Liu Bo
fixed with patches

Btrfs: fix a bug of writting free space cache with nodatacow option
Btrfs: fix a bug of writting free space cache during balance
Btrfs: fix btrfs_is_free_space_inode to recognize btree inode

that should appear in 3.6.

You can try to mount with 'nospace_cache' or 'clear_cache' if this would make a
difference to redo the space cache from scratch, but I'm afaraid the bad keys
will remain and would have to be removed via offline fsck.


david
