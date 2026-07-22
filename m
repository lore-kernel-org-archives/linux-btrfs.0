Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B867C479885
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jul 2026 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714323; cv=none; b=eHY+z9TUrzBAg7MaoAiyENAq8RbcSB5TegagAYvqOSvMiQYt8LnTRvM94trDqNj0zCuwsiWuUqRanhOr8qTPFoYO6u1LlqvWcezQS9uAzpwxNffdATgw1u9CFPj/Kw4makunkDiZm00Th/fcy0LJkv7RaiXIJ1PVz25Do0MiY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714323; c=relaxed/simple;
	bh=qQSYltofKXDr2fPZGNX/mx9W/BdX3i/xQaCckCi/xho=;
	h=Message-Id:Content-Type:Subject:Mime-Version:References:From:Date:
	 In-Reply-To:To; b=dEhBMlzYBsZrl+HRgUOZbO66OHViKfX2Ou0gc6mmXcJ0bO7LbBMAdBSqvnM8BWQntcXYBFyRHPK3aNTGawM++eeDfNAVwQsDLCIdrFHDqgoeThCqgzx00B6qXj5woA5+alKjWjWNfc8k57a/FSuO7C7ocBEOLk6pQTXY3RoPtsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IozKwKtp; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IozKwKtp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784714309;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qQSYltofKXDr2fPZGNX/mx9W/BdX3i/xQaCckCi/xho=;
 b=IozKwKtpMaH1yMmifplZ8/FKWdQf7G0py9ekcWpOnf61ZZhFcOYscXnRlKBhstX2cyprzo
 4/PEV9W6xQ+9Vg/AO2UbJvSXdgsBvpaJJEQ95kpR3BTRwcIl81o3pOeV1ddtiva4H6wDpy
 A3G5LZ7QL8p2WpxeXllN9j8hioVKUIaveuxoK9t/8SVnRRpNDOCwUVDpmH5H100/T8nj5z
 UxdDcxhmxehbiSvQxiYuIXGDu+aVPATNdblwNOh4VDB7qSrvedVAFgUsvRVc1WGA5pFdFe
 Jox6a/G38hD4iOFTAyfQxOwZ8AQBksbUdIfGW785HCmyaeMtf3AxEaTH1qJ47g==
Message-Id: <ca3eeaeb-76d4-4a23-a019-d3a5f4ceb431@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a609444+a73c34+vger.kernel.org+sunyangkai@fygo.io>
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature, data_io_size
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com> <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io> <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com>
Received: from [192.168.10.244] ([183.34.163.75]) by smtp.larksuite.com with ESMTPS; Wed, 22 Jul 2026 09:58:27 +0000
X-Original-From: Sun YangKai <sunyangkai@fygo.io>
From: "Sun YangKai" <sunyangkai@fygo.io>
Date: Wed, 22 Jul 2026 17:58:23 +0800
In-Reply-To: <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com>
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>

On 2026/7/22 17:25, Qu Wenruo wrote:
>=20
>=20
> =E5=9C=A8 2026/7/22 18:52, Sun YangKai =E5=86=99=E9=81=93:
>> On 2026/6/28 14:27, Qu Wenruo wrote:
>>> To address the btrfs RAID56 write-hole problem, there is one idea to
>>> solve it:
>>>
>>> =C2=A0=C2=A0 Make sure all data writes are full stripe aligned
>>> However based on that idea, we can have two different directions to
>>> implement:
>>>
>>> - Keep the sector size untouched, introduce a newer io size for data
>>> =C2=A0=C2=A0=C2=A0 E.g. sector size is still 4K, but data io size is 16=
K, and RAID56
>>> =C2=A0=C2=A0=C2=A0 full stripe size is also set to 16K.
>>
>> Sorry, I cannot follow you here about "RAID56 full stripe size is also
>> set to 16K".
>=20
> Just as what it reads.
>=20
> Not using the fixed 64K stripe size, but per-chunk full stripe size.

I appreciate that you'd love to explain more about this.

But I still cannot understand how 16KiB full stripe size can fit on a 4=20
disks RAID5 for example. Currently we have 3*64KiB =3D 192KiB as full=20
stripe size for this kind of setup. But if using 16KiB full stripe size,=20
how many data on each disk and how's the logical address mapped to those=20
disks?

Thanks,
Sun YangKai

>>
>> Currently I think we have a 64KiB chunk on each disk, and for n disks
>> RAID5, we have (n-1) * 64KiB as data's full stripe size and one more
>> 64KiB for parity if I understand it correctly. Then how can we limit the
>> full stripe size to 16K with n devices?
>>
>> 16K/(n-1) bytes on each disk is insane. Or we just limit device count
>> for RAID5 to a specific number like 3 disks so we can have 2 device for
>> data, 1 for parity and can get a 8KiB chunk on each disk?
>>
>>> =C2=A0=C2=A0=C2=A0 This allows us to reuse the existing sector size bas=
ed
>>> =C2=A0=C2=A0=C2=A0 read-repair/scrub.
>>>
>>> =C2=A0=C2=A0=C2=A0 And this patch is the PoC of this idea.
>>>
>>> =C2=A0=C2=A0=C2=A0 The problems are also obvious, we need to not only i=
ntroduce a
>>> =C2=A0=C2=A0=C2=A0 dedicated compat RO flag, but also convert almost al=
l sectorsize=20
>>> users
>>> =C2=A0=C2=A0=C2=A0 to use the new data_io_size, except data checksum an=
d read-repair
>>> =C2=A0=C2=A0=C2=A0 related code.
>>>
>>> - Use larger block size, introduce a newer sub-block RAID56 repair
>>> =C2=A0=C2=A0=C2=A0 E.g. sector size is 16K, and RAID56 full stripe size=
 is also set to
>>> =C2=A0=C2=A0=C2=A0 16K.
>>>
>>> =C2=A0=C2=A0=C2=A0 This allows us to reuse the existing experimental bs=
 > ps support.
>>>
>>> =C2=A0=C2=A0=C2=A0 The problems are that we need a completely new RAID5=
6 sub-block
>>> =C2=A0=C2=A0=C2=A0 rebuild handling.
>>> =C2=A0=C2=A0=C2=A0 And the new rebuild can be very slow. Since we do no=
t know exact=20
>>> which
>>> =C2=A0=C2=A0=C2=A0 sub-block is corrupted, we have to exhaust all combi=
nations just=20
>>> for a
>>> =C2=A0=C2=A0=C2=A0 single block.
>>>
>>> =C2=A0=C2=A0=C2=A0 And the current btrfs_map_block() also need to suppo=
rt sub-block
>>> =C2=A0=C2=A0=C2=A0 splitting, which is completely new, and will also af=
fect checksum
>>> =C2=A0=C2=A0=C2=A0 handling.
>>>
>>> So far it looks like the new data io size is the easier solution, thus
>>> here is the RFC patch.
>>>
>>> But in reality, this RFC patch is already super huge, almost touching
>>> all call sites using fs_info->sectorsize, and there are still a lot of
>>> left-over and causing all kinds of warnings.
>>>
>>> For now I'm wondering if it would be better just to replace sectorsize
>>> with data_io_size, and introduce a dedicated member for checksum/scrub.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> Reason for RFC:
>>> This patch is still very unstable, there are still a lot of sites not
>>> properly converted to use the new fs_info->data_io_size.
>>>
>>> This is only for proof-of-concept purpose.
>>> ---
>>> =C2=A0=C2=A0 fs/btrfs/accessors.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
>>> =C2=A0=C2=A0 fs/btrfs/direct-io.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 6 +--
>>> =C2=A0=C2=A0 fs/btrfs/disk-io.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23 ++++++++++-
>>> =C2=A0=C2=A0 fs/btrfs/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 68 +++++++++++++++=
=20
>>> +-----------------
>>> =C2=A0=C2=A0 fs/btrfs/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 9 +=
+++-
>>> =C2=A0=C2=A0 fs/btrfs/inode.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 60 ++++++++++++++-------=
--------
>>> =C2=A0=C2=A0 fs/btrfs/lzo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
>>> =C2=A0=C2=A0 fs/btrfs/sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
>>> =C2=A0=C2=A0 fs/btrfs/tests/btrfs-tests.c=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
>>> =C2=A0=C2=A0 include/uapi/linux/btrfs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 7 ++++
>>> =C2=A0=C2=A0 include/uapi/linux/btrfs_tree.h |=C2=A0 3 +-
>>> =C2=A0=C2=A0 11 files changed, 112 insertions(+), 71 deletions(-)
>>>
>>> diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
>>> index 8938357fcb40..7a5206db2224 100644
>>> --- a/fs/btrfs/accessors.h
>>> +++ b/fs/btrfs/accessors.h
>>> @@ -889,6 +889,8 @@=20
>>> BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct=20
>>> btrfs_super_block,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 remap_root_generation, 64);
>>> =C2=A0=C2=A0 BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, struct=20
>>> btrfs_super_block,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 remap_root_level, 8);
>>> +BTRFS_SETGET_STACK_FUNCS(super_data_io_size, struct btrfs_super_block,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 data_io_size, 32);
>>> =C2=A0=C2=A0 /* struct btrfs_file_extent_item */
>>> =C2=A0=C2=A0 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct=20
>>> btrfs_file_extent_item,
>>> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
>>> index 3e227292b0ac..df1b2f2725ca 100644
>>> --- a/fs/btrfs/direct-io.c
>>> +++ b/fs/btrfs/direct-io.c
>>> @@ -186,7 +186,7 @@ static struct extent_map=20
>>> *btrfs_new_extent_direct(struct btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 alloc_hint =3D btrfs_get_extent_al=
location_hint(inode, start, len);
>>> =C2=A0=C2=A0 again:
>>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_reserve_extent(root, len, len, fs_inf=
o->sectorsize,
>>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_reserve_extent(root, len, len, fs_inf=
o->data_io_size,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0, alloc_hint, &i=
ns, true, true);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret =3D=3D -EAGAIN) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(btr=
fs_is_zoned(fs_info));
>>> @@ -395,7 +395,7 @@ static int btrfs_dio_iomap_begin(struct inode=20
>>> *inode, loff_t start,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * to allocate a contiguous a=
rray for the checksums.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!write)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len =3D min_t(u64, len, fs_=
info->sectorsize * BIO_MAX_VECS);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 len =3D min_t(u64, len, fs_=
info->data_io_size * BIO_MAX_VECS);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockstart =3D start;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D start + len - 1;
>>> @@ -829,7 +829,7 @@ static struct iomap_dio *btrfs_dio_write(struct=20
>>> kiocb *iocb, struct iov_iter *it
>>> =C2=A0=C2=A0 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_in=
fo,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct iov_=
iter *iter, loff_t offset)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize_mask =3D fs_info->sectorsize - =
1;
>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize_mask =3D fs_info->data_io_size =
- 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (offset & blocksize_mask)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EI=
NVAL;
>>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>>> index e4ffcd49d7af..29797b767df7 100644
>>> --- a/fs/btrfs/disk-io.c
>>> +++ b/fs/btrfs/disk-io.c
>>> @@ -2508,6 +2508,23 @@ int btrfs_validate_super(const struct=20
>>> btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -E=
INVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 data_io_size =3D =
btrfs_super_data_io_size(sb);
>>> +
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * If data io size is =
set, make sure it is not smaller than
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sectorsize.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * And for now we only=
 support data io size up to=20
>>> MAX_BLOCKSIZE.
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(!is_power_of_2=
(data_io_size) ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size < sectorsize ||
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size > BTRFS_MAX_BLOCKSIZE)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btr=
fs_err(fs_info,
>>> +=C2=A0=C2=A0=C2=A0 "invalid data io size, has %u expect power of 2 num=
ber in range=20
>>> [%u, %u]",
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 data_io_size, sectorsize, BTRFS_MAX_BLOCK=
SIZE);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
 =3D -EINVAL;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_fs_incompat(fs_info, REM=
AP_TREE)) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Re=
duce test matrix for remap tree by requiring block-=20
>>> group-tree
>>> @@ -3472,8 +3489,12 @@ int __cold open_ctree(struct super_block *sb,=20
>>> struct btrfs_fs_devices *fs_device
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize =3D nodesize;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize_bits =3D ilog2(n=
odesize);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize =3D sectorsize=
;
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_compat_ro(fs_info, DATA_IO_SIZE))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D b=
trfs_super_data_io_size(disk_super);
>>> +=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D s=
ectorsize;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize_bits =3D ilog2=
(sectorsize);
>>> -=C2=A0=C2=A0=C2=A0 fs_info->block_min_order =3D ilog2(round_up(sectors=
ize, PAGE_SIZE)=20
>>> >> PAGE_SHIFT);
>>> +=C2=A0=C2=A0=C2=A0 fs_info->block_min_order =3D ilog2(round_up(fs_info=
->data_io_size,=20
>>> PAGE_SIZE) >> PAGE_SHIFT);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->block_max_order =3D calc_=
block_max_order(fs_info-=20
>>> >sectorsize_bits);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->csums_per_leaf =3D BTRFS_=
MAX_ITEM_SIZE(fs_info) /=20
>>> fs_info->csum_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->fs_devices->fs_info =3D f=
s_info;
>>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>>> index df8f6f565070..8397d96a5992 100644
>>> --- a/fs/btrfs/file.c
>>> +++ b/fs/btrfs/file.c
>>> @@ -45,8 +45,8 @@
>>> =C2=A0=C2=A0 static void btrfs_drop_folio(struct btrfs_fs_info *fs_info=
, struct=20
>>> folio *folio,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 pos, u64 copied)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 u64 block_start =3D round_down(pos, fs_info->sector=
size);
>>> -=C2=A0=C2=A0=C2=A0 u64 block_len =3D round_up(pos + copied, fs_info->s=
ectorsize) -=20
>>> block_start;
>>> +=C2=A0=C2=A0=C2=A0 u64 block_start =3D round_down(pos, fs_info->data_i=
o_size);
>>> +=C2=A0=C2=A0=C2=A0 u64 block_len =3D round_up(pos + copied, fs_info->d=
ata_io_size) -=20
>>> block_start;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(block_len <=3D U32_MAX);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 folio_unlock(folio);
>>> @@ -78,8 +78,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode,=20
>>> struct folio *folio, loff_t pos
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (noreserve)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extra_bits=
 |=3D EXTENT_NORESERVE;
>>> -=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->sectorsize);
>>> -=C2=A0=C2=A0=C2=A0 num_bytes =3D round_up(end_pos - start_pos, fs_info=
->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->data_io_size=
);
>>> +=C2=A0=C2=A0=C2=A0 num_bytes =3D round_up(end_pos - start_pos, fs_info=
->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(num_bytes <=3D U32_MAX);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(folio_pos(folio) <=3D pos &=
& folio_next_pos(folio) >=3D=20
>>> end_pos);
>>> @@ -395,7 +395,7 @@ int btrfs_drop_extents(struct btrfs_trans_handle=20
>>> *trans,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_type =3D=3D BTRFS_FILE_EXTEN=
T_INLINE) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 args->bytes_found +=3D extent_end -=
 key.offset;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 extent_end =3D ALIGN(extent_end,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 } else if (update_refs && disk_bytenr > 0) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ref ref =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .action =3D=
 BTRFS_DROP_DELAYED_REF,
>>> @@ -788,7 +788,7 @@ static int prepare_uptodate_folio(struct inode=20
>>> *inode, struct folio *folio, u64
>>> =C2=A0=C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 clamp_start =3D max_t(u64, pos=
, folio_pos(folio));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 clamp_end =3D min_t(u64, pos +=
 len, folio_next_pos(folio));
>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode_to_fs_info(inode)->se=
ctorsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode_to_fs_info(inode)->da=
ta_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (folio_test_uptodate(folio))
>>> @@ -893,8 +893,8 @@ lock_and_cleanup_extent_if_need(struct=20
>>> btrfs_inode *inode, struct folio *folio,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 last_pos;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> -=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->sectorsize);
>>> -=C2=A0=C2=A0=C2=A0 last_pos =3D round_up(pos + write_bytes, fs_info->s=
ectorsize) - 1;
>>> +=C2=A0=C2=A0=C2=A0 start_pos =3D round_down(pos, fs_info->data_io_size=
);
>>> +=C2=A0=C2=A0=C2=A0 last_pos =3D round_up(pos + write_bytes, fs_info->d=
ata_io_size) - 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (start_pos < inode->vfs_inode.i=
_size) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btr=
fs_ordered_extent *ordered;
>>> @@ -978,9 +978,9 @@ int btrfs_check_nocow_lock(struct btrfs_inode=20
>>> *inode, loff_t pos,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!btrfs_drew_try_write_lock(&ro=
ot->snapshot_lock))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EA=
GAIN;
>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(pos, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(pos, fs_info->data_io_size=
);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D round_up(pos + *write_=
bytes,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->sectorsize) - 1;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->data_io_size) - 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (nowait) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!btrfs=
_try_lock_ordered_range(inode, lockstart, lockend,
>>> @@ -1067,7 +1067,7 @@ int btrfs_write_check(struct kiocb *iocb,=20
>>> size_t count)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 oldsize =3D i_size_read(inode);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (pos > oldsize) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Expand =
hole size to cover write data, preventing empty=20
>>> gap */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t end_pos =3D round_up=
(pos + count, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 loff_t end_pos =3D round_up=
(pos + count, fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D bt=
rfs_cont_expand(BTRFS_I(inode), oldsize, end_pos);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> @@ -1090,7 +1090,7 @@ static void release_space(struct btrfs_inode=20
>>> *inode, struct extent_changeset *da
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const stru=
ct btrfs_fs_info *fs_info =3D inode->root->fs_info;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_dela=
lloc_release_space(inode, data_reserved,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 round_down(start, fs_info->sectorsize),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 round_down(start, fs_info->data_io_size),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 len, true);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0 }
>>> @@ -1107,7 +1107,7 @@ static ssize_t reserve_space(struct btrfs_inode=
=20
>>> *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool *only_release_metadata)
>>> =C2=A0=C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const struct btrfs_fs_info *fs_inf=
o =3D inode->root->fs_info;
>>> -=C2=A0=C2=A0=C2=A0 const unsigned int block_offset =3D (start & (fs_in=
fo->sectorsize=20
>>> - 1));
>>> +=C2=A0=C2=A0=C2=A0 const unsigned int block_offset =3D (start & (fs_in=
fo-=20
>>> >data_io_size - 1));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t reserve_bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> @@ -1132,7 +1132,7 @@ static ssize_t reserve_space(struct btrfs_inode=
=20
>>> *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *only_rele=
ase_metadata =3D true;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 reserve_bytes =3D round_up(*len + block_offset, fs_=
info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 reserve_bytes =3D round_up(*len + block_offset, fs_=
info-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(reserve_bytes =3D=3D 0);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_delalloc_reserve_met=
adata(inode, reserve_bytes,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 reserve_bytes, nowait);
>>> @@ -1192,7 +1192,7 @@ static int copy_one_range(struct btrfs_inode=20
>>> *inode, struct iov_iter *iter,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cached_state =
=3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t write_bytes =3D calc_write_=
bytes(inode, iter, start);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t copied;
>>> -=C2=A0=C2=A0=C2=A0 const u64 reserved_start =3D round_down(start, fs_i=
nfo->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 const u64 reserved_start =3D round_down(start, fs_i=
nfo-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 reserved_len;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio *folio =3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int extents_locked;
>>> @@ -1301,7 +1301,7 @@ static int copy_one_range(struct btrfs_inode=20
>>> *inode, struct iov_iter *iter,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Release=
 the reserved space beyond the last block. */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_block =3D round_up(sta=
rt + copied, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_block =3D round_up(sta=
rt + copied, fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shrink_res=
erved_space(inode, *data_reserved, reserved_start,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 reserved_len, last_block - reserved_start,
>>> @@ -1938,7 +1938,7 @@ static vm_fault_t btrfs_page_mkwrite(struct=20
>>> vm_fault *vmf)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (folio_contains(folio, (size - =
1) >> PAGE_SHIFT)) {
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reserved_space =3D round_up=
(size - page_start, fs_info-=20
>>> >sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reserved_space =3D round_up=
(size - page_start, fs_info-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (reserv=
ed_space < fsize) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 const u64 to_free =3D fsize - reserved_space;
>>> @@ -2182,8 +2182,8 @@ static int find_first_non_hole(struct=20
>>> btrfs_inode *inode, u64 *start, u64 *len)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 em =3D btrfs_get_extent(inode, NUL=
L,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_down(*start, fs_info->sectorsize),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_up(*len, fs_info->sectorsize));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_down(*start, fs_info->data_io_size)=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 round_up(*len, fs_info->data_io_size));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(em))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR=
_ERR(em);
>>> @@ -2396,7 +2396,7 @@ int btrfs_replace_file_extents(struct=20
>>> btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root *root =3D inode-=
>root;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D =
root->fs_info;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 min_size =3D btrfs_calc_=
insert_metadata_size(fs_info, 1);
>>> -=C2=A0=C2=A0=C2=A0 u64 ino_size =3D round_up(inode->vfs_inode.i_size, =
fs_info-=20
>>> >sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 u64 ino_size =3D round_up(inode->vfs_inode.i_size, =
fs_info-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans =
=3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_block_rsv rsv;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int rsv_count;
>>> @@ -2667,7 +2667,7 @@ static int btrfs_punch_hole(struct file *file,=20
>>> loff_t offset, loff_t len)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_o=
nly_mutex;
>>> -=C2=A0=C2=A0=C2=A0 ino_size =3D round_up(inode->i_size, fs_info->secto=
rsize);
>>> +=C2=A0=C2=A0=C2=A0 ino_size =3D round_up(inode->i_size, fs_info->data_=
io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D find_first_non_hole(BTRFS_=
I(inode), &offset, &len);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_o=
nly_mutex;
>>> @@ -2681,15 +2681,15 @@ static int btrfs_punch_hole(struct file=20
>>> *file, loff_t offset, loff_t len)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out_o=
nly_mutex;
>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_up(offset, fs_info->sectorsize)=
;
>>> -=C2=A0=C2=A0=C2=A0 lockend =3D round_down(offset + len, fs_info->secto=
rsize) - 1;
>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_up(offset, fs_info->data_io_siz=
e);
>>> +=C2=A0=C2=A0=C2=A0 lockend =3D round_down(offset + len, fs_info->data_=
io_size) - 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 same_block =3D (BTRFS_BYTES_TO_BLK=
S(fs_info, offset))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=3D (BT=
RFS_BYTES_TO_BLKS(fs_info, offset + len - 1));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Only do this if we are in =
the same block and we aren't=20
>>> doing the
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * entire block.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 if (same_block && len < fs_info->sectorsize) {
>>> +=C2=A0=C2=A0=C2=A0 if (same_block && len < fs_info->data_io_size) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (offset=
 < ino_size) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 truncated_block =3D true;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D btrfs_truncate_block(BTRFS_I(inode), offset +=20
>>> len - 1,
>>> @@ -2858,8 +2858,8 @@ static int btrfs_fallocate_update_isize(struct=20
>>> inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mode & FALLOC_FL_KEEP_SIZE || =
end <=3D i_size_read(inode))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> -=C2=A0=C2=A0=C2=A0 range_start =3D round_down(i_size_read(inode), root=
->fs_info-=20
>>> >sectorsize);
>>> -=C2=A0=C2=A0=C2=A0 range_end =3D round_up(end, root->fs_info->sectorsi=
ze);
>>> +=C2=A0=C2=A0=C2=A0 range_start =3D round_down(i_size_read(inode), root=
->fs_info-=20
>>> >data_io_size);
>>> +=C2=A0=C2=A0=C2=A0 range_end =3D round_up(end, root->fs_info->data_io_=
size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D btrfs_inode_set_file_exten=
t_range(BTRFS_I(inode),=20
>>> range_start,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 range_end - range_start);
>>> @@ -2889,7 +2889,7 @@ static int=20
>>> btrfs_zero_range_check_range_boundary(struct btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 u64 offset)
>>> =C2=A0=C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D inode->root->fs_info->sect=
orsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D inode->root->fs_info->data=
_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D round_down(offset, sect=
orsize);
>>> @@ -2916,7 +2916,7 @@ static int btrfs_zero_range(struct inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D =
BTRFS_I(inode)->root->fs_info;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_changeset *data_rese=
rved =3D NULL;
>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 alloc_hint =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 orig_start =3D offset;
>>> @@ -3065,7 +3065,7 @@ static int btrfs_zero_range(struct inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D bt=
rfs_prealloc_file_range(inode, mode, alloc_start,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 alloc_end - alloc_start,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_in=
fo->sectorsize,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_in=
fo->data_io_size,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 offset + len, &alloc_hint);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_unlo=
ck_extent(&BTRFS_I(inode)->io_tree, lockstart,=20
>>> lockend,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &cached_sta=
te);
>>> @@ -3105,7 +3105,7 @@ static long btrfs_fallocate(struct file *file,=20
>>> int mode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 data_space_reserved =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 qgroup_reserved =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em;
>>> -=C2=A0=C2=A0=C2=A0 int blocksize =3D BTRFS_I(inode)->root->fs_info->se=
ctorsize;
>>> +=C2=A0=C2=A0=C2=A0 int blocksize =3D BTRFS_I(inode)->root->fs_info->da=
ta_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_is_shutdown(inode_to_fs_=
info(inode)))
>>> @@ -3414,7 +3414,7 @@ bool btrfs_find_delalloc_in_range(struct=20
>>> btrfs_inode *inode, u64 start, u64 end,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state **c=
ached_state,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 *delalloc_start_ret=
, u64 *delalloc_end_ret)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 u64 cur_offset =3D round_down(start, inode->root->f=
s_info-=20
>>> >sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 u64 cur_offset =3D round_down(start, inode->root->f=
s_info-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 prev_delalloc_end =3D 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool search_io_tree =3D true;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool ret =3D false;
>>> @@ -3602,10 +3602,10 @@ static loff_t find_desired_extent(struct file=
=20
>>> *file, loff_t offset, int whence)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3D max_t(loff_t, 0, offset)=
;
>>> -=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(start, fs_info->sectorsize=
);
>>> -=C2=A0=C2=A0=C2=A0 lockend =3D round_up(i_size, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 lockstart =3D round_down(start, fs_info->data_io_si=
ze);
>>> +=C2=A0=C2=A0=C2=A0 lockend =3D round_up(i_size, fs_info->data_io_size)=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (lockend <=3D lockstart)
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D lockstart + fs_=
info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend =3D lockstart + fs_=
info->data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockend--;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
>>> diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
>>> index ab5ed7b4f639..cee4c772cfd9 100644
>>> --- a/fs/btrfs/fs.h
>>> +++ b/fs/btrfs/fs.h
>>> @@ -299,7 +299,7 @@ enum {
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_SAFE_SET=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 0ULL
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_SAFE_CLEAR=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0ULL
>>> -#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_FREE_SPAC=
E_TREE |=C2=A0=C2=A0=C2=A0 \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT_RO_FREE=
_SPACE_TREE_VALID | \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT_RO_VERI=
TY |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> @@ -335,11 +335,17 @@ enum {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_INCOMPAT_EXTEN=
T_TREE_V2 | \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_INCOMPAT_REMAP=
_TREE)
>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE |=C2=A0=C2=A0=
=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE)
>>> =C2=A0=C2=A0 #else
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_SUPP=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 \
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_INCOMPAT_SUPP_STABL=
E)
>>> +#define BTRFS_FEATURE_COMPAT_RO_SUPP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 (BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE)
>>> +
>>> =C2=A0=C2=A0 #endif
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> @@ -892,6 +898,7 @@ struct btrfs_fs_info {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csum_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csums_per_leaf;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 csum_type;
>>> +=C2=A0=C2=A0=C2=A0 u32 data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Maximum size of an extent.=
 BTRFS_MAX_EXTENT_SIZE on regular
>>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> index b696dd329fd7..de0364ce950b 100644
>>> --- a/fs/btrfs/inode.c
>>> +++ b/fs/btrfs/inode.c
>>> @@ -190,7 +190,7 @@ static int data_reloc_print_warning_inode(u64=20
>>> inum, u64 offset, u64 num_bytes,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_warn=
(fs_info,
>>> =C2=A0=C2=A0 "checksum error at logical %llu mirror %u root %llu inode =
%llu=20
>>> offset %llu length %u links %u (path: %s)",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warn->logical, warn->mirror_num, root, in=
um, offset,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->sectorsize, nlink,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 fs_info->data_io_size, nlink,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (char *)(unsigned long)ipath->fspath->val=
[i]);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> @@ -1397,7 +1397,7 @@ static noinline int cow_file_range(struct=20
>>> btrfs_inode *inode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_is_data_reloc_root(root)=
)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 min_alloc_=
size =3D num_bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 min_alloc_size =3D fs_info-=
>sectorsize;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 min_alloc_size =3D fs_info-=
>data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (num_bytes > 0) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D co=
w_one_range(inode, locked_folio, &ins, &cached,=20
>>> start,
>>> @@ -2783,7 +2783,7 @@ int btrfs_set_extent_delalloc(struct=20
>>> btrfs_inode *inode, u64 start, u64 end,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int extra_bits=
,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state **c=
ached_state)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->secto=
rsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->data_=
io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Basic alignment check. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(IS_ALIGNED(start, blocksize=
), "start=3D%llu blocksize=3D%u",
>>> @@ -2820,7 +2820,7 @@ int btrfs_set_extent_delalloc(struct=20
>>> btrfs_inode *inode, u64 start, u64 end,
>>> =C2=A0=C2=A0 int btrfs_reset_extent_delalloc(struct btrfs_inode *inode,=
 u64=20
>>> start, u64 end,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int extra_bits, struct ext=
ent_state=20
>>> **cached_state)
>>> =C2=A0=C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->secto=
rsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D inode->root->fs_info->data_=
io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The @extra_bits can only be EXT=
ENT_NORESERVE for now. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ASSERT(!(extra_bits & ~EXTENT_NORE=
SERVE), "extra_bits=3D0x%x",=20
>>> extra_bits);
>>> @@ -2874,7 +2874,7 @@ static int insert_reserved_file_extent(struct=20
>>> btrfs_trans_handle *trans,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 num_bytes =3D btrfs_stack_file=
_extent_num_bytes(stack_fi);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 ram_bytes =3D btrfs_stack_file=
_extent_ram_bytes(stack_fi);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_drop_extents_args dro=
p_args =3D { 0 };
>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D root->fs_info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D root->fs_info->data_io_siz=
e;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 path =3D btrfs_alloc_path();
>>> @@ -4040,7 +4040,7 @@ static int btrfs_read_locked_inode(struct=20
>>> btrfs_inode *inode, struct btrfs_path
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_inode_set_file_extent_range(=
inode, 0,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 round_up(i_size_read(vfs_inode), fs_info->sectorsize));
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 round_up(i_size_read(vfs_inode), fs_info->data_io_size));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!maybe_acls)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cache_no_a=
cl(vfs_inode);
>>> @@ -4879,7 +4879,7 @@ int btrfs_truncate_block(struct btrfs_inode=20
>>> *inode, u64 offset, u64 start, u64 e
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cached_state =
=3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_changeset *data_rese=
rved =3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool only_release_metadata =3D fal=
se;
>>> -=C2=A0=C2=A0=C2=A0 u32 blocksize =3D fs_info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0 u32 blocksize =3D fs_info->data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pgoff_t index =3D (offset >> PAGE_=
SHIFT);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio *folio;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 gfp_t mask =3D btrfs_alloc_write_m=
ask(mapping);
>>> @@ -5117,8 +5117,8 @@ int btrfs_cont_expand(struct btrfs_inode=20
>>> *inode, loff_t oldsize, loff_t size)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_io_tree *io_tree =3D=
 &inode->io_tree;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_map *em =3D NULL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct extent_state *cached_state =
=3D NULL;
>>> -=C2=A0=C2=A0=C2=A0 u64 hole_start =3D ALIGN(oldsize, fs_info->sectorsi=
ze);
>>> -=C2=A0=C2=A0=C2=A0 u64 block_end =3D ALIGN(size, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 u64 hole_start =3D ALIGN(oldsize, fs_info->data_io_=
size);
>>> +=C2=A0=C2=A0=C2=A0 u64 block_end =3D ALIGN(size, fs_info->data_io_size=
);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 last_byte;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 cur_offset;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 hole_size;
>>> @@ -5147,7 +5147,7 @@ int btrfs_cont_expand(struct btrfs_inode=20
>>> *inode, loff_t oldsize, loff_t size)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 break;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_byte =
=3D min(btrfs_extent_map_end(em), block_end);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_byte =3D ALIGN(last_by=
te, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last_byte =3D ALIGN(last_by=
te, fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hole_size =
=3D last_byte - cur_offset;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!(em->=
flags & EXTENT_FLAG_PREALLOC)) {
>>> @@ -5253,7 +5253,7 @@ static int btrfs_setsize(struct inode *inode,=20
>>> struct iattr *attr)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btrfs_=
is_zoned(fs_info)) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D btrfs_wait_ordered_range(BTRFS_I(inode),
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN(newsize, fs_info->secto=
rsize),
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ALIGN(newsize, fs_info->data_=
io_size),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (u64)-1);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> @@ -7323,7 +7323,7 @@ noinline int can_nocow_extent(struct=20
>>> btrfs_inode *inode, u64 offset, u64 *len,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 range_=
end;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 range_end =
=3D round_up(offset +=20
>>> nocow_args.file_extent.num_bytes,
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root->fs_info->sectorsi=
ze) - 1;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 root->fs_info->data_io_=
size) - 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D bt=
rfs_test_range_bit_exists(io_tree, offset, range_end,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 EXTENT_DELALLOC);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> @@ -7653,8 +7653,8 @@ static int btrfs_truncate(struct btrfs_inode=20
>>> *inode, bool skip_writeback)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int ret;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_trans_handle *trans;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u64 min_size =3D btrfs_calc_=
metadata_size(fs_info, 1);
>>> -=C2=A0=C2=A0=C2=A0 const u64 lock_start =3D round_down(inode->vfs_inod=
e.i_size,=20
>>> fs_info->sectorsize);
>>> -=C2=A0=C2=A0=C2=A0 const u64 i_size_up =3D round_up(inode->vfs_inode.i=
_size, fs_info-=20
>>> >sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 const u64 lock_start =3D round_down(inode->vfs_inod=
e.i_size,=20
>>> fs_info->data_io_size);
>>> +=C2=A0=C2=A0=C2=A0 const u64 i_size_up =3D round_up(inode->vfs_inode.i=
_size, fs_info-=20
>>> >data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Our inode is locked and the i_s=
ize can't be changed=20
>>> concurrently. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_assert_inode_locked(inode);
>>> @@ -8038,7 +8038,7 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 delalloc_bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 inode_bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D d_inode(pa=
th->dentry);
>>> -=C2=A0=C2=A0=C2=A0 u32 blocksize =3D btrfs_sb(inode->i_sb)->sectorsize=
;
>>> +=C2=A0=C2=A0=C2=A0 u32 blocksize =3D btrfs_sb(inode->i_sb)->data_io_si=
ze;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 bi_flags =3D BTRFS_I(inode)->f=
lags;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 bi_ro_flags =3D BTRFS_I(inode)=
->ro_flags;
>>> @@ -9124,8 +9124,8 @@ static int __btrfs_prealloc_file_range(struct=20
>>> inode *inode, int mode,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * to truncate disk_i_size to the start of the gap,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * making the persisted size smaller than i_size.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ran=
ge_start =3D round_down(inode->i_size, fs_info-=20
>>> >sectorsize);
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ran=
ge_end =3D round_up(i_size, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ran=
ge_start =3D round_down(inode->i_size, fs_info-=20
>>> >data_io_size);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ran=
ge_end =3D round_up(i_size, fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 ret =3D btrfs_inode_set_file_extent_range(BTRFS_I(inode),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 range_start=
, range_end - range_start);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (ret) {
>>> @@ -9272,10 +9272,10 @@ int=20
>>> btrfs_encoded_io_compression_from_extent(struct btrfs_fs_info *fs_info,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Th=
e LZO format depends on the sector size. 64K is the=20
>>> maximum
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * se=
ctor size that we support.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->sectorsize < S=
Z_4K || fs_info->sectorsize >=20
>>> SZ_64K)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->data_io_size <=
 SZ_4K || fs_info->data_io_size >=20
>>> SZ_64K)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return -EINVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return BTR=
FS_ENCODED_IO_COMPRESSION_LZO_4K +
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (fs_info->sectorsize_bits - 12);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 (ilog2(fs_info->data_io_size) - 12);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BTRFS_COMPRESS_ZSTD:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return BTR=
FS_ENCODED_IO_COMPRESSION_ZSTD;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>> @@ -9563,7 +9563,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb,=20
>>> struct iov_iter *iter,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_inod=
e_unlock(inode, BTRFS_ILOCK_SHARED);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> -=C2=A0=C2=A0=C2=A0 start =3D ALIGN_DOWN(iocb->ki_pos, fs_info->sectors=
ize);
>>> +=C2=A0=C2=A0=C2=A0 start =3D ALIGN_DOWN(iocb->ki_pos, fs_info->data_io=
_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We don't know how long the=
 extent containing iocb->ki_pos=20
>>> is, but if
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it's compressed we know th=
at it won't be longer than this.
>>> @@ -9676,7 +9676,7 @@ ssize_t btrfs_encoded_read(struct kiocb *iocb,=20
>>> struct iov_iter *iter,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 count =3D =
start + *disk_io_size - iocb->ki_pos;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 encoded->l=
en =3D count;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 encoded->u=
nencoded_len =3D count;
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *disk_io_size =3D ALIGN(*di=
sk_io_size, fs_info->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *disk_io_size =3D ALIGN(*di=
sk_io_size, fs_info->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_free_extent_map(em);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 em =3D NULL;
>>> @@ -9720,7 +9720,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb=20
>>> *iocb, struct iov_iter *from,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int compression;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t orig_count;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 min_folio_size =3D btrfs=
_min_folio_size(fs_info);
>>> -=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D fs_info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 blocksize =3D fs_info->data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 start, end;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u64 num_bytes, ram_bytes, disk_num=
_bytes;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_key ins;
>>> @@ -9743,7 +9743,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb=20
>>> *iocb, struct iov_iter *from,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The sec=
tor size must match for LZO. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (encode=
d->compression -
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 BTRFS_ENCODED_IO_COMPRESSION_LZO_4K + 12 !=3D
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_=
info->sectorsize_bits)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ilo=
g2(blocksize))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 return -EINVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 compressio=
n =3D BTRFS_COMPRESS_LZO;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 break;
>>> @@ -9785,7 +9785,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb=20
>>> *iocb, struct iov_iter *from,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* The extent must start on a sect=
or boundary. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 start =3D iocb->ki_pos;
>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(start, fs_info->sectorsize))
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(start, fs_info->data_io_size))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EI=
NVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> @@ -9794,15 +9794,15 @@ ssize_t btrfs_do_encoded_write(struct kiocb=20
>>> *iocb, struct iov_iter *from,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * up the extent size and set=
 i_size to the unaligned end.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (start + encoded->len < inode->=
vfs_inode.i_size &&
>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !IS_ALIGNED(start + encoded=
->len, fs_info->sectorsize))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !IS_ALIGNED(start + encoded=
->len, fs_info->data_io_size))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EI=
NVAL;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Finally, the offset in the unen=
coded data must be sector-=20
>>> aligned. */
>>> -=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(encoded->unencoded_offset, fs_info-=
>sectorsize))
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ALIGNED(encoded->unencoded_offset, fs_info-=
>data_io_size))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EI=
NVAL;
>>> -=C2=A0=C2=A0=C2=A0 num_bytes =3D ALIGN(encoded->len, fs_info->sectorsi=
ze);
>>> -=C2=A0=C2=A0=C2=A0 ram_bytes =3D ALIGN(encoded->unencoded_len, fs_info=
->sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 num_bytes =3D ALIGN(encoded->len, fs_info->data_io_=
size);
>>> +=C2=A0=C2=A0=C2=A0 ram_bytes =3D ALIGN(encoded->unencoded_len, fs_info=
->data_io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 end =3D start + num_bytes - 1;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> @@ -9810,7 +9810,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb=20
>>> *iocb, struct iov_iter *from,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * sector-aligned. For conven=
ience, we extend it with zeroes=20
>>> if it
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * isn't.
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
>>> -=C2=A0=C2=A0=C2=A0 disk_num_bytes =3D ALIGN(orig_count, fs_info->secto=
rsize);
>>> +=C2=A0=C2=A0=C2=A0 disk_num_bytes =3D ALIGN(orig_count, fs_info->data_=
io_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cb =3D btrfs_alloc_compressed_writ=
e(inode, start, num_bytes);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 for (int i =3D 0; i * min_folio_si=
ze < disk_num_bytes; i++) {
>>> @@ -10222,7 +10222,7 @@ static int btrfs_swap_activate(struct=20
>>> swap_info_struct *sis, struct file *file,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_inc(&root->nr_swapfiles);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_unlock(&root->root_item_lock)=
;
>>> -=C2=A0=C2=A0=C2=A0 isize =3D ALIGN_DOWN(inode->i_size, fs_info->sector=
size);
>>> +=C2=A0=C2=A0=C2=A0 isize =3D ALIGN_DOWN(inode->i_size, fs_info->data_i=
o_size);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_lock_extent(io_tree, 0, isiz=
e - 1, &cached_state);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 while (prev_extent_end < isize) {
>>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>>> index 1531adb117d1..0235530fd0f8 100644
>>> --- a/fs/btrfs/lzo.c
>>> +++ b/fs/btrfs/lzo.c
>>> @@ -414,7 +414,7 @@ int lzo_decompress_bio(struct list_head *ws,=20
>>> struct compressed_bio *cb)
>>> =C2=A0=C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct workspace *workspace =3D li=
st_entry(ws, struct workspace,=20
>>> list);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D =
cb->bbio.inode->root->fs_info;
>>> -=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->sectorsize;
>>> +=C2=A0=C2=A0=C2=A0 const u32 sectorsize =3D fs_info->data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const u32 compressed_len =3D bio_g=
et_size(&cb->bbio.bio);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct folio_iter fi;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 char *kaddr;
>>> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
>>> index 0d14570c8bc2..8ca7b7e304e3 100644
>>> --- a/fs/btrfs/sysfs.c
>>> +++ b/fs/btrfs/sysfs.c
>>> @@ -301,6 +301,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2,=20
>>> EXTENT_TREE_V2);
>>> =C2=A0=C2=A0 BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_STRIPE_TRE=
E);
>>> =C2=A0=C2=A0 /* Remove once support for remap tree is feature complete.=
 */
>>> =C2=A0=C2=A0 BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
>>> +BTRFS_FEAT_ATTR_COMPAT_RO(data_io_size, DATA_IO_SIZE);
>>> =C2=A0=C2=A0 #endif
>>> =C2=A0=C2=A0 #ifdef CONFIG_FS_VERITY
>>> =C2=A0=C2=A0 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
>>> @@ -334,6 +335,7 @@ static struct attribute=20
>>> *btrfs_supported_feature_attrs[] =3D {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(extent_tree_v2=
),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(raid_stripe_tr=
ee),
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(remap_tree),
>>> +=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(data_io_size),
>>> =C2=A0=C2=A0 #endif
>>> =C2=A0=C2=A0 #ifdef CONFIG_FS_VERITY
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_FEAT_ATTR_PTR(verity),
>>> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.=
c
>>> index 6287d940323d..e3e7bbee7cd7 100644
>>> --- a/fs/btrfs/tests/btrfs-tests.c
>>> +++ b/fs/btrfs/tests/btrfs-tests.c
>>> @@ -140,6 +140,7 @@ struct btrfs_fs_info=20
>>> *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->nodesize =3D nodesize;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize =3D sectorsize=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->sectorsize_bits =3D ilog2=
(sectorsize);
>>> +=C2=A0=C2=A0=C2=A0 fs_info->data_io_size =3D sectorsize;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* CRC32C csum size. */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->csum_size =3D 4;
>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>> index 0a13baf3d8d1..858a37811586 100644
>>> --- a/include/uapi/linux/btrfs.h
>>> +++ b/include/uapi/linux/btrfs.h
>>> @@ -314,6 +314,13 @@ struct btrfs_ioctl_fs_info_args {
>>> =C2=A0=C2=A0=C2=A0 */
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE=C2=A0=C2=
=A0=C2=A0 (1ULL << 3)
>>> +/*
>>> + * Force all IOs (including buffered, direct, compressed) to be aligne=
d
>>> + * to btrfs_super_block::data_io_size other than sectorsize.
>>> + * Meanwhile still data checksum to be calculated based on sectorsize.
>>> + */
>>> +#define BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 (1ULL << 4)
>>> +
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF=C2=A0=C2=A0=
=C2=A0 (1ULL << 0)
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL=C2=A0=C2=A0=
=C2=A0 (1ULL << 1)
>>> =C2=A0=C2=A0 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS=C2=A0=C2=A0=C2=
=A0 (1ULL << 2)
>>> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/=20
>>> btrfs_tree.h
>>> index cc3b9f7dccaf..3b979ba5a3fc 100644
>>> --- a/include/uapi/linux/btrfs_tree.h
>>> +++ b/include/uapi/linux/btrfs_tree.h
>>> @@ -724,9 +724,10 @@ struct btrfs_super_block {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 remap_root;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __le64 remap_root_generation;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 remap_root_level;
>>> +=C2=A0=C2=A0=C2=A0 __u32 data_io_size;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Future expansion */
>>> -=C2=A0=C2=A0=C2=A0 __u8 reserved[199];
>>> +=C2=A0=C2=A0=C2=A0 __u8 reserved[195];
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __u8 sys_chunk_array[BTRFS_SYSTEM_=
CHUNK_ARRAY_SIZE];
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_root_backup super_roo=
ts[BTRFS_NUM_BACKUP_ROOTS];
>
