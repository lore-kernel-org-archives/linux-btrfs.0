Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161067Ab3FTTrI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 15:47:08 -0400
Date: Thu, 20 Jun 2013 12:47:04 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
Message-ID: <20130620194704.GC32674@lenny.home.zabbo.net>
References: <cover.1371749051.git.sbehrens@giantdisaster.de>
 <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ef484aa41751485fc6301ce78b5e3cddaa3f9a52.1371749051.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> +/* for items that use the BTRFS_UUID_KEY */
> +#define BTRFS_UUID_ITEM_TYPE_SUBVOL	0 /* for UUIDs assigned to subvols */
> +#define BTRFS_UUID_ITEM_TYPE_RECEIVED_SUBVOL	1 /* for UUIDs assigned to
> +						   * received subvols */
> +
> +/* a sequence of such items is stored under the BTRFS_UUID_KEY */
> +struct btrfs_uuid_item {
> +	__le16 type;	/* refer to BTRFS_UUID_ITEM_TYPE* defines above */
> +	__le32 len;	/* number of following 64bit values */
> +	__le64 subid[0];	/* sequence of subids */
> +} __attribute__ ((__packed__));
> +

[...]

>  /*
> + * Stores items that allow to quickly map UUIDs to something else.
> + * These items are part of the filesystem UUID tree.
> + * The key is built like this:
> + * (UUID_upper_64_bits, BTRFS_UUID_KEY, UUID_lower_64_bits).
> + */
> +#if BTRFS_UUID_SIZE != 16
> +#error "UUID items require BTRFS_UUID_SIZE == 16!"
> +#endif
> +#define BTRFS_UUID_KEY	251

Why do we need this btrfs_uuid_item structure?  Why not set the key type
to either _SUBVOL or _RECEIVED_SUBVOL instead of embedding structs with
those types under items with the constant BTRFS_UUID_KEY.  Then use the
item size to determine the number of u64 subids.  Then the item has a
simple array of u64s in the data which will be a lot easier to work
with.

> +/* btrfs_uuid_item */
> +BTRFS_SETGET_FUNCS(uuid_type, struct btrfs_uuid_item, type, 16);
> +BTRFS_SETGET_FUNCS(uuid_len, struct btrfs_uuid_item, len, 32);
> +BTRFS_SETGET_STACK_FUNCS(stack_uuid_type, struct btrfs_uuid_item, type, 16);
> +BTRFS_SETGET_STACK_FUNCS(stack_uuid_len, struct btrfs_uuid_item, len, 32);

This would all go away.

> +/*
> + * One key is used to store a sequence of btrfs_uuid_item items.
> + * Each item in the sequence contains a type information and a sequence of
> + * ids (together with the information about the size of the sequence of ids).
> + * {[btrfs_uuid_item type0 {id0, id1, ..., idN}],
> + *  ...,
> + *  [btrfs_uuid_item typeZ {id0, id1, ..., idN}]}
> + *
> + * It is forbidden to put multiple items with the same type under the same key.
> + * Instead the sequence of ids is extended and used to store any additional
> + * ids for the same item type.

This constraint, and the cost of ensuring it and repairing violations,
would go away.

> +static struct btrfs_uuid_item *btrfs_match_uuid_item_type(
> +		struct btrfs_path *path, u16 type)
> +{
> +	struct extent_buffer *eb;
> +	int slot;
> +	struct btrfs_uuid_item *ptr;
> +	u32 item_size;
> +
> +	eb = path->nodes[0];
> +	slot = path->slots[0];
> +	ptr = btrfs_item_ptr(eb, slot, struct btrfs_uuid_item);
> +	item_size = btrfs_item_size_nr(eb, slot);
> +	do {
> +		u16 sub_item_type;
> +		u64 sub_item_len;
> +
> +		if (item_size < sizeof(*ptr)) {
> +			pr_warn("btrfs: uuid item too short (%lu < %d)!\n",
> +				(unsigned long)item_size, (int)sizeof(*ptr));
> +			return NULL;
> +		}
> +		item_size -= sizeof(*ptr);
> +		sub_item_type = btrfs_uuid_type(eb, ptr);
> +		sub_item_len = btrfs_uuid_len(eb, ptr);
> +		if (sub_item_len * sizeof(u64) > item_size) {
> +			pr_warn("btrfs: uuid item too short (%llu > %lu)!\n",
> +				(unsigned long long)(sub_item_len *
> +						     sizeof(u64)),
> +				(unsigned long)item_size);
> +			return NULL;
> +		}
> +		if (sub_item_type == type)
> +			return ptr;
> +		item_size -= sub_item_len * sizeof(u64);
> +		ptr = 1 + (struct btrfs_uuid_item *)
> +			(((char *)ptr) + (sub_item_len * sizeof(u64)));
> +	} while (item_size);
>
> +static int btrfs_uuid_tree_lookup_prepare(struct btrfs_root *uuid_root,
> +					  u8 *uuid, u16 type,
> +					  struct btrfs_path *path,
> +					  struct btrfs_uuid_item **ptr)
> +{
> +	int ret;
> +	struct btrfs_key key;
> +
> +	if (!uuid_root) {
> +		WARN_ON_ONCE(1);
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	btrfs_uuid_to_key(uuid, &key);
> +
> +	ret = btrfs_search_slot(NULL, uuid_root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	*ptr = btrfs_match_uuid_item_type(path, type);
> +	if (!*ptr) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +
> +out:
> +	return ret;
> +}

All of this is replaced with the simple search_slot in the caller.

> +	offset = (unsigned long)ptr;
> +	while (sub_item_len > 0) {
> +		u64 data;
> +
> +		read_extent_buffer(eb, &data, offset, sizeof(data));
> +		data = le64_to_cpu(data);
> +		if (data == subid) {
> +			ret = 0;
> +			break;
> +		}
> +		offset += sizeof(data);
> +		sub_item_len--;
> +	}

This could be cleaned up a bit by comparing an on-stack little-endian
input subid with each little-endian subid in the item with
memcmp_extent_buffer().

> +	ret = btrfs_insert_empty_item(trans, uuid_root, path, &key,
> +				      sizeof(*ptr) + sizeof(subid));
> +	if (ret == -EEXIST) {
> +		ptr = btrfs_match_uuid_item_type(path, type);
> +		if (ptr) {
[...]
> +			btrfs_extend_item(uuid_root, path, sizeof(subid));

How does this extension avoid the BUG when the leaf containing the item
doesn't have room for the new subid?

- z
