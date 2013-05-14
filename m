Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3ENKzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:55:40 -0400
Date: Tue, 14 May 2013 18:55:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/8] Btrfs: introduce a tree for UUID to subvol ID
 mapping
Message-ID: <20130514105523.GD15127@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <cover.1368523154.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1368523154.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 14, 2013 at 11:36:52AM +0200, Stefan Behrens wrote:
> Mapping UUIDs to subvolume IDs is an operation with a high effort
> today. Today, the algorithm even has quadratic effort (based on the
> number of existing subvolumes), which means, that it takes minutes
> to send/receive a single subvolume if 10,000 subvolumes exist. But
> even linear effort would be too much since it is a waste. And these
> data structures to allow mapping UUIDs to subvolume IDs are created
> every time a btrfs send/receive instance is started.
> 
> So the issue to address is that Btrfs send / receive does not work
> as it is today when a high number of subvolumes exist.
> 
> It is much more efficient to maintain a searchable persistent data
> structure in the filesystem, one that is updated whenever a
> subvolume/snapshot is created and deleted, and when the received
> subvolume UUID is set by the btrfs-receive tool.
> 
> Therefore kernel code is added that is able to maintain data
> structures in the filesystem that allow to quickly search for a
> given UUID and to retrieve the subvol ID.
> 
> Now follows the lengthy justification, why a new tree was added
> instead of using the existing root tree:
> 
> The first approach was to not create another tree that holds UUID
> items. Instead, the items should just go into the top root tree.
> Unfortunately this confused the algorithm to assign the objectid
> of subvolumes and snapshots. The reason is that
> btrfs_find_free_objectid() calls btrfs_find_highest_objectid() for
> the first created subvol or snapshot after mounting a filesystem,
> and this function simply searches for the largest used objectid in
> the root tree keys to pick the next objectid to assign. Of course,
> the UUID keys have always been the ones with the highest offset
> value, and the next assigned subvol ID was wastefully huge.
> 
> To use any other existing tree did not look proper. To apply a
> workaround such as setting the objectid to zero in the UUID item
> key and to implement collision handling would either add
> limitations (in case of a btrfs_extend_item() approach to handle
> the collisions) or a lot of complexity and source code (in case a
> key would be looked up that is free of collisions). Adding new code
> that introduces limitations is not good, and adding code that is
> complex and lengthy for no good reason is also not good. That's the
> justification why a completely new tree was introduced.

I'd appreciate if some performance number appear here since it's a speedup.

thanks,
liubo


> 
> v1 -> v2:
> - All review comments from David Sterba, Josef Bacik and Jan Schmidt
>   are addressed.
>   The hugest change was to add a mechanism that handles the case that
>   the filesystem is mounted with an older kernel. Now that case is
>   detected when the filesystem is mounted with a newer kernel again,
>   and the UUID tree is updated in the background.
> 
> Stefan Behrens (8):
>   Btrfs: introduce a tree for items that map UUIDs to something
>   Btrfs: support printing UUID tree elements
>   Btrfs: create UUID tree if required
>   Btrfs: maintain subvolume items in the UUID tree
>   Btrfs: fill UUID tree initially
>   Btrfs: introduce uuid-tree-gen field
>   Btrfs: check UUID tree during mount if required
>   Btrfs: add mount option to force UUID tree checking
> 
>  fs/btrfs/Makefile      |   3 +-
>  fs/btrfs/ctree.h       |  65 ++++-
>  fs/btrfs/disk-io.c     |  62 ++++-
>  fs/btrfs/ioctl.c       |  74 +++++-
>  fs/btrfs/print-tree.c  |  82 +++++++
>  fs/btrfs/super.c       |   8 +-
>  fs/btrfs/transaction.c |  21 +-
>  fs/btrfs/uuid-tree.c   | 637 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/volumes.c     | 258 ++++++++++++++++++++
>  fs/btrfs/volumes.h     |   2 +
>  10 files changed, 1197 insertions(+), 15 deletions(-)
>  create mode 100644 fs/btrfs/uuid-tree.c
> 
> -- 
> 1.8.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
