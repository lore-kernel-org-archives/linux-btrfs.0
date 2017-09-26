Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:52226 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936444AbdIZMnG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 08:43:06 -0400
Subject: Re: [PATCH v2 3/4] btrfs: Add sanity check for EXTENT_DATA when
 reading out leaf
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170823075759.13982-1-quwenruo.btrfs@gmx.com>
 <20170823075759.13982-4-quwenruo.btrfs@gmx.com>
 <20170925154503.GL31640@twin.jikos.cz>
 <d90b5bd1-8b8f-4403-6d46-a817d935d63d@gmx.com>
 <20170926120501.GR31640@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <64782ff3-143c-f400-b791-6ec7f3adfb19@gmx.com>
Date: Tue, 26 Sep 2017 20:42:53 +0800
MIME-Version: 1.0
In-Reply-To: <20170926120501.GR31640@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月26日 20:05, David Sterba wrote:
> On Tue, Sep 26, 2017 at 08:28:25AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月25日 23:45, David Sterba wrote:
>>> On Wed, Aug 23, 2017 at 04:57:58PM +0900, Qu Wenruo wrote:
>>>> Add extra checker for item with EXTENT_DATA type.
>>>> This checks the following thing:
>>>> 0) Key offset
>>>>      All key offset must be aligned to sectorsize.
>>>>      Inline extent must have 0 for key offset.
>>>>
>>>> 1) Item size
>>>>      Plain text inline file extent size must match item size.
>>>
>>> 'plain text' seems to be a bit misleading, I don't think we've ever
>>> referred to uncompressed extent as such, although it makes some sense. I
>>> think 'uncompressed' would work too.
>>
>> I'll use 'uncompressed' instead.
> 
> I've applied an fixed that in the changelog, as there were some other
> changes needed due to other patch removing the BTRFS_COMPRESSION_LAST.

Checked the commit 0826e7faa895f5463e4790082392cdaaff98d8d8, which uses 
BTRFS_FILE_EXTENT_TYPES and doesn't increase but using the last value.

Looks very good to me.

> 
>>>>      (compressed inline file extent has no info about its on-disk size)
>>>>      Regular/preallocated file extent size must be a fixed value.
>>>>
>>>> 2) Every member of regular file extent item
>>>>      Including alignment for bytenr and offset, possible value for
>>>>      compression/encryption/type.
>>>>
>>>> 3) Type/compression/encode must be one of the valid values.
>>>>
>>>> This should be the most comprehensive and restrict check in the context
>>>> of btrfs_item for EXTENT_DATA.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
>>>> ---
>>>>    fs/btrfs/disk-io.c              | 108 ++++++++++++++++++++++++++++++++++++++++
>>>>    include/uapi/linux/btrfs_tree.h |   1 +
>>>>    2 files changed, 109 insertions(+)
>>>>
>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>> index e034d08bd036..b92296c6a698 100644
>>>> --- a/fs/btrfs/disk-io.c
>>>> +++ b/fs/btrfs/disk-io.c
>>>> @@ -549,6 +549,103 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
>>>>    		   btrfs_header_level(eb) == 0 ? "leaf" : "node",	\
>>>>    		   reason, btrfs_header_bytenr(eb), root->objectid, slot)
>>>>    
>>>> +static int check_extent_data_item(struct btrfs_root *root,
>>>> +				  struct extent_buffer *leaf,
>>>> +				  struct btrfs_key *key, int slot)
>>>> +{
>>>> +	struct btrfs_file_extent_item *fi;
>>>> +	u32 sectorsize = root->fs_info->sectorsize;
>>>> +	u32 item_size = btrfs_item_size_nr(leaf, slot);
>>>> +
>>>> +	if (!IS_ALIGNED(key->offset, sectorsize)) {
>>>> +		CORRUPT("unaligned key offset for file extent",
>>>
>>> The CORRUPT macro does not print any details beyond what it gets from
>>> the parameters, so here we'd like to know which extent it is and what's
>>> the size. The sectorsize can be found elsewhere so it does not need
>>> to be printed.
>>
>> Did you mean despite bytenr of the tree block and root objectid, we
>> should output more info about the key?
> 
> Possibly yes, but rather more about the item. If the key objectid/offset
> are eg. some structural value like the extent offset etc.

Understood.

So in short, the reporter should do:
1) Report the wrong value
2) Report expected value (or value range)
3) Using meaningful name other than key values
4) Report extra meaningful values if they passed their checker
5) Checker order must follow member order

And following above principle, using wrong file_extent_type as example,
it should report like:
---
root=512 ino=768 file_offset=4096 invalid file_extent_type, have 0x4, 
expected range [0, 2]
---

What about this principle?

(Although I think it's a little long, especially when extra fs_uuid 
appended)

<snip>
>>
>> Please note that, this condition is only for regular/prealloc file
>> extent items, so ram_bytes should be sectorsize aligned.
> 
> I can't find the tree dump and code confirms that the value should be
> aligned.

Strange.

I just did a 6K write with compression, it produced such dump-tree result:
---
         item 4 key (257 INODE_ITEM 0) itemoff 15881 itemsize 160
                 generation 7 transid 7 size 6144 nbytes 8192 <<<
                 block group 0 mode 100600 links 1 uid 0 gid 0 rdev 0
                 sequence 0 flags 0x2(none)
                 <snip>
         item 5 key (257 INODE_REF 256) itemoff 15866 itemsize 15
                 index 2 namelen 5 name: file1
         item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
                 generation 7 type 1 (regular)
                 extent data disk byte 12845056 nr 4096 <<<
                 extent data offset 0 nr 8192 ram 8192 <<<
                 extent compression 1 (zlib)
---

Since the compression is all page based, I didn't think the ram_bytes 
can be page unaligned.

Anyway, I can remove the ram_bytes check until we get a better 
understanding of its definition.
(And better record it in wiki for later developers)

All these checker must be fully reviewed and get agreement from all 
reviewers.
Or it will cause tons of error report from end users.
So I'm pretty OK to delay the merge 1 or 2 cycles.



And if above error report principles are OK for you, I think I'll need 
to create new report mechanisms for these patches.
And all of these patches may get a big update.
(Of course, I'll use function other than macro unless I need 
stringification)

So I'm afraid you may need to re-apply all of them then.
Sorry for the inconvience in advance.

Thanks,
Qu
