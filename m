Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab3FZTzo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 15:55:44 -0400
Date: Wed, 26 Jun 2013 12:55:40 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
Message-ID: <20130626195540.GA3907@lenny.home.zabbo.net>
References: <cover.1372250828.git.sbehrens@giantdisaster.de>
 <dcc3cedb7e15d11570aab0350113bc47eebc262b.1372250828.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dcc3cedb7e15d11570aab0350113bc47eebc262b.1372250828.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> +	if (!uuid_root) {
> +		WARN_ON_ONCE(1);
> +		ret = -ENOENT;
> +		goto out;
> +	}

WARN_ON_ONCE specifically returns the condition so that you can write:

	if (WARN_ON_ONCE(!uuid_root)) {
		ret = -ENOENT;
		goto out;
	}

> +	while (item_size) {
> +		u64 data;
> +
> +		read_extent_buffer(eb, &data, offset, sizeof(data));
> +		data = le64_to_cpu(data);
> +		if (data == subid) {
> +			ret = 0;
> +			break;
> +		}
> +		offset += sizeof(data);
> +		item_size -= sizeof(data);
> +	}

fs/btrfs/uuid-tree.c:81 col 24 warning: cast to restricted __le64

There are a few more instances of this.  The good news is that fixing
the sparse warning makes the code better, too.

		__le64 data;

		read_extent_buffer(eb, &data, offset, sizeof(data));
		if (le64_to_cpu(data) == subid) {

Plese make sure the rest of the series doesn't add sparse warnings for
Josef to get email about a few seconds after he merges.

> +int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
> +				  struct btrfs_root *uuid_root, u8 *uuid,
> +				  u64 subvol_id)
> +{
> +	int ret;
> +
> +	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
> +				     BTRFS_UUID_KEY_SUBVOL, subvol_id);
> +	if (ret == -ENOENT)
> +		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
> +					  BTRFS_UUID_KEY_SUBVOL, subvol_id);
> +	return ret;
> +}


> +int btrfs_insert_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
> +					   struct btrfs_root *uuid_root,
> +					   u8 *uuid, u64 subvol_id)
> +{
> +	int ret;
> +
> +	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
> +				     BTRFS_UUID_KEY_RECEIVED_SUBVOL, subvol_id);
> +	if (ret == -ENOENT)
> +		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
> +					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
> +					  subvol_id);
> +	return ret;
> +}

Just have callers pass in the key type so we get slightly less enormous
function names and less cut-and-paste code.

- z
