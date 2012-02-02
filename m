From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not 0
Date: Thu, 2 Feb 2012 12:31:17 +0800
Message-ID: <CAAM7YAkWj2Avf8zA_Vb-QC-YL8wOBuPPXOEENkSB9vmx5vbEHA@mail.gmail.com>
References: <4D412FE6.7050101@cn.fujitsu.com>
	<4D4130D4.2000001@cn.fujitsu.com>
	<4F215AA0.8040505@jan-o-sch.net>
	<4F2639BF.80702@cn.fujitsu.com>
	<4F266AEB.6030403@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F266AEB.6030403@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2012 at 6:03 PM, Jan Schmidt <list.btrfs@jan-o-sch.net>=
 wrote:
> On 30.01.2012 07:33, Li Zefan wrote:
>> Jan Schmidt wrote:
>>> I was looking at the clone range ioctl and have some remarks:
>>>
>>> On 27.01.2011 09:46, Li Zefan wrote:
>>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>>> index f87552a..1b61dab 100644
>>>> --- a/fs/btrfs/ioctl.c
>>>> +++ b/fs/btrfs/ioctl.c
>>>> @@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(stru=
ct file *file, unsigned long srcfd,
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&new_key, &key, siz=
eof(new_key));
>>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.objectid =3D inode=
->i_ino;
>>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offset =3D key.offse=
t + destoff - off;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (off <=3D key.offset)
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offs=
et =3D key.offset + destoff - off;
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new_key.offs=
et =3D destoff;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ^^^^^^^
>>> 1) This looks spurious to me. What if destoff isn't aligned? That's=
 what
>>> the "key.offset - off" code above is for. Before the patch, the cod=
e
>>> didn't work at all, I agree. But this fix can only work for aligned
>>> requests.
>>>
>>> 2) The error in new_key also has propagated to the extent item's ba=
ckref
>>> and wasn't fixed there. I did a range clone and ended up with an ex=
tent
>>> item like that:
>>> =A0 =A0 =A0 =A0 item 30 key (1318842368 EXTENT_ITEM 131072) itemoff=
 1047
>>> itemsize 169
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent refs 8 gen 11103 flags 1
>>> [...]
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extent data backref root 257 object=
id 272 offset
>>> 18446744073709494272 count 1
>>>
>>> The last offset (equal to -14 * 4k) is obviously wrong. I didn't fi=
gure
>>> out how the variables are computed, but it looks like there's somet=
hing
>>> wrong with the "datao" u64 to me.
>>>
>>
>> Unfortunately this is expected. The calculation is:
>>
>> extent_item.extent_data_ref.offset =3D file_pos - file_extent.extent=
_offset
>>
>> so you may get negative offset.
>
> I see where the negative offset comes from. But what can this offset =
be
> used for?
>

The offset in backref isn't equal to the offset of the file extent,
it's just a hint for searching
file extents, Negative offset isn't that bad if you consider it as
value that is close to zero.



>> The design idea was to reduce the number of extent backrefs in that
>> a data backref can point to different file extents in the same file
>> (in this case the "count" field > 1). We didn't expect nagetive
>> offset until range clone was implemented.
>
> Reducing the number of backrefs is a good thing. In case of count > 1=
,
> it's clear that the offset cannot reference all of the extent data
> items. We have different design choices:
>
> a) Use the above computation and leave the filesystem with an unusabl=
e
> offset value for extent backrefs.
>
> b) Use either one of the extent data item offsets this backref refere=
nces.
>
> c) Always use a predefined constant (like 0 or -1) when count > 1.
>
> d) Disallow count > 1 for those refs and turn them into shared refs a=
s
> soon as count gets > 1.
>
> I don't like a :-)
>
> -Jan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
