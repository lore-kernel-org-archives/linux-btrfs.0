Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A817F3D7D84
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774443267; cv=none; b=Is4zkBJrHMTgR2eoeROrKNv73qO9M6hD/C8/OmZQqUrfuVJuDcCMYTnMMt+IYN7cx15gz6+9QGBw+FFSXOTow6E2fgnVAttHeiShrHZssUAiFdxrtef7tm+RkLWDHyZ3UsGxY6wOtFm+50hnb1IpIdfRsNJ+220Mzv/OvyJsG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774443267; c=relaxed/simple;
	bh=iUK9npUxkqb+5OBJrAU545M1uQC3FTPzidPMwqMeoIs=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C3XvRMThCtYeMP2/r2OsHHn7RhL/yiO5W+p+fsKNDckX6xX0s/b32BAxkKSw3A+cAT5u2GDmo19Z1kyHmkxJ2gQctjMV/KcOTg547G0xYI3zG2AgAWMoam69UtUvDo6qPDVTnkXbh4cp3Ztot76ZGgSnkrFNQLSLCUapDes7BD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=kEEXWmbE; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="kEEXWmbE"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 81AB4314E24;
	Wed, 25 Mar 2026 12:54:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774443263;
	bh=AZIXN+Y73PIl3ih35VBn/ri/kEUiHrnMRAWg1yXfxg4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kEEXWmbE+xee+TMQ+EOlQQ7m2ym4H9wNRHQ2tzxiJ5HaiaP/eLkLd1oqXN0NUKgeV
	 wJkze5K+5A7w9j5gXztb/Rw+fGM9eMCbTRz5A45wbBKK6b0TxChW6hxazun09LzY2Z
	 opVGShnEGQyKcga2cBZuWss0L8LVpTpCK/nc678k=
Message-ID: <95ff3c8f-4932-4fe6-b46e-dcdbc876968d@harmstone.com>
Date: Wed, 25 Mar 2026 12:54:23 +0000
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: add remap-tree checks to check_block_group_item()
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <20260323172619.152258-1-mark@harmstone.com>
 <20260323194348.GS5735@twin.jikos.cz>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260323194348.GS5735@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/03/2026 7.43 pm, David Sterba wrote:
> On Mon, Mar 23, 2026 at 05:26:13PM +0000, Mark Harmstone wrote:
>> Add some write-time checks for block group items relating to the remap
>> tree.
>>
>> Here we're checking:
>> * That the REMAPPED or METADATA_REMAP flags aren't set unless the
>>    REMAP_TREE incompat flag is also set
>> * That `remap_bytes` isn't more than the size of the block group
>> * That `identity_remap_count` isn't more than the number of sectors in
>>    the block group
>>
>> Signed-off-by: Mark Harmstone <mark@harmstone.com>
>> ---
>>   fs/btrfs/tree-checker.c | 42 +++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 42 insertions(+)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index 495d1dd61e66c2..cad23f3fadfd34 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -777,6 +777,48 @@ static int check_block_group_item(struct extent_buffer *leaf,
>>   			BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA);
>>   		return -EUCLEAN;
>>   	}
>> +
>> +	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
>> +		     type == BTRFS_BLOCK_GROUP_METADATA_REMAP)) {
>> +		block_group_err(leaf, slot,
>> +"invalid type, METADATA_REMAP set but REMAP_TREE incompat flag not set");
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	if (unlikely(!btrfs_fs_incompat(fs_info, REMAP_TREE) &&
>> +		     flags & BTRFS_BLOCK_GROUP_REMAPPED)) {
>> +		block_group_err(leaf, slot,
>> +"invalid flags, REMAPPED set but REMAP_TREE incompat flag not set");
>> +		return -EUCLEAN;
>> +	}
>> +
>> +	if (item_size == sizeof(struct btrfs_block_group_item_v2)) {
>> +		struct btrfs_block_group_item_v2 *bgi2;
>> +		u64 remap_bytes;
>> +		u32 identity_remap_count;
>> +
>> +		bgi2 = btrfs_item_ptr(leaf, slot, struct btrfs_block_group_item_v2);
>> +
>> +		remap_bytes = btrfs_block_group_v2_remap_bytes(leaf, bgi2);
>> +
>> +		if (unlikely(remap_bytes > key->offset)) {
>> +			block_group_err(leaf, slot,
>> +				"invalid remap_bytes, have %llu expect [0, %llu]",
>> +					remap_bytes, key->offset);
>> +			return -EUCLEAN;
>> +		}
>> +
>> +		identity_remap_count = btrfs_block_group_v2_identity_remap_count(leaf, bgi2);
>> +		if (unlikely((u64)identity_remap_count >
>> +			     key->offset / fs_info->sectorsize)) {
> 
> 64bit / 32bit may not work on all arches, we have the sectorize_bits to
> avoid it.

Annoying. Thank you, I've sent another patch.

>> +			block_group_err(leaf, slot,
>> +				"invalid identity_remap_count, have %u expect [0, %llu]",
>> +					identity_remap_count,
>> +					key->offset / fs_info->sectorsize);
>> +			return -EUCLEAN;
>> +		}
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> -- 
>> 2.52.0
>>

