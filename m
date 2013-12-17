Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3LQBG3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 20:06:29 -0500
Date: Tue, 17 Dec 2013 02:06:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: move the extent buffer radix tree into the fs_info
Message-ID: <20131217010627.GK6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1387218386-5339-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387218386-5339-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 16, 2013 at 01:26:26PM -0500, Josef Bacik wrote:
> I need to create a fake tree to test qgroups and I don't want to have to setup a
> fake btree_inode.  The fact is we only use the radix tree for the fs_info, so
> everybody else who allocates an extent_io_tree is just wasting the space anyway.
> This patch moves the radix tree and its lock into btrfs_fs_info so there is less
> stuff I have to fake to do qgroup sanity tests.  Thanks,

This would make the fs_info::buffer_lock a global hotspot if
alloc_extent_buffer and release_extent_buffer are called frequently.

But, you can get rid of the buffer_lock completely, because the radix
tree can be safely protected by rcu_read_lock/_unlock:

* alloc_extent_buffer uses radix_preload that turns off preepmtion by
itself, so the lock here would be pointless

* release_extent_buffer locks around radix_tree_delete, here a rcu
locking will be ok as well

* radix_tree_lookup(buffer_tree) is done in rcu section already

I'm ok with this patch as an incremental change, replacing the locks with
RCU is trivial but I'd rather take a conservative approach should we
need to bisect that someday.


David "I should not send RCU comments at 2 a.m." Sterba
