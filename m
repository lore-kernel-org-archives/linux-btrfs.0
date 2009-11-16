From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [PATCH] Snapshot/subvolume listing feature
Date: Mon, 16 Nov 2009 16:00:15 +0300
Message-ID: <2a31deca0911160500j6b2b17c3v8b3a3bebd000457d@mail.gmail.com>
References: <4B00ADE8.4090205@jp.fujitsu.com> <3d0408630911160015t79044d72u3489a42d57c6f844@mail.gmail.com>
	<4B011435.2080005@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B011435.2080005@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Just for clarity, getdents is exactly the other interface options
discussed couple of weeks back (use virtual directories & standard
file-system API).

Regards,
Andrey



On Mon, Nov 16, 2009 at 11:58 AM, TARUISI Hiroaki
<taruishi.hiroak@jp.fujitsu.com> wrote:
> Thank you for your advice.
>
> I'm aware of redundant search, but I didn't think of
> getdents like interface.
>
> I'll remake it without redundant search.
>
> Regards,
> taruisi
>
> Yan, Zheng wrote:
>> 2009/11/16 TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>:
>>> I made Snapshot/subvolume listing feature.
>>>
>>> This feature consists of two patches, for kernel(ioctl),
>>> and for progs(btrfsctl). I send these two patches as response
>>> of this mail soon.
>>>
>>> New option '-l' is introduced to btrfsctl for listing.
>>>
>>> If this option is specified, btrfsctl call new ioctl. New ioctl
>>> searches root tree and enumerates subtrees. For each subtrees,
>>> ioctl searches directory path to tree root, and enumerates
>>> more descendant until no more subtree is found.
>>>
>>> MANPAGE-like option description and examples are as follows.
>>>
>>> =A0OPTIONS
>>> =A0 =A0 =A0 =A0-l _file_
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0List all snapshot/subvolume director=
ies under a tree
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0which _file_ belongs to.
>>>
>>> =A0EXAMPLES
>>> =A0 =A0 =A0 =A0# btrfsctl -l /work/btrfs
>>> =A0 =A0Base path =3D /work/btrfs/
>>> =A0 =A0No. =A0 =A0Tree ID =A0 =A0 =A0Subvolume Relative Path
>>> =A0 =A0 1 =A0 =A0 =A0 =A0 256 =A0 =A0 =A0ss1/
>>> =A0 =A0 2 =A0 =A0 =A0 =A0 257 =A0 =A0 =A0ss2/
>>> =A0 =A0 3 =A0 =A0 =A0 =A0 258 =A0 =A0 =A0svs1/ss1/
>>> =A0 =A0 4 =A0 =A0 =A0 =A0 259 =A0 =A0 =A0svs1/ss2/
>>> =A0 =A0 5 =A0 =A0 =A0 =A0 260 =A0 =A0 =A0svs2/ss1/
>>> =A0 =A0 6 =A0 =A0 =A0 =A0 261 =A0 =A0 =A0svs2/ss2/
>>> =A0 =A0 7 =A0 =A0 =A0 =A0 262 =A0 =A0 =A0ss3/
>>> =A0 =A0 8 =A0 =A0 =A0 =A0 263 =A0 =A0 =A0ss4/
>>> =A0 =A0 9 =A0 =A0 =A0 =A0 264 =A0 =A0 =A0sv_pool/
>>> =A0 =A010 =A0 =A0 =A0 =A0 265 =A0 =A0 =A0sv_pool/ss01/
>>> =A0 =A011 =A0 =A0 =A0 =A0 266 =A0 =A0 =A0sv_pool/ss02/
>>> =A0 =A012 =A0 =A0 =A0 =A0 267 =A0 =A0 =A0sv_pool/ss03/
>>> =A0 =A013 =A0 =A0 =A0 =A0 268 =A0 =A0 =A0sv_pool/ss04/
>>> =A0 =A014 =A0 =A0 =A0 =A0 269 =A0 =A0 =A0sv_pool/ss05/
>>> =A0 =A015 =A0 =A0 =A0 =A0 270 =A0 =A0 =A0sv_pool/ss06/
>>> =A0 =A016 =A0 =A0 =A0 =A0 271 =A0 =A0 =A0sv_pool/ss07/
>>> =A0 =A017 =A0 =A0 =A0 =A0 272 =A0 =A0 =A0sv_pool/ss08/
>>> =A0 =A018 =A0 =A0 =A0 =A0 273 =A0 =A0 =A0sv_pool/ss09/
>>> =A0 =A019 =A0 =A0 =A0 =A0 274 =A0 =A0 =A0sv_pool/ss10/
>>> =A0operation complete
>>> =A0Btrfs v0.19-9-gd67dad2
>>>
>>
>> Thank you for doing this.
>>
>> I have a quick look at the patches. It seems the ioctl returns full =
path
>> to each subvolume and uses sequence ID to indicate the progress
>> of listing. Every time the ioctl is called, it tries building full l=
ist of
>> subvolume, then skip entries that already returned. =A0I think the A=
PI is
>> suboptimal, a getdents like API is better. (The ioctl only lists sub=
volumes
>> within a given subvolume, the user program call the ioctl recursivel=
y
>> to list all subvolumes.)
>>
>> Yan, Zheng
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
