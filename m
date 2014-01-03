Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaACRwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:52:46 -0500
Date: Fri, 3 Jan 2014 18:52:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 07/11] btrfs: Add noinode_cache mount option.
Message-ID: <20140103175244.GR6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1388729434-19799-8-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1388729434-19799-8-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 02:10:30PM +0800, Qu Wenruo wrote:
> Add noinode_cache mount option to disable inode map cache with
> remount option.

This looks almost safe, there's a sync_filesystem called before the
filesystem's remount handler, the transaction gets committed and flushes
all tha data related to inode_cache.

The caching thread keeps running, which is not a serious problem as
it'll finish at umount time, only consuming resources.

There's a window between sync_filesystem and successful remount when the
INODE_MAP_CACHE bit is set and the cache could be used to get a free ino,
then the INODE_MAP_CACHE is cleared but the ino cache remains is not
synced back to disk, normally called from transaction commit via
btrfs_unpin_free_ino. I haven't looked if something else blocks that to
happen.

I'd leave this patch out for now, it probably needs more code updates
than just unsetting the bit.

david
