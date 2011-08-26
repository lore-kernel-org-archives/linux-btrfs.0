From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [RFC] Btrfs design defect in extent backref ?
Date: Fri, 26 Aug 2011 10:38:23 +0800
Message-ID: <CAAM7YA=o0pALbSpHqPHwM+3M2DEmShzxcpUXReVD=vjOt=fhuQ@mail.gmail.com>
References: <4E560018.9060005@cn.fujitsu.com>
	<CAAM7YAkxNcC_dk4uUnYFUoynkzb2Mx2KmJrNT+GJ8oZGKp3JqA@mail.gmail.com>
	<4E56FE4B.80606@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Zheng <zheng.z.yan@intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E56FE4B.80606@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 26, 2011 at 10:00 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Yan, Zheng wrote:
>> On Thu, Aug 25, 2011 at 3:56 PM, Li Zefan <lizf@cn.fujitsu.com> wrot=
e:
>>> We have an offset in file extent to indicate its position in the
>>> corresponding extent item in extent tree. We also have an offset in
>>> extent item to indicate the start position of the file extent that
>>> uses this item.
>>>
>>> The math is:
>>>
>>> =A0 =A0extent_item.extent_data_ref.offset =3D file_pos - file_exten=
t.extent_offset.
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 e1
>>> disk extents: =A0 =A0|--------------|
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
e2
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0|-------------=
----|
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0| =A0 ^
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 =A0| =A0 |
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 v =A0 =A0 =A0 =A0 =A0v =A0 |
>>> file extents: =A0 =A0|----- f1 -----|----- f2 -----|
>>>
>>> So it looks like e2.offset points to f1 not f2. Therefore given an =
extent item,
>>> we'll have to search through all the file extents in an inode to fi=
nd the
>>> relative file extent in the worst case, which makes this field some=
what useless.
>>>
>>
>> The reason for this is reducing number of file extent backref itmes.
>
> It seems to me a rare case, which isn't worth the complexity and inco=
nvenience
> it brings, and it requires an extra field (.count).
>
Random write workload isn't a rare case.

>> we don't have to search all the file extents because the file extent=
 size
>> is limited and we have extent_data_ref.count.
>
> Yes we have to, and for a big file with many small file extents, the =
extent
> number is not trivial.
>
Max file extent size is 128M, so only need to scan a 128M range in the
worst case.

>>
>>> What makes things worse is the above fomula can make the offset a n=
egative
>>> value (cast to u64):
>>>
>>> =A0 =A0# touch /mnt/dst
>>> =A0 =A0# clone_range -s 8192 -d 4096 /mnt/src /mnt/dst
>>> =A0 =A0# umount /mnt
>>> =A0 =A0# btrfs-debug-tree /dev/sda7
>>> =A0 =A0...
>>> =A0 =A0 =A0 =A0item 2 key (12582912 EXTENT_ITEM 49152) itemoff 3865=
 itemsize 82
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent refs 2 gen 8 flags 1
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data backref root 5 objectid =
258 offset 18446744073709543424 count 1
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0extent data backref root 5 objectid =
257 offset 0 count 1
>>> =A0 =A0...
>>>
>>> and relocation won't work in this case:
>>>
>>> =A0 =A0# mount /dev/sda7 /mnt
>>> =A0 =A0# rm /mnt/src
>>> =A0 =A0# sync
>>> =A0 =A0# btrfs fi bal /mnt
>>> =A0 =A0(kernel warning !!)
>>> =A0 =A0(hung up !!)
>>>
>>> I don't see the necessity or benefit of the substraction in the fom=
ula,
>>> and I think the correct one is:
>>>
>>> =A0 =A0extent_item.extent_data_ref.offset =3D file_pos
>>>
>>> (As a side effect thereafter we don't need extent_data_ref.count)
>>>
>>> That's what this patch does. Unfornately it is an incompatable chan=
ge
>>> in disk format.
>>>
>>> So I think we have to live with this defect, just fix relocation fo=
r
>>> the negative offset case ?
>>
>> I prefer fixing relocation.
>>
>
> Sure, though I would prefer the alternative if not for the stablity o=
f
> disk format.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
