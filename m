From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC] Btrfs design defect in extent backref ?
Date: Fri, 26 Aug 2011 10:00:43 +0800
Message-ID: <4E56FE4B.80606@cn.fujitsu.com>
References: <4E560018.9060005@cn.fujitsu.com> <CAAM7YAkxNcC_dk4uUnYFUoynkzb2Mx2KmJrNT+GJ8oZGKp3JqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Zheng <zheng.z.yan@intel.com>
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAM7YAkxNcC_dk4uUnYFUoynkzb2Mx2KmJrNT+GJ8oZGKp3JqA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng wrote:
> On Thu, Aug 25, 2011 at 3:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> We have an offset in file extent to indicate its position in the
>> corresponding extent item in extent tree. We also have an offset in
>> extent item to indicate the start position of the file extent that
>> uses this item.
>>
>> The math is:
>>
>>    extent_item.extent_data_ref.offset = file_pos - file_extent.extent_offset.
>>
>>                       e1
>> disk extents:    |--------------|
>>                 ^
>>                 |                  e2
>>                 |          |-----------------|
>>                 |          |   ^
>>                 |          |   |
>>                 v          v   |
>> file extents:    |----- f1 -----|----- f2 -----|
>>
>> So it looks like e2.offset points to f1 not f2. Therefore given an extent item,
>> we'll have to search through all the file extents in an inode to find the
>> relative file extent in the worst case, which makes this field somewhat useless.
>>
> 
> The reason for this is reducing number of file extent backref itmes.

It seems to me a rare case, which isn't worth the complexity and inconvenience
it brings, and it requires an extra field (.count).

> we don't have to search all the file extents because the file extent size
> is limited and we have extent_data_ref.count.

Yes we have to, and for a big file with many small file extents, the extent
number is not trivial.

> 
>> What makes things worse is the above fomula can make the offset a negative
>> value (cast to u64):
>>
>>    # touch /mnt/dst
>>    # clone_range -s 8192 -d 4096 /mnt/src /mnt/dst
>>    # umount /mnt
>>    # btrfs-debug-tree /dev/sda7
>>    ...
>>        item 2 key (12582912 EXTENT_ITEM 49152) itemoff 3865 itemsize 82
>>                extent refs 2 gen 8 flags 1
>>                extent data backref root 5 objectid 258 offset 18446744073709543424 count 1
>>                extent data backref root 5 objectid 257 offset 0 count 1
>>    ...
>>
>> and relocation won't work in this case:
>>
>>    # mount /dev/sda7 /mnt
>>    # rm /mnt/src
>>    # sync
>>    # btrfs fi bal /mnt
>>    (kernel warning !!)
>>    (hung up !!)
>>
>> I don't see the necessity or benefit of the substraction in the fomula,
>> and I think the correct one is:
>>
>>    extent_item.extent_data_ref.offset = file_pos
>>
>> (As a side effect thereafter we don't need extent_data_ref.count)
>>
>> That's what this patch does. Unfornately it is an incompatable change
>> in disk format.
>>
>> So I think we have to live with this defect, just fix relocation for
>> the negative offset case ?
> 
> I prefer fixing relocation.
> 

Sure, though I would prefer the alternative if not for the stablity of
disk format.
