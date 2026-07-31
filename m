Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D39B3E0C70
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498074; cv=none; b=g/QWDvzU0wzljypJw+gTzpQDbwKeGF5RMK1+ngpdCcLDHv1BClrCl7zFhOIBN2G8bMfnMlCMGakNK7UL7tqiAcI/t0PhieTcKKkJxiBzAAXOEYRKWvlykDlvo+QTZ/waZkd2BuibsRhQCCI4cg6hVjwxugGX7iRB+B3ehekkn7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498074; c=relaxed/simple;
	bh=f7H7XXmtKtgFWSdL7MTIYKP3JHqYKCynGODxEZgHCYs=;
	h=References:From:Mime-Version:To:Message-Id:Date:In-Reply-To:
	 Content-Type:Subject; b=lBwTDKJKq5EYU6MxA1ejp3H71xd8hmV4QNWHOiYWgNLshk1eau1EhFfb6PI9yuYVwJknE4nfuIII1mzU2q5AgVwKN0GWrkOoUXhhq5zSykIURma+LBvwPyhy1uX5nU+AU6RzukeXnWxn5VI23yC2SkzkGFSWUUypU9kacAyVxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=AAK2QTjm; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="AAK2QTjm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785498058;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f7H7XXmtKtgFWSdL7MTIYKP3JHqYKCynGODxEZgHCYs=;
 b=AAK2QTjm9Nycck8aCWkXkaYdIgf/SmK2UJiuYz43Zw7h2A2/GmNYYfKGcKk54JGKhETiDi
 Ut1PjKDt/6Tn8rs3UkWAWxhgrseNcKR6higy9zAtFPFyaxnTbjONuZdSIktnqOHLFNlNy2
 gP4V/N3VbAhgUAodNGiruaMGZ833Z3nKBJ8+f8yDib3iRie7XigAFPpB/llmQuHXMhQNeT
 ld6n+WieacaD+nSi45ryiT7DgK9MaK7rl1AIDBKIcjyVL7gcB0ivEdDeDLNSDmsW6UmT11
 6pN85NaLTP/NrICCAKpWrBplI6aE/30skx19llfR/ZHEfGjs5xKBu04cwgOsEA==
X-Original-From: Sun YangKai <sunyangkai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com> <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io> <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com> <ca3eeaeb-76d4-4a23-a019-d3a5f4ceb431@fygo.io> <110adc02-4e4e-437d-867d-c8fd3a50aba9@suse.com>
From: "Sun YangKai" <sunyangkai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.10.244] ([183.34.161.172]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 11:40:57 +0000
X-Lms-Return-Path: <lba+26a6c89ca+d1ba90+vger.kernel.org+sunyangkai@fygo.io>
To: "Qu Wenruo" <wqu@suse.com>, "Sun YangKai" <sunyangkai@fygo.io>, 
	<linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0758b840-f48e-4693-af9b-04793319382d@fygo.io>
Date: Fri, 31 Jul 2026 19:40:52 +0800
Content-Language: en-US
In-Reply-To: <110adc02-4e4e-437d-867d-c8fd3a50aba9@suse.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature, data_io_size

On 2026/7/22 18:03, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/7/22 19:28, Sun YangKai =E5=86=99=E9=81=93:
>> On 2026/7/22 17:25, Qu Wenruo wrote:
>>>
>>>
>>> =E5=9C=A8 2026/7/22 18:52, Sun YangKai =E5=86=99=E9=81=93:
>>>> On 2026/6/28 14:27, Qu Wenruo wrote:
>>>>> To address the btrfs RAID56 write-hole problem, there is one idea to
>>>>> solve it:
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0 Make sure all data writes are full stripe aligned
>>>>> However based on that idea, we can have two different directions to
>>>>> implement:
>>>>>
>>>>> - Keep the sector size untouched, introduce a newer io size for data
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 E.g. sector size is still 4K, but data io si=
ze is 16K, and RAID56
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 full stripe size is also set to 16K.
>>>>
>>>> Sorry, I cannot follow you here about "RAID56 full stripe size is also
>>>> set to 16K".
>>>
>>> Just as what it reads.
>>>
>>> Not using the fixed 64K stripe size, but per-chunk full stripe size.
>>
>> I appreciate that you'd love to explain more about this.
>>
>> But I still cannot understand how 16KiB full stripe size can fit on a 4
>> disks RAID5 for example. Currently we have 3*64KiB =3D 192KiB as full
>> stripe size for this kind of setup. But if using 16KiB full stripe size,
>> how many data on each disk and how's the logical address mapped to those
>> disks?
>=20
> Full stripe 16K, then the new RAID5F chunks will require power-of-2=20
> disks, and no more than 16K/4K disks.
>=20
> So no 4 disks RAID5F chunk in the first place.

I've got your idea and got the following 2 concerns:

1. the device count is limited to 3 or 5 device for RAID5, and 4 or 6=20
devices for RAID6, losing the flexibility currently btrfs have;

2. On each device, we will send a lot of 4KiB or 8KiB io, which might be=20
not good for performance;

So I personally don't think this is a good way to fix the write hole issue.

>>
>> Thanks,
>> Sun YangKai
>>
>>>>
>>>> Currently I think we have a 64KiB chunk on each disk, and for n disks
>>>> RAID5, we have (n-1) * 64KiB as data's full stripe size and one more
>>>> 64KiB for parity if I understand it correctly. Then how can we limit=
=20
>>>> the
>>>> full stripe size to 16K with n devices?
>>>>
>>>> 16K/(n-1) bytes on each disk is insane. Or we just limit device count
>>>> for RAID5 to a specific number like 3 disks so we can have 2 device fo=
r
>>>> data, 1 for parity and can get a 8KiB chunk on each disk?
>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 This allows us to reuse the existing sector =
size based
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 read-repair/scrub.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 And this patch is the PoC of this idea.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 The problems are also obvious, we need to no=
t only introduce a
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 dedicated compat RO flag, but also convert a=
lmost all sectorsize
>>>>> users
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 to use the new data_io_size, except data che=
cksum and read-repair
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 related code.
>>>>>
>>>>> - Use larger block size, introduce a newer sub-block RAID56 repair
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 E.g. sector size is 16K, and RAID56 full str=
ipe size is also=20
>>>>> set to
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 16K.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 This allows us to reuse the existing experim=
ental bs > ps=20
>>>>> support.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 The problems are that we need a completely n=
ew RAID56 sub-block
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 rebuild handling.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 And the new rebuild can be very slow. Since =
we do not know exact
>>>>> which
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 sub-block is corrupted, we have to exhaust a=
ll combinations just
>>>>> for a
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 single block.
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 And the current btrfs_map_block() also need =
to support sub-block
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 splitting, which is completely new, and will=
 also affect checksum
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 handling.
>>>>>
>>>>> So far it looks like the new data io size is the easier solution, thu=
s
>>>>> here is the RFC patch.
>>>>>
>>>>> But in reality, this RFC patch is already super huge, almost touching
>>>>> all call sites using fs_info->sectorsize, and there are still a lot o=
f
>>>>> left-over and causing all kinds of warnings.
>>>>>
>>>>> For now I'm wondering if it would be better just to replace sectorsiz=
e
>>>>> with data_io_size, and introduce a dedicated member for checksum/=20
>>>>> scrub.
>>>>>
>>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>>> ---
>>>>> Reason for RFC:
>>>>> This patch is still very unstable, there are still a lot of sites not
>>>>> properly converted to use the new fs_info->data_io_size.
>>>>>
>>>>> This is only for proof-of-concept purpose.
>>>>> ---
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/accessors.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/direct-io.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +--
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/disk-io.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 ++++++++++-
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 68 ++++++=
+++++++++
>>>>> +-----------------
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 9 ++++-
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 60 ++++++++++++=
++---------------
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/lzo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 =
2 +-
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
>>>>> =C2=A0=C2=A0=C2=A0 fs/btrfs/tests/btrfs-tests.c=C2=A0=C2=A0=C2=A0 |=
=C2=A0 1 +
>>>>> =C2=A0=C2=A0=C2=A0 include/uapi/linux/btrfs.h=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 7 ++++
>>>>> =C2=A0=C2=A0=C2=A0 include/uapi/linux/btrfs_tree.h |=C2=A0 3 +-
>>>>> =C2=A0=C2=A0=C2=A0 11 files changed, 112 insertions(+), 71 deletions(=
-)
>>>>>
>>>>> diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
>>>>> index 8938357fcb40..7a5206db2224 100644
>>>>> --- a/fs/btrfs/accessors.h
>>>>> +++ b/fs/btrfs/accessors.h
>>>>> @@ -889,6 +889,8 @@
>>>>> BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct
>>>>> btrfs_super_block,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 remap_root_generation, 64);
>>>>> =C2=A0=C2=A0=C2=A0 BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, s=
truct
>>>>> btrfs_super_block,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 remap_root_level, 8);
>>>>> +BTRFS_SETGET_STACK_FUNCS(super_data_io_size, struct=20
>>>>> btrfs_super_block,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 data_io_size, 32);
>>>>> =C2=A0=C2=A0=C2=A0 /* struct btrfs_file_extent_item */
>>>>> =C2=A0=C2=A0=C2=A0 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, s=
truct
>>>>> btrfs_file_extent_item,
>>>>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>>>>> index 3e227292b0ac..df1b2f2725ca 100644
>>>>> --- a/fs/btrfs/direct-io.c
>>>>> +++ b/fs/btrfs/direct-io.c
>>>>> @@ -186,7 +186,7 @@ static struct extent_map
>>>>> *btrfs_new_extent_direct(struct btrfs_inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 alloc_hint =3D btrfs_get_e=
xtent_allocation_hint(inode, start,=20
>>>>> len);
>>>>> =C2=A0=C2=A0=C2=A0 again:
>>>>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_reserve_extent(root, len, len, fs_i=
nfo->sectorsize,
>>>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_reserve_extent(root, len, len, fs_i=
nfo->data_io_size,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0, alloc_hi=
nt, &ins, true, true);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EAGAIN) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 AS=
SERT(btrfs_is_zoned(fs_info));
>>>>> @@ -395,7 +395,7 @@ static int btrfs_dio_iomap_begin(struct inode
>>>>> *inode, loff_t start,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to allocate a cont=
iguous array for the checksums.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!write)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len =3D min_t(u64, len, f=
s_info->sectorsize * BIO_MAX_VECS);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len =3D min_t(u64, len, f=
s_info->data_io_size * BIO_MAX_VECS);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockstart =3D start;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D start + len - =
1;
>>>>> @@ -829,7 +829,7 @@ static struct iomap_dio *btrfs_dio_write(struct
>>>>> kiocb *iocb, struct iov_iter *it
>>>>> =C2=A0=C2=A0=C2=A0 static ssize_t check_direct_IO(struct btrfs_fs_inf=
o *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struc=
t iov_iter *iter, loff_t offset)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize_mask =3D fs_info->sectorsize =
- 1;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize_mask =3D fs_info->data_io_siz=
e - 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (offset & blocksize_mas=
k)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>>>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>>>> index e4ffcd49d7af..29797b767df7 100644
>>>>> --- a/fs/btrfs/disk-io.c
>>>>> +++ b/fs/btrfs/disk-io.c
>>>>> @@ -2508,6 +2508,23 @@ int btrfs_validate_super(const struct
>>>>> btrfs_fs_info *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 data_io_size =
=3D btrfs_super_data_io_size(sb);
>>>>> +
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If data io size i=
s set, make sure it is not smaller than
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sectorsize.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * And for now we on=
ly support data io size up to
>>>>> MAX_BLOCKSIZE.
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!is_power_of=
_2(data_io_size) ||
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size < sectorsize ||
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size > BTRFS_MAX_BLOCKSIZE)) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
trfs_err(fs_info,
>>>>> +=C2=A0=C2=A0=C2=A0 "invalid data io size, has %u expect power of 2 n=
umber in range
>>>>> [%u, %u]",
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size, sectorsize, BTRFS_MAX_BL=
OCKSIZE);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
et =3D -EINVAL;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> +=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_fs_incompat(fs_i=
nfo, REMAP_TREE)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * Reduce test matrix for remap tree by requiring block-
>>>>> group-tree
>>>>> @@ -3472,8 +3489,12 @@ int __cold open_ctree(struct super_block *sb,
>>>>> struct btrfs_fs_devices *fs_device
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize =3D node=
size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize_bits =3D=
 ilog2(nodesize);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize =3D se=
ctorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D=
 btrfs_super_data_io_size(disk_super);
>>>>> +=C2=A0=C2=A0=C2=A0 else
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D=
 sectorsize;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize_bits =
=3D ilog2(sectorsize);
>>>>> -=C2=A0=C2=A0=C2=A0 fs_info->block_min_order =3D ilog2(round_up(secto=
rsize, PAGE_SIZE)
>>>>>>> PAGE_SHIFT);
>>>>> +=C2=A0=C2=A0=C2=A0 fs_info->block_min_order =3D ilog2(round_up(fs_in=
fo->data_io_size,
>>>>> PAGE_SIZE) >> PAGE_SHIFT);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->block_max_order =
=3D calc_block_max_order(fs_info-
>>>>>> sectorsize_bits);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->csums_per_leaf =
=3D BTRFS_MAX_ITEM_SIZE(fs_info) /
>>>>> fs_info->csum_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->fs_devices->fs_in=
fo =3D fs_info;
>>>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>>>> index df8f6f565070..8397d96a5992 100644
>>>>> --- a/fs/btrfs/file.c
>>>>> +++ b/fs/btrfs/file.c
>>>>> @@ -45,8 +45,8 @@
>>>>> =C2=A0=C2=A0=C2=A0 static void btrfs_drop_folio(struct btrfs_fs_info =
*fs_info, struct
>>>>> folio *folio,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 pos, u64 copied)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 u64 block_start =3D round_down(pos, fs_info->sect=
orsize);
>>>>> -=C2=A0=C2=A0=C2=A0 u64 block_len =3D round_up(pos + copied, fs_info-=
>sectorsize) -
>>>>> block_start;
>>>>> +=C2=A0=C2=A0=C2=A0 u64 block_start =3D round_down(pos, fs_info->data=
_io_size);
>>>>> +=C2=A0=C2=A0=C2=A0 u64 block_len =3D round_up(pos + copied, fs_info-=
>data_io_size) -
>>>>> block_start;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(block_len <=3D U32_=
MAX);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio_unlock(folio);
>>>>> @@ -78,8 +78,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode,
>>>>> struct folio *folio, loff_t pos
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (noreserve)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ex=
tra_bits |=3D EXTENT_NORESERVE;
>>>>> -=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->sectorsize=
);
>>>>> -=C2=A0=C2=A0=C2=A0 num_bytes =3D round_up(end_pos - start_pos, fs_in=
fo->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->data_io_si=
ze);
>>>>> +=C2=A0=C2=A0=C2=A0 num_bytes =3D round_up(end_pos - start_pos, fs_in=
fo->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(num_bytes <=3D U32_=
MAX);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(folio_pos(folio) <=
=3D pos && folio_next_pos(folio) >=3D
>>>>> end_pos);
>>>>> @@ -395,7 +395,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle
>>>>> *trans,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_type =3D=3D BTRFS_FILE=
_EXTENT_INLINE) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->bytes_found +=3D extent=
_end - key.offset;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_end =3D ALIGN(extent_e=
nd,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 } else if (update_refs && disk_bytenr > 0) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ref ref =3D {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .acti=
on =3D BTRFS_DROP_DELAYED_REF,
>>>>> @@ -788,7 +788,7 @@ static int prepare_uptodate_folio(struct inode
>>>>> *inode, struct folio *folio, u64
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 clamp_start =3D max_t(=
u64, pos, folio_pos(folio));
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 clamp_end =3D min_t(u6=
4, pos + len, folio_next_pos(folio));
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode_to_fs_info(inode)->=
sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode_to_fs_info(inode)->=
data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (folio_test_uptodate(fo=
lio))
>>>>> @@ -893,8 +893,8 @@ lock_and_cleanup_extent_if_need(struct
>>>>> btrfs_inode *inode, struct folio *folio,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 last_pos;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>>> -=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->sectorsize=
);
>>>>> -=C2=A0=C2=A0=C2=A0 last_pos =3D round_up(pos + write_bytes, fs_info-=
>sectorsize) - 1;
>>>>> +=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->data_io_si=
ze);
>>>>> +=C2=A0=C2=A0=C2=A0 last_pos =3D round_up(pos + write_bytes, fs_info-=
>data_io_size)=20
>>>>> - 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (start_pos < inode->vfs=
_inode.i_size) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ruct btrfs_ordered_extent *ordered;
>>>>> @@ -978,9 +978,9 @@ int btrfs_check_nocow_lock(struct btrfs_inode
>>>>> *inode, loff_t pos,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!btrfs_drew_try_write_=
lock(&root->snapshot_lock))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EAGAIN;
>>>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(pos, fs_info->sectorsize=
);
>>>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(pos, fs_info->data_io_si=
ze);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D round_up(pos +=
 *write_bytes,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fs_info->sectorsize) - 1;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fs_info->data_io_size) - 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nowait) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!btrfs_try_lock_ordered_range(inode, lockstart,=20
>>>>> lockend,
>>>>> @@ -1067,7 +1067,7 @@ int btrfs_write_check(struct kiocb *iocb,
>>>>> size_t count)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 oldsize =3D i_size_read(in=
ode);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pos > oldsize) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Expand hole size to cover write data, preventing empty
>>>>> gap */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t end_pos =3D round_=
up(pos + count, fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t end_pos =3D round_=
up(pos + count, fs_info-=20
>>>>> >data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret)
>>>>> @@ -1090,7 +1090,7 @@ static void release_space(struct btrfs_inode
>>>>> *inode, struct extent_changeset *da
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
nst struct btrfs_fs_info *fs_info =3D inode->root-=20
>>>>> >fs_info;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_delalloc_release_space(inode, data_reserved,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 round_down(start, fs_info->sectorsize),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 round_down(start, fs_info->data_io_size),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 len, true);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0 }
>>>>> @@ -1107,7 +1107,7 @@ static ssize_t reserve_space(struct btrfs_inode
>>>>> *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool *only_release_meta=
data)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct btrfs_fs_info=
 *fs_info =3D inode->root->fs_info;
>>>>> -=C2=A0=C2=A0=C2=A0 const unsigned int block_offset =3D (start & (fs_=
info->sectorsize
>>>>> - 1));
>>>>> +=C2=A0=C2=A0=C2=A0 const unsigned int block_offset =3D (start & (fs_=
info-
>>>>>> data_io_size - 1));
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t reserve_bytes;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> @@ -1132,7 +1132,7 @@ static ssize_t reserve_space(struct btrfs_inode
>>>>> *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *o=
nly_release_metadata =3D true;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0 reserve_bytes =3D round_up(*len + block_offset, f=
s_info-=20
>>>>> >sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 reserve_bytes =3D round_up(*len + block_offset, f=
s_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(reserve_bytes =3D=
=3D 0);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_delalloc_res=
erve_metadata(inode, reserve_bytes,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reserve_bytes, nowait);
>>>>> @@ -1192,7 +1192,7 @@ static int copy_one_range(struct btrfs_inode
>>>>> *inode, struct iov_iter *iter,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cache=
d_state =3D NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t write_bytes =3D cal=
c_write_bytes(inode, iter, start);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t copied;
>>>>> -=C2=A0=C2=A0=C2=A0 const u64 reserved_start =3D round_down(start, fs=
_info-=20
>>>>> >sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 const u64 reserved_start =3D round_down(start, fs=
_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 reserved_len;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio *folio =3D NU=
LL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int extents_locked;
>>>>> @@ -1301,7 +1301,7 @@ static int copy_one_range(struct btrfs_inode
>>>>> *inode, struct iov_iter *iter,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Release the reserved space beyond the last block. */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_block =3D round_up(s=
tart + copied, fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_block =3D round_up(s=
tart + copied, fs_info->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sh=
rink_reserved_space(inode, *data_reserved,=20
>>>>> reserved_start,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 reserved_len, last_block - reserved_start,
>>>>> @@ -1938,7 +1938,7 @@ static vm_fault_t btrfs_page_mkwrite(struct
>>>>> vm_fault *vmf)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (folio_contains(folio, =
(size - 1) >> PAGE_SHIFT)) {
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reserved_space =3D round_=
up(size - page_start, fs_info-
>>>>>> sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reserved_space =3D round_=
up(size - page_start, fs_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (reserved_space < fsize) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 const u64 to_free =3D fsize - reserved_space;
>>>>> @@ -2182,8 +2182,8 @@ static int find_first_non_hole(struct
>>>>> btrfs_inode *inode, u64 *start, u64 *len)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 em =3D btrfs_get_extent(in=
ode, NULL,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_down(*start, fs_info->sectorsize=
),
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_up(*len, fs_info->sectorsize));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_down(*start, fs_info->data_io_si=
ze),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_up(*len, fs_info->data_io_size))=
;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(em))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn PTR_ERR(em);
>>>>> @@ -2396,7 +2396,7 @@ int btrfs_replace_file_extents(struct
>>>>> btrfs_inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =
=3D inode->root;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_i=
nfo =3D root->fs_info;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 min_size =3D=20
>>>>> btrfs_calc_insert_metadata_size(fs_info, 1);
>>>>> -=C2=A0=C2=A0=C2=A0 u64 ino_size =3D round_up(inode->vfs_inode.i_size=
, fs_info-
>>>>>> sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 u64 ino_size =3D round_up(inode->vfs_inode.i_size=
, fs_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle =
*trans =3D NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_block_rsv rsv=
;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int rsv_count;
>>>>> @@ -2667,7 +2667,7 @@ static int btrfs_punch_hole(struct file *file,
>>>>> loff_t offset, loff_t len)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out_only_mutex;
>>>>> -=C2=A0=C2=A0=C2=A0 ino_size =3D round_up(inode->i_size, fs_info->sec=
torsize);
>>>>> +=C2=A0=C2=A0=C2=A0 ino_size =3D round_up(inode->i_size, fs_info->dat=
a_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_first_non_hol=
e(BTRFS_I(inode), &offset, &len);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out_only_mutex;
>>>>> @@ -2681,15 +2681,15 @@ static int btrfs_punch_hole(struct file
>>>>> *file, loff_t offset, loff_t len)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out_only_mutex;
>>>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_up(offset, fs_info->sectorsiz=
e);
>>>>> -=C2=A0=C2=A0=C2=A0 lockend =3D round_down(offset + len, fs_info->sec=
torsize) - 1;
>>>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_up(offset, fs_info->data_io_s=
ize);
>>>>> +=C2=A0=C2=A0=C2=A0 lockend =3D round_down(offset + len, fs_info->dat=
a_io_size) - 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 same_block =3D (BTRFS_BYTE=
S_TO_BLKS(fs_info, offset))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
=3D=3D (BTRFS_BYTES_TO_BLKS(fs_info, offset + len - 1));
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Only do this if we=
 are in the same block and we aren't
>>>>> doing the
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * entire block.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0 if (same_block && len < fs_info->sectorsize) {
>>>>> +=C2=A0=C2=A0=C2=A0 if (same_block && len < fs_info->data_io_size) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (offset < ino_size) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 truncated_block =3D true;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_truncate_block(BTRFS_I(inode), offset +
>>>>> len - 1,
>>>>> @@ -2858,8 +2858,8 @@ static int btrfs_fallocate_update_isize(struct
>>>>> inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mode & FALLOC_FL_KEEP_=
SIZE || end <=3D i_size_read(inode))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn 0;
>>>>> -=C2=A0=C2=A0=C2=A0 range_start =3D round_down(i_size_read(inode), ro=
ot->fs_info-
>>>>>> sectorsize);
>>>>> -=C2=A0=C2=A0=C2=A0 range_end =3D round_up(end, root->fs_info->sector=
size);
>>>>> +=C2=A0=C2=A0=C2=A0 range_start =3D round_down(i_size_read(inode), ro=
ot->fs_info-
>>>>>> data_io_size);
>>>>> +=C2=A0=C2=A0=C2=A0 range_end =3D round_up(end, root->fs_info->data_i=
o_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_inode_set_fi=
le_extent_range(BTRFS_I(inode),
>>>>> range_start,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 range_end - range_start);
>>>>> @@ -2889,7 +2889,7 @@ static int
>>>>> btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 u64 offset)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D inode->root->fs_info->se=
ctorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D inode->root->fs_info->da=
ta_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D round_down(offs=
et, sectorsize);
>>>>> @@ -2916,7 +2916,7 @@ static int btrfs_zero_range(struct inode *inode=
,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_i=
nfo =3D BTRFS_I(inode)->root->fs_info;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_changeset *d=
ata_reserved =3D NULL;
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 alloc_hint =3D 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 orig_start =3D o=
ffset;
>>>>> @@ -3065,7 +3065,7 @@ static int btrfs_zero_range(struct inode *inode=
,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_prealloc_file_range(inode, mode, alloc_start,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 alloc_end - alloc_start,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs=
_info->sectorsize,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs=
_info->data_io_size,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 offset + len, &alloc_hint);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_unlock_extent(&BTRFS_I(inode)->io_tree, lockstart,
>>>>> lockend,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cach=
ed_state);
>>>>> @@ -3105,7 +3105,7 @@ static long btrfs_fallocate(struct file *file,
>>>>> int mode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 data_space_reserved =
=3D 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 qgroup_reserved =3D 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>>>> -=C2=A0=C2=A0=C2=A0 int blocksize =3D BTRFS_I(inode)->root->fs_info->=
sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 int blocksize =3D BTRFS_I(inode)->root->fs_info->=
data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_is_shutdown(inod=
e_to_fs_info(inode)))
>>>>> @@ -3414,7 +3414,7 @@ bool btrfs_find_delalloc_in_range(struct
>>>>> btrfs_inode *inode, u64 start, u64 end,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_sta=
te **cached_state,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 *delalloc_sta=
rt_ret, u64 *delalloc_end_ret)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 u64 cur_offset =3D round_down(start, inode->root-=
>fs_info-
>>>>>> sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 u64 cur_offset =3D round_down(start, inode->root-=
>fs_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 prev_delalloc_end =3D =
0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool search_io_tree =3D tr=
ue;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ret =3D false;
>>>>> @@ -3602,10 +3602,10 @@ static loff_t find_desired_extent(struct file
>>>>> *file, loff_t offset, int whence)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3D max_t(loff_t, 0,=
 offset);
>>>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(start, fs_info->sectorsi=
ze);
>>>>> -=C2=A0=C2=A0=C2=A0 lockend =3D round_up(i_size, fs_info->sectorsize)=
;
>>>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(start, fs_info->data_io_=
size);
>>>>> +=C2=A0=C2=A0=C2=A0 lockend =3D round_up(i_size, fs_info->data_io_siz=
e);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (lockend <=3D lockstart=
)
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D lockstart + f=
s_info->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D lockstart + f=
s_info->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend--;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path(=
);
>>>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>>>>> index ab5ed7b4f639..cee4c772cfd9 100644
>>>>> --- a/fs/btrfs/fs.h
>>>>> +++ b/fs/btrfs/fs.h
>>>>> @@ -299,7 +299,7 @@ enum {
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_SAFE_SET=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0ULL
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0ULL
>>>>> -#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_F=
REE_SPACE_TREE |=C2=A0=C2=A0=C2=A0 \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT=
_RO_FREE_SPACE_TREE_VALID | \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT=
_RO_VERITY |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>>>> @@ -335,11 +335,17 @@ enum {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_INCOMP=
AT_EXTENT_TREE_V2 | \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_INCOMP=
AT_REMAP_TREE)
>>>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 \
>>>>> +=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE |=C2=A0=C2=
=A0=C2=A0 \
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE)
>>>>> =C2=A0=C2=A0=C2=A0 #else
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_SUPP=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_INCOMPAT_SU=
PP_STABLE)
>>>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 \
>>>>> +=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE)
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0 #endif
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>>>> @@ -892,6 +898,7 @@ struct btrfs_fs_info {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csum_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csums_per_leaf;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csum_type;
>>>>> +=C2=A0=C2=A0=C2=A0 u32 data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Maximum size of an=
 extent. BTRFS_MAX_EXTENT_SIZE on regular
>>>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>>>> index b696dd329fd7..de0364ce950b 100644
>>>>> --- a/fs/btrfs/inode.c
>>>>> +++ b/fs/btrfs/inode.c
>>>>> @@ -190,7 +190,7 @@ static int data_reloc_print_warning_inode(u64
>>>>> inum, u64 offset, u64 num_bytes,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_warn(fs_info,
>>>>> =C2=A0=C2=A0=C2=A0 "checksum error at logical %llu mirror %u root %ll=
u inode %llu
>>>>> offset %llu length %u links %u (path: %s)",
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warn->logical, warn->mirror_num, ro=
ot, inum,=20
>>>>> offset,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fs_info->sectorsize, nlink,
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fs_info->data_io_size, nlink,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (char *)(unsigned long)ipath->fspat=
h->val[i]);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> @@ -1397,7 +1397,7 @@ static noinline int cow_file_range(struct
>>>>> btrfs_inode *inode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_is_data_reloc_ro=
ot(root))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mi=
n_alloc_size =3D num_bytes;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 min_alloc_size =3D fs_inf=
o->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 min_alloc_size =3D fs_inf=
o->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (num_bytes > 0) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D cow_one_range(inode, locked_folio, &ins, &cached,
>>>>> start,
>>>>> @@ -2783,7 +2783,7 @@ int btrfs_set_extent_delalloc(struct
>>>>> btrfs_inode *inode, u64 start, u64 end,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int extr=
a_bits,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_sta=
te **cached_state)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->sec=
torsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->dat=
a_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Basic alignment check. =
*/
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(IS_ALIGNED(start, b=
locksize), "start=3D%llu=20
>>>>> blocksize=3D%u",
>>>>> @@ -2820,7 +2820,7 @@ int btrfs_set_extent_delalloc(struct
>>>>> btrfs_inode *inode, u64 start, u64 end,
>>>>> =C2=A0=C2=A0=C2=A0 int btrfs_reset_extent_delalloc(struct btrfs_inode=
 *inode, u64
>>>>> start, u64 end,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int extra_bits, stru=
ct extent_state
>>>>> **cached_state)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->sec=
torsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->dat=
a_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The @extra_bits can onl=
y be EXTENT_NORESERVE for now. */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(!(extra_bits & ~EXT=
ENT_NORESERVE), "extra_bits=3D0x%x",
>>>>> extra_bits);
>>>>> @@ -2874,7 +2874,7 @@ static int insert_reserved_file_extent(struct
>>>>> btrfs_trans_handle *trans,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 num_bytes =3D btrfs_st=
ack_file_extent_num_bytes(stack_fi);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ram_bytes =3D btrfs_st=
ack_file_extent_ram_bytes(stack_fi);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_drop_extents_=
args drop_args =3D { 0 };
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D root->fs_info->sectorsiz=
e;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D root->fs_info->data_io_s=
ize;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path(=
);
>>>>> @@ -4040,7 +4040,7 @@ static int btrfs_read_locked_inode(struct
>>>>> btrfs_inode *inode, struct btrfs_path
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 go=
to out;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_inode_set_file_exten=
t_range(inode, 0,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 round_up(i_size_read(vfs_inode), fs_info->sectorsize));
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 round_up(i_size_read(vfs_inode), fs_info-=20
>>>>> >data_io_size));
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!maybe_acls)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ca=
che_no_acl(vfs_inode);
>>>>> @@ -4879,7 +4879,7 @@ int btrfs_truncate_block(struct btrfs_inode
>>>>> *inode, u64 offset, u64 start, u64 e
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cache=
d_state =3D NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_changeset *d=
ata_reserved =3D NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool only_release_metadata=
 =3D false;
>>>>> -=C2=A0=C2=A0=C2=A0 u32 blocksize =3D fs_info->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 u32 blocksize =3D fs_info->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgoff_t index =3D (offset =
>> PAGE_SHIFT);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio *folio;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t mask =3D btrfs_alloc=
_write_mask(mapping);
>>>>> @@ -5117,8 +5117,8 @@ int btrfs_cont_expand(struct btrfs_inode
>>>>> *inode, loff_t oldsize, loff_t size)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_io_tree *io_=
tree =3D &inode->io_tree;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em =3D =
NULL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cache=
d_state =3D NULL;
>>>>> -=C2=A0=C2=A0=C2=A0 u64 hole_start =3D ALIGN(oldsize, fs_info->sector=
size);
>>>>> -=C2=A0=C2=A0=C2=A0 u64 block_end =3D ALIGN(size, fs_info->sectorsize=
);
>>>>> +=C2=A0=C2=A0=C2=A0 u64 hole_start =3D ALIGN(oldsize, fs_info->data_i=
o_size);
>>>>> +=C2=A0=C2=A0=C2=A0 u64 block_end =3D ALIGN(size, fs_info->data_io_si=
ze);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 last_byte;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 cur_offset;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 hole_size;
>>>>> @@ -5147,7 +5147,7 @@ int btrfs_cont_expand(struct btrfs_inode
>>>>> *inode, loff_t oldsize, loff_t size)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 la=
st_byte =3D min(btrfs_extent_map_end(em), block_end);
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_byte =3D ALIGN(last_=
byte, fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_byte =3D ALIGN(last_=
byte, fs_info->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ho=
le_size =3D last_byte - cur_offset;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (!(em->flags & EXTENT_FLAG_PREALLOC)) {
>>>>> @@ -5253,7 +5253,7 @@ static int btrfs_setsize(struct inode *inode,
>>>>> struct iattr *attr)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (btrfs_is_zoned(fs_info)) {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_wait_ordered_range(BTRFS_I(inode),
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN(newsize, fs_info->se=
ctorsize),
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN(newsize, fs_info->da=
ta_io_size),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u64)=
-1);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>>>> @@ -7323,7 +7323,7 @@ noinline int can_nocow_extent(struct
>>>>> btrfs_inode *inode, u64 offset, u64 *len,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u6=
4 range_end;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ra=
nge_end =3D round_up(offset +
>>>>> nocow_args.file_extent.num_bytes,
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root->fs_info->secto=
rsize) - 1;
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root->fs_info->data_=
io_size) - 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D btrfs_test_range_bit_exists(io_tree, offset,=20
>>>>> range_end,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 EXTENT_DELALLOC);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret)
>>>>> @@ -7653,8 +7653,8 @@ static int btrfs_truncate(struct btrfs_inode
>>>>> *inode, bool skip_writeback)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle =
*trans;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 min_size =3D btr=
fs_calc_metadata_size(fs_info, 1);
>>>>> -=C2=A0=C2=A0=C2=A0 const u64 lock_start =3D round_down(inode->vfs_in=
ode.i_size,
>>>>> fs_info->sectorsize);
>>>>> -=C2=A0=C2=A0=C2=A0 const u64 i_size_up =3D round_up(inode->vfs_inode=
.i_size, fs_info-
>>>>>> sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 const u64 lock_start =3D round_down(inode->vfs_in=
ode.i_size,
>>>>> fs_info->data_io_size);
>>>>> +=C2=A0=C2=A0=C2=A0 const u64 i_size_up =3D round_up(inode->vfs_inode=
.i_size, fs_info-
>>>>>> data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Our inode is locked and=
 the i_size can't be changed
>>>>> concurrently. */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_assert_inode_locked(=
inode);
>>>>> @@ -8038,7 +8038,7 @@ static int btrfs_getattr(struct mnt_idmap=20
>>>>> *idmap,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 delalloc_bytes;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 inode_bytes;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D d_=
inode(path->dentry);
>>>>> -=C2=A0=C2=A0=C2=A0 u32 blocksize =3D btrfs_sb(inode->i_sb)->sectorsi=
ze;
>>>>> +=C2=A0=C2=A0=C2=A0 u32 blocksize =3D btrfs_sb(inode->i_sb)->data_io_=
size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 bi_flags =3D BTRFS_I(i=
node)->flags;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 bi_ro_flags =3D BTRFS_=
I(inode)->ro_flags;
>>>>> @@ -9124,8 +9124,8 @@ static int __btrfs_prealloc_file_range(struct
>>>>> inode *inode, int mode,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to truncate disk_i_size to the start of the g=
ap,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 * making the persisted size smaller than i_size=
.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
ange_start =3D round_down(inode->i_size, fs_info-
>>>>>> sectorsize);
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
ange_end =3D round_up(i_size, fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
ange_start =3D round_down(inode->i_size, fs_info-
>>>>>> data_io_size);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r=
ange_end =3D round_up(i_size, fs_info->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 ret =3D=20
>>>>> btrfs_inode_set_file_extent_range(BTRFS_I(inode),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 range=
_start, range_end - range_start);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>>>>> @@ -9272,10 +9272,10 @@ int
>>>>> btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info=20
>>>>> *fs_info,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * The LZO format depends on the sector size. 64K is the
>>>>> maximum
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 * sector size that we support.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->sectorsize <=
 SZ_4K || fs_info->sectorsize >
>>>>> SZ_64K)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->data_io_size=
 < SZ_4K || fs_info->data_io_size >
>>>>> SZ_64K)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn BTRFS_ENCODED_IO_COMPRESSION_LZO_4K +
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (fs_info->sectorsize_bits - 12);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (ilog2(fs_info->data_io_size) - 12);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BTRFS_COMPRESS_ZSTD:
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn BTRFS_ENCODED_IO_COMPRESSION_ZSTD;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>>>> @@ -9563,7 +9563,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb,
>>>>> struct iov_iter *iter,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bt=
rfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn 0;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> -=C2=A0=C2=A0=C2=A0 start =3D ALIGN_DOWN(iocb->ki_pos, fs_info->secto=
rsize);
>>>>> +=C2=A0=C2=A0=C2=A0 start =3D ALIGN_DOWN(iocb->ki_pos, fs_info->data_=
io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We don't know how =
long the extent containing iocb->ki_pos
>>>>> is, but if
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it's compressed we=
 know that it won't be longer than this.
>>>>> @@ -9676,7 +9676,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb,
>>>>> struct iov_iter *iter,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
unt =3D start + *disk_io_size - iocb->ki_pos;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 en=
coded->len =3D count;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 en=
coded->unencoded_len =3D count;
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *disk_io_size =3D ALIGN(*=
disk_io_size, fs_info->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *disk_io_size =3D ALIGN(*=
disk_io_size, fs_info->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_free_extent_map(em);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 em =3D NULL;
>>>>> @@ -9720,7 +9720,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb
>>>>> *iocb, struct iov_iter *from,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int compression;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t orig_count;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 min_folio_size =
=3D btrfs_min_folio_size(fs_info);
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D fs_info->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D fs_info->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 start, end;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 num_bytes, ram_bytes, =
disk_num_bytes;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key ins;
>>>>> @@ -9743,7 +9743,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb
>>>>> *iocb, struct iov_iter *from,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 The sector size must match for LZO. */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (encoded->compression -
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12 !=3D
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 f=
s_info->sectorsize_bits)
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i=
log2(blocksize))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
mpression =3D BTRFS_COMPRESS_LZO;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>>>>> @@ -9785,7 +9785,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb
>>>>> *iocb, struct iov_iter *from,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The extent must start o=
n a sector boundary. */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3D iocb->ki_pos;
>>>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(start, fs_info->sectorsize))
>>>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(start, fs_info->data_io_size))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> @@ -9794,15 +9794,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb
>>>>> *iocb, struct iov_iter *from,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * up the extent size=
 and set i_size to the unaligned end.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (start + encoded->len <=
 inode->vfs_inode.i_size &&
>>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !IS_ALIGNED(start + encod=
ed->len, fs_info->sectorsize))
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !IS_ALIGNED(start + encod=
ed->len, fs_info->data_io_size))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Finally, the offset in =
the unencoded data must be sector-
>>>>> aligned. */
>>>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(encoded->unencoded_offset, fs_inf=
o->sectorsize))
>>>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(encoded->unencoded_offset, fs_inf=
o-=20
>>>>> >data_io_size))
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn -EINVAL;
>>>>> -=C2=A0=C2=A0=C2=A0 num_bytes =3D ALIGN(encoded->len, fs_info->sector=
size);
>>>>> -=C2=A0=C2=A0=C2=A0 ram_bytes =3D ALIGN(encoded->unencoded_len, fs_in=
fo->sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 num_bytes =3D ALIGN(encoded->len, fs_info->data_i=
o_size);
>>>>> +=C2=A0=C2=A0=C2=A0 ram_bytes =3D ALIGN(encoded->unencoded_len, fs_in=
fo->data_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 end =3D start + num_bytes =
- 1;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>>>> @@ -9810,7 +9810,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb
>>>>> *iocb, struct iov_iter *from,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sector-aligned. Fo=
r convenience, we extend it with zeroes
>>>>> if it
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * isn't.
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> -=C2=A0=C2=A0=C2=A0 disk_num_bytes =3D ALIGN(orig_count, fs_info->sec=
torsize);
>>>>> +=C2=A0=C2=A0=C2=A0 disk_num_bytes =3D ALIGN(orig_count, fs_info->dat=
a_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cb =3D btrfs_alloc_compres=
sed_write(inode, start, num_bytes);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (int i =3D 0; i * min_=
folio_size < disk_num_bytes; i++) {
>>>>> @@ -10222,7 +10222,7 @@ static int btrfs_swap_activate(struct
>>>>> swap_info_struct *sis, struct file *file,
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&root->nr_swapf=
iles);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&root->root_it=
em_lock);
>>>>> -=C2=A0=C2=A0=C2=A0 isize =3D ALIGN_DOWN(inode->i_size, fs_info->sect=
orsize);
>>>>> +=C2=A0=C2=A0=C2=A0 isize =3D ALIGN_DOWN(inode->i_size, fs_info->data=
_io_size);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_lock_extent(io_tree,=
 0, isize - 1, &cached_state);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (prev_extent_end < i=
size) {
>>>>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>>>>> index 1531adb117d1..0235530fd0f8 100644
>>>>> --- a/fs/btrfs/lzo.c
>>>>> +++ b/fs/btrfs/lzo.c
>>>>> @@ -414,7 +414,7 @@ int lzo_decompress_bio(struct list_head *ws,
>>>>> struct compressed_bio *cb)
>>>>> =C2=A0=C2=A0=C2=A0 {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct workspace *workspac=
e =3D list_entry(ws, struct workspace,
>>>>> list);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_i=
nfo =3D cb->bbio.inode->root->fs_info;
>>>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->sectorsize;
>>>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 compressed_len =
=3D bio_get_size(&cb->bbio.bio);
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio_iter fi;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char *kaddr;
>>>>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>>>>> index 0d14570c8bc2..8ca7b7e304e3 100644
>>>>> --- a/fs/btrfs/sysfs.c
>>>>> +++ b/fs/btrfs/sysfs.c
>>>>> @@ -301,6 +301,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2,
>>>>> EXTENT_TREE_V2);
>>>>> =C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_ST=
RIPE_TREE);
>>>>> =C2=A0=C2=A0=C2=A0 /* Remove once support for remap tree is feature c=
omplete. */
>>>>> =C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
>>>>> +BTRFS_FEAT_ATTR_COMPAT_RO(data_io_size, DATA_IO_SIZE);
>>>>> =C2=A0=C2=A0=C2=A0 #endif
>>>>> =C2=A0=C2=A0=C2=A0 #ifdef CONFIG_FS_VERITY
>>>>> =C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
>>>>> @@ -334,6 +335,7 @@ static struct attribute
>>>>> *btrfs_supported_feature_attrs[] =3D {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(extent=
_tree_v2),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(raid_s=
tripe_tree),
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(remap_=
tree),
>>>>> +=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(data_io_size),
>>>>> =C2=A0=C2=A0=C2=A0 #endif
>>>>> =C2=A0=C2=A0=C2=A0 #ifdef CONFIG_FS_VERITY
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(verity=
),
>>>>> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-=20
>>>>> tests.c
>>>>> index 6287d940323d..e3e7bbee7cd7 100644
>>>>> --- a/fs/btrfs/tests/btrfs-tests.c
>>>>> +++ b/fs/btrfs/tests/btrfs-tests.c
>>>>> @@ -140,6 +140,7 @@ struct btrfs_fs_info
>>>>> *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize =3D node=
size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize =3D se=
ctorsize;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize_bits =
=3D ilog2(sectorsize);
>>>>> +=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D sectorsize;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* CRC32C csum size. */
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->csum_size =3D 4;
>>>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>>>> index 0a13baf3d8d1..858a37811586 100644
>>>>> --- a/include/uapi/linux/btrfs.h
>>>>> +++ b/include/uapi/linux/btrfs.h
>>>>> @@ -314,6 +314,13 @@ struct btrfs_ioctl_fs_info_args {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 */
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE=
=C2=A0=C2=A0=C2=A0 (1ULL << 3)
>>>>> +/*
>>>>> + * Force all IOs (including buffered, direct, compressed) to be=20
>>>>> aligned
>>>>> + * to btrfs_super_block::data_io_size other than sectorsize.
>>>>> + * Meanwhile still data checksum to be calculated based on=20
>>>>> sectorsize.
>>>>> + */
>>>>> +#define BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (1ULL << 4)
>>>>> +
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF=C2=A0=
=C2=A0=C2=A0 (1ULL << 0)
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL=C2=
=A0=C2=A0=C2=A0 (1ULL << 1)
>>>>> =C2=A0=C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS=C2=A0=
=C2=A0=C2=A0 (1ULL << 2)
>>>>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/
>>>>> btrfs_tree.h
>>>>> index cc3b9f7dccaf..3b979ba5a3fc 100644
>>>>> --- a/include/uapi/linux/btrfs_tree.h
>>>>> +++ b/include/uapi/linux/btrfs_tree.h
>>>>> @@ -724,9 +724,10 @@ struct btrfs_super_block {
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 remap_root;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 remap_root_generati=
on;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 remap_root_level;
>>>>> +=C2=A0=C2=A0=C2=A0 __u32 data_io_size;
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Future expansion */
>>>>> -=C2=A0=C2=A0=C2=A0 __u8 reserved[199];
>>>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved[195];
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 sys_chunk_array[BTRFS=
_SYSTEM_CHUNK_ARRAY_SIZE];
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root_backup s=
uper_roots[BTRFS_NUM_BACKUP_ROOTS];
>>>
>=20
>
