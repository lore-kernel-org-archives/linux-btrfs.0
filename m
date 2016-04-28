Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44671 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbcD1O3y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:29:54 -0400
Subject: Re: [PATCH RFC 10/16] btrfs-progs: fsck: Introduce function to check
 dev used space
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-11-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <9c0e11e1-8870-957d-5f82-8901e24d0a27@fb.com>
Date: Thu, 28 Apr 2016 10:29:35 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-11-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce function check_dev_item() to check used space with dev extent
> items.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  cmds-check.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>
> diff --git a/cmds-check.c b/cmds-check.c
> index 92c254f..e2d1ebf 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -328,6 +328,7 @@ struct root_item_info {
>  #define CROSSING_STRIPE_BOUNDARY (1 << 4) /* For kernel scrub workaround */
>  #define BAD_ITEM_SIZE	(1 << 5) /* Bad item size */
>  #define UNKNOWN_TYPE	(1 << 6) /* Unknown type */
> +#define ACCOUNTING_MISMATCH (1 << 7) /* Used space accounting error */
>
>  static void *print_status_check(void *p)
>  {
> @@ -9183,6 +9184,69 @@ out:
>  	return 0;
>  }
>
> +/*
> + * Check the used space is correct with the dev item
> + */
> +static int check_dev_item(struct btrfs_fs_info *fs_info,
> +			  struct extent_buffer *eb, int slot)
> +{
> +	struct btrfs_root *dev_root = fs_info->dev_root;
> +	struct btrfs_dev_item *dev_item;
> +	struct btrfs_path path;
> +	struct btrfs_key key;
> +	struct btrfs_dev_extent *ptr;
> +	u64 dev_id;
> +	u64 used;
> +	u64 total = 0;
> +	int ret;
> +
> +	dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
> +	dev_id = btrfs_device_id(eb, dev_item);
> +	used = btrfs_device_bytes_used(eb, dev_item);
> +
> +	key.objectid = dev_id;
> +	key.type = BTRFS_DEV_EXTENT_KEY;
> +	key.offset = 0;
> +
> +	btrfs_init_path(&path);
> +	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
> +	if (ret < 0) {
> +		btrfs_item_key_to_cpu(eb, &key, slot);
> +		error("Couldn't find any releative dev extent for dev[%llu, %u, %llu]",
> +		      key.objectid, key.type, key.offset);
> +		btrfs_release_path(&path);
> +		return -MISSING_REFERENCER;

Eh?  These are flags, not return values, lets not do negative numbers here.

> +	}
> +
> +	/* Iterate dev_extents to calculate the used space of a device */
> +	while (1) {
> +		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
> +
> +		if (key.objectid > dev_id)
> +			break;
> +		if (key.type != BTRFS_DEV_EXTENT_KEY || key.objectid != dev_id)
> +			goto next;
> +
> +		ptr = btrfs_item_ptr(path.nodes[0], path.slots[0],
> +				     struct btrfs_dev_extent);
> +		total += btrfs_dev_extent_length(path.nodes[0], ptr);
> +next:
> +		ret = btrfs_next_item(dev_root, &path);
> +		if (ret)
> +			break;
> +	}
> +	btrfs_release_path(&path);
> +
> +	if (used != total) {
> +		btrfs_item_key_to_cpu(eb, &key, slot);
> +		error("Dev extent's total-byte(%llu) is not equal to byte-used(%llu) in dev[%llu, %u, %llu]",
> +		      total, used, BTRFS_ROOT_TREE_OBJECTID,
> +		      BTRFS_DEV_EXTENT_KEY, dev_id);
> +		return -ACCOUNTING_MISMATCH;

Same here.  Thanks,

Josef
