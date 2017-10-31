Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43865 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753272AbdJaK16 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 06:27:58 -0400
Subject: Re: [PATCH v2] btrfs-progs: print-tree: Enehance uuid item print
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171031082850.19583-1-wqu@suse.com>
 <982545f1-b8ba-a91b-5125-be1fd1cd12bd@suse.com>
 <00492e2f-a7e3-9f10-4f25-6e0c058e3345@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0b08e065-31d7-88c2-772f-c14d8dd94413@suse.com>
Date: Tue, 31 Oct 2017 12:27:55 +0200
MIME-Version: 1.0
In-Reply-To: <00492e2f-a7e3-9f10-4f25-6e0c058e3345@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 31.10.2017 12:09, Qu Wenruo wrote:
> 
> 
> On 2017年10月31日 16:47, Nikolay Borisov wrote:
>>
>>
>> On 31.10.2017 10:28, Qu Wenruo wrote:
>>> For key type BTRFS_UUID_KEY_SUBVOL or BTRFS_UUID_KEY_RECEIVED_SUBVOL the
>>> key objectid and key offset is just half of the UUID.
>>>
>>> However we just print the key as %llu, which is converted from little
>>> endian, not byte order for UUID, nor the traditional 36 bytes human
>>> readable uuid format.
>>>
>>> Although true engineer can easily handle it by convert it in their
>>> brain, but to make it easier for search, output the result UUID using
>>> the 36 chars format.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> Inspired by UUID related work from Misono-san.
>>> v2:
>>>   Use explicit btrfs_key_to_uuid() function to do the convert, and add
>>>   more comment why we should do that. Suggested by Nikolay.
>>> ---
>>>  print-tree.c | 34 +++++++++++++++++++++++++++++++---
>>>  1 file changed, 31 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/print-tree.c b/print-tree.c
>>> index 3c585e31f1fc..ab6f6c392519 100644
>>> --- a/print-tree.c
>>> +++ b/print-tree.c
>>> @@ -803,14 +803,42 @@ void btrfs_print_key(struct btrfs_disk_key *disk_key)
>>>  	}
>>>  }
>>>  
>>> -static void print_uuid_item(struct extent_buffer *l, unsigned long offset,
>>> -			    u32 item_size)
>>> +static void btrfs_key_to_uuid(struct btrfs_key *key, u8 *uuid)
>>>  {
>>> +	/*
>>> +	 * UUID we use is in byte order, which means:
>> "byte order" term per-se doesn't really say anything about how bytes are
>> stored, we either have little endian or big endian. So this sentence
>> needs to be more explicit "BTRFS always represents uuid in little endian"
> 
> Well, it turned out that I get confused with the term "byte order" and
> "network order", and in this case I mean "network order" which is also BE.
> 
> And just in case, if you're referring the UUID as u128, then it's
> definitely big endian.
> 
>>
>>> +	 *          0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
>>> +	 * UUID:0x 12 34 56-78 90-ab cd-ef 12-34 56 78 90 ab cd ef
>>> +	 *
>>> +	 * And we store them as is in btrfs_*disk*_key:
>> This could be "BTRFS' on-disk format also uses little-endian so the
>> in-memory uuid is stored on-disk without any change to endiannes"
> 
> While I'm always confused by your mention of endian in this case.
> 
> Here UUID is just 16 bytes, why endian is envolved? (We're not talking
> about true UUID)
> Isn't endian only affecting structure over 1 byte?
> 
> Here is just a stream of bytes, why endian is affected in UUID?
> We didn't even trust uuid as u128 at all.
> 
> To me, only when we access things like key->objectid/offset we cares
> about endian. For key->type and CSUM, there is no endian at all as we
> are just accessing bytes. (Unless we convert them into u32/u64/u128)

I don't understand where your confusion arises from but here is how I
understand things.

Btrfs generates uids by invoking uuid_le_gen (which actually calls
guid_gen). guid_gen in turn generates a 128 bit LE value, consisting of
16 bytes. Then in order to add this uuid to the uuid tree we actually
split those 16 bytes into 2 u64 values by calling btrfs_uuid_to_key and
assigne them to the objectid/offset members of the btrfs key. At this
point the endiannes of each of these 2 values is important since they
are being treated as u64.

So actually order is important and btrfs chose to work with LE values
explicitly so what I'm asking is to document this fact explicitly in the
code handling this otherwise one has to go and dig around the code to
figure out why you are doing an on-disk (LE)  -> host cpu(could be LE or
BE) -> LE conversion.

I hope this makes things clear



> 
> Thanks,
> Qu
> 
>>
>>
>>> +	 *
>>> +	 *         Low bit        High bit|Low bit        High bit
>>> +	 * LE64:0x 12 34 56-78 90-ab cd-ef|12-34 56 78 90 ab cd ef
>>> +	 *             key.objectid       |     key.offset
>>> +	 *
>>> +	 * So here we just need to convert from native endian to LE to
>>> +	 * get the byte order UUID.
>>> +	 */
>>> +	put_unaligned_le64(key->objectid, uuid);
>>> +	put_unaligned_le64(key->offset, uuid + sizeof(u64));
>>> +}
>>> +
>>> +static void print_uuid_item(struct extent_buffer *l, int slot,
>>> +			    unsigned long offset, u32 item_size)
>>> +{
>>> +	struct btrfs_key key;
>>> +	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>>> +	u8 uuid[BTRFS_UUID_SIZE];
>>> +
>>> +	btrfs_item_key_to_cpu(l, &key, slot);
>>> +	btrfs_key_to_uuid(&key, uuid);
>>> +	uuid_unparse(uuid, uuid_str);
>>>  	if (item_size & (sizeof(u64) - 1)) {
>>>  		printf("btrfs: uuid item with illegal size %lu!\n",
>>>  		       (unsigned long)item_size);
>>>  		return;
>>>  	}
>>> +	printf("\t\tuuid %s\n", uuid_str);
>>>  	while (item_size) {
>>>  		__le64 subvol_id;
>>>  
>>> @@ -1297,7 +1325,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
>>>  			break;
>>>  		case BTRFS_UUID_KEY_SUBVOL:
>>>  		case BTRFS_UUID_KEY_RECEIVED_SUBVOL:
>>> -			print_uuid_item(eb, btrfs_item_ptr_offset(eb, i),
>>> +			print_uuid_item(eb, i, btrfs_item_ptr_offset(eb, i),
>>>  					btrfs_item_size_nr(eb, i));
>>>  			break;
>>>  		case BTRFS_STRING_ITEM_KEY: {
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
