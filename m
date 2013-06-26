Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9872 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3FZVr1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 17:47:27 -0400
Message-ID: <51CB6171.2000006@giantdisaster.de>
Date: Wed, 26 Jun 2013 23:47:29 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 1/8] Btrfs: introduce a tree for items that map UUIDs
 to something
References: <cover.1372250828.git.sbehrens@giantdisaster.de> <dcc3cedb7e15d11570aab0350113bc47eebc262b.1372250828.git.sbehrens@giantdisaster.de> <20130626195540.GA3907@lenny.home.zabbo.net>
In-Reply-To: <20130626195540.GA3907@lenny.home.zabbo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/26/2013 21:55, Zach Brown wrote:
>> +	if (!uuid_root) {
>> +		WARN_ON_ONCE(1);
>> +		ret = -ENOENT;
>> +		goto out;
>> +	}
>
> WARN_ON_ONCE specifically returns the condition so that you can write:
>
> 	if (WARN_ON_ONCE(!uuid_root)) {
> 		ret = -ENOENT;
> 		goto out;
> 	}
>
>> +	while (item_size) {
>> +		u64 data;
>> +
>> +		read_extent_buffer(eb, &data, offset, sizeof(data));
>> +		data = le64_to_cpu(data);
>> +		if (data == subid) {
>> +			ret = 0;
>> +			break;
>> +		}
>> +		offset += sizeof(data);
>> +		item_size -= sizeof(data);
>> +	}
>
> fs/btrfs/uuid-tree.c:81 col 24 warning: cast to restricted __le64
>
> There are a few more instances of this.  The good news is that fixing
> the sparse warning makes the code better, too.
>
> 		__le64 data;
>
> 		read_extent_buffer(eb, &data, offset, sizeof(data));
> 		if (le64_to_cpu(data) == subid) {
>
> Plese make sure the rest of the series doesn't add sparse warnings for
> Josef to get email about a few seconds after he merges.
>
>> +int btrfs_insert_uuid_subvol_item(struct btrfs_trans_handle *trans,
>> +				  struct btrfs_root *uuid_root, u8 *uuid,
>> +				  u64 subvol_id)
>> +{
>> +	int ret;
>> +
>> +	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
>> +				     BTRFS_UUID_KEY_SUBVOL, subvol_id);
>> +	if (ret == -ENOENT)
>> +		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
>> +					  BTRFS_UUID_KEY_SUBVOL, subvol_id);
>> +	return ret;
>> +}
>
>
>> +int btrfs_insert_uuid_received_subvol_item(struct btrfs_trans_handle *trans,
>> +					   struct btrfs_root *uuid_root,
>> +					   u8 *uuid, u64 subvol_id)
>> +{
>> +	int ret;
>> +
>> +	ret = btrfs_uuid_tree_lookup(uuid_root, uuid,
>> +				     BTRFS_UUID_KEY_RECEIVED_SUBVOL, subvol_id);
>> +	if (ret == -ENOENT)
>> +		ret = btrfs_uuid_tree_add(trans, uuid_root, uuid,
>> +					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
>> +					  subvol_id);
>> +	return ret;
>> +}
>
> Just have callers pass in the key type so we get slightly less enormous
> function names and less cut-and-paste code.

Thanks for your comments, but this salami review procedure is not very 
efficient. Everything that you comment on now and before is there since V1.

Please tell me when you are done with the full review. And please also 
stop the bikeshedding.

