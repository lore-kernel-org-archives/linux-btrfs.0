Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab3D2PMW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 11:12:22 -0400
Date: Mon, 29 Apr 2013 17:12:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] Btrfs: fill UUID tree initially
Message-ID: <20130429151220.GS16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1366384796.git.sbehrens@giantdisaster.de>
 <4199ee363b2c956e7ebdfcc9733546f3e8b88bdd.1366384796.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4199ee363b2c956e7ebdfcc9733546f3e8b88bdd.1366384796.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 19, 2013 at 05:41:06PM +0200, Stefan Behrens wrote:
> When the UUID tree is initially created, a task is spawned that
> walks through the root tree. For each found subvolume root_item,
> the uuid and received_uuid entries in the UUID tree are added.
> This is such a quick operation so that in case somebody wants
> to unmount the filesystem while the task is still running, the
> unmount is delayed until the UUID tree building task is finished.

I think the speed of this operation depends on the internal state of the
fs (fragmentation, number of subvols) and this could potentially take
long. I'd rather see the rescanning process to be interruptible and
restartable, but I take your word for now that it's quick.

> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -26,6 +26,7 @@
>  #include <linux/ratelimit.h>
>  #include <linux/kthread.h>
>  #include <linux/raid/pq.h>
> +#include <linux/semaphore.h>
>  #include <asm/div64.h>
>  #include "compat.h"
>  #include "ctree.h"
> @@ -50,6 +51,7 @@ static void btrfs_dev_stat_print_on_load(struct btrfs_device *device);
>  
>  static DEFINE_MUTEX(uuid_mutex);
>  static LIST_HEAD(fs_uuids);
> +static char empty_uuid[BTRFS_UUID_SIZE] = {0};

third empty_uuid!

> +static int btrfs_uuid_scan_kthread(void *data)
> +{
> +	struct btrfs_fs_info *fs_info = data;
> +	struct btrfs_root *root = fs_info->tree_root;
> +	struct btrfs_key key;
> +	struct btrfs_key max_key;
> +	struct btrfs_path *path = NULL;
> +	int ret = 0;
> +	struct extent_buffer *eb;
> +	int slot;
> +	struct btrfs_root_item root_item;
> +	u32 item_size;
> +	struct btrfs_trans_handle *trans;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		pr_warn("btrfs: UUID scan failed, ENOMEM\n");
> +		goto out;
> +	}
> +
> +	key.objectid = 0;
> +	key.type = BTRFS_ROOT_ITEM_KEY;
> +	key.offset = 0;
> +
> +	max_key.objectid = (u64)-1;
> +	max_key.type = BTRFS_ROOT_ITEM_KEY;
> +	max_key.offset = (u64)-1;
> +
> +	path->keep_locks = 1;
> +
> +	while (1) {

a big loop, add a cond_resched()

> +		ret = btrfs_search_forward(root, &key, &max_key, path, 0);
> +		if (ret) {
> +			if (ret < 0)
> +				pr_warn("btrfs: UUID scan failed, %d\n", ret);
> +			else
> +				ret = 0;
> +			break;
> +		}
> +
> +		if (key.type != BTRFS_ROOT_ITEM_KEY ||
> +		    (key.objectid < BTRFS_FIRST_FREE_OBJECTID &&
> +		     key.objectid != BTRFS_FS_TREE_OBJECTID) ||
> +		    key.objectid > BTRFS_LAST_FREE_OBJECTID)
> +			goto skip;
> +
> +		eb = path->nodes[0];
> +		slot = path->slots[0];
> +		item_size = btrfs_item_size_nr(eb, slot);
> +		if (item_size < sizeof(root_item))
> +			goto skip;
> +
> +		trans = NULL;
> +		read_extent_buffer(eb, &root_item,
> +				   btrfs_item_ptr_offset(eb, slot),
> +				   (int)sizeof(root_item));
> +		if (memcmp(root_item.uuid, empty_uuid, BTRFS_UUID_SIZE)) {
> +			trans = btrfs_start_transaction(fs_info->uuid_root, 2);
> +			if (IS_ERR(trans)) {
> +				ret = PTR_ERR(trans);
> +				break;
> +			}
> +			ret = btrfs_insert_uuid_subvol_item(trans,
> +							    fs_info->uuid_root,
> +							    root_item.uuid,
> +							    key.objectid);
> +			if (ret < 0) {
> +				pr_warn("btrfs: insert_uuid_received_subvol_item failed %d\n",
> +					ret);
> +				break;
> +			}
> +		}
> +
> +		if (memcmp(root_item.received_uuid, empty_uuid,
> +			   BTRFS_UUID_SIZE)) {
> +			if (!trans) {
> +				trans = btrfs_start_transaction(
> +						fs_info->uuid_root, 2);
> +				if (IS_ERR(trans)) {
> +					ret = PTR_ERR(trans);
> +					break;
> +				}
> +			}
> +			ret = btrfs_insert_uuid_received_subvol_item(
> +				trans, fs_info->uuid_root,
> +				root_item.received_uuid, key.objectid);
> +			if (ret < 0) {
> +				pr_warn("btrfs: insert_uuid_received_subvol_item failed %d\n",
> +					ret);
> +				break;
> +			}
> +		}
> +
> +		if (trans) {
> +			ret = btrfs_end_transaction(trans, fs_info->uuid_root);
> +			if (ret)
> +				break;
> +		}
> +
> +skip:
> +		btrfs_release_path(path);
> +		if (key.offset < (u64)-1) {
> +			key.offset++;
> +		} else if (key.type < BTRFS_ROOT_ITEM_KEY) {
> +			key.offset = 0;
> +			key.type++;
> +		} else if (key.objectid < (u64)-1) {
> +			key.offset = 0;
> +			key.type = 0;
> +			key.objectid++;
> +		} else {
> +			break;
> +		}
> +	}
> +
> +out:
> +	btrfs_free_path(path);
> +	if (ret)
> +		pr_warn("btrfs: start_transaction failed %d\n", ret);
> +	up(&fs_info->uuid_scan_sem);

Does lockdep need to be instructed that a semaphore is released in a
different thread it's been taken? Not sure if this wasn't for mutexes.

> +	return 0;
> +}
