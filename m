Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0933803EB
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 07:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774424052; cv=none; b=B2zKIH3MBQ4+FfNqWHOxvfZiD0AleEAxSHZ8a341ZkMIgewqIBifdmhD/X/s05/EzDzgIbGu1+foRv9j3xQjnD5JvE4k8OPlYsvf5ZIKB6KWKOfAebuRW2gP4QsS20VP843r4npDUpPhG00Bu7jUTQE2YmROLLxcj46WsiG1GZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774424052; c=relaxed/simple;
	bh=hev55xm/6pXU8LtX+MC4TVE/+c+LJ+7QAoBkfEmXJgw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qyxZWy9yT5PttUuvQC11zAYlV1ud4q1aW001r+H9MAZwr0RBXEJKRUwolCPFOHpaxOMtzo0FN91aIRyjFo/oFFFSziu0+ZVs9wuMNLA5NZRQp2uh5HifcwJMsMcif3X1H4BTajjRzkHGG5RdYxPC41D1e7r6S/BebVbXJv47Sdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=VLqPrHlQ; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="VLqPrHlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774424044; x=1775028844; i=quwenruo.btrfs@gmx.com;
	bh=HKeSwSrTb3t9EKuV+NQq7ZUXFDrGwRF/IH7Q+OGSGlY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VLqPrHlQGk83D39AS6BbY7Ag9EUZ1XFZRF1FJQReOOErhcWV2ROcDGGQKel63ODd
	 xlo7udg5hM2o2s6/uNtS/NRAknCsULjQfKXNOn9g5n73plJGsqoyZv2BkThZrSe0t
	 KNbfHUcCx4NJ6FrOcTzLADfh8H5D/qfwqLiEo1Be1n7GZz2yHYHWIaWngF39/LWuP
	 vm31Pu9RvrF7nDtmH3/t/jIgzM0VwmxUFBMKUQRcZTxlHyNVgCvgol6ymOU25WYej
	 4dIvHBACtpmyXGWTSSN1dTeSeJWqkOi/58GqE3jQbqIl/BkqD3Z8WfVHUg5N2Hofm
	 ck2ANwY9I/PvjMbG1g==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mwwdl-1vKDPU1e9L-00rg7f; Wed, 25
 Mar 2026 08:34:03 +0100
Message-ID: <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
Date: Wed, 25 Mar 2026 18:04:00 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
Content-Language: en-US
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yMNnUpzyOiujyNka+5va6FaHBcPFb86cDxW7r3wcgYkGGawTzI2
 zRvFSN8tqGx5YGhbI3L+mgIxYPIhusX69bXXAAc63phkpMC9QepEoiFUQTeMCQw81+93HPs
 FKHbEkmWTY8Z52BPSF9N6JlIPoAi6Uqutd3V0tKe3tdish0LluGIduLq2G/4PHHqpJzxNiM
 dRGw1RiUQcGtMs6j/2RIw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Vi1m7PEk56M=;z5jFG2ttwF5/RhfM6L79LZJHc1x
 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



=E5=9C=A8 2026/3/21 08:48, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/3/20 23:20, Mark Harmstone =E5=86=99=E9=81=93:
>> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used to
>> query the on-disk csums for a file.
>>
>> This is done by userspace passing a struct btrfs_ioctl_get_csums_args t=
o
>> the kernel, which details the offset and length we're interested in, an=
d
>> a buffer for the kernel to write its results into. The kernel writes a
>> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
>> csums if available.
>>
>> If the extent is an uncompressed, non-nodatasum extent, the kernel sets
>> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
>> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
>> type to BTRFS_GET_CSUMS_SPARSE - this is so userspace knows it can use
>> the precomputed hash of the zero sector. Otherwise, it sets the type to
>> BTRFS_GET_CSUMS_NO_CSUMS.
>=20
> I'm not sure if it's a good idea to put hole and preallocated range into=
=20
> the same BTRFS_GET_CSUMS_SPARSE.
>=20
> Although both means there is no csum, hole case means there is really no=
=20
> data extent, thus we should not create any extent instead of writing zer=
o.
>=20
> For preallocated, indicating it has no CSUM can allow mkfs to=20
> distinguish hole and preallocated, thus change to zero writes to=20
> prealloc, which is faster and make the resulted fs more aligned to the=
=20
> source dir.
>=20
>=20
> And for EOF checks, I think we don't need to bother that much, aka, just=
=20
> let it return the regular results.
>=20
> My assumption is, the mkfs shouldn't pass a range completely beyond the=
=20
> round_up(i_size), as non-reflink rootdir population would always read=20
> out the content of the inode from the host fs.
> Thus we won't really read beyond the inode size.

After more investigation, I think we can put the=20
hole/preallocation/compression detection into the user space.

The hole detection is already pending for merge, mostly through=20
SEEK_DATA/SEEK_HOLE flags of lseek():

  https://github.com/kdave/btrfs-progs/pull/1097

I'm planning to implement preallocation detection through fiemap, which=20
also allows us to detect compressed range and skip them for your case.

With all those features implemented in progs, we can further simplify=20
the get csum ioctl, to something more aligned to=20
btrfs_lookup_csums_bitmap().

We do not need to bother why there is no checksum for some ranges, that=20
will be handled by progs first, we only need to return all the checksums=
=20
found for the specified range.

And as an extra safenet, use some bitmap inthe ioctl structure to=20
indicate which ranges have checksum and which doesn't.

This will definitely simplify the ioctl as we only need to do csum tree=20
lookup, no need to bother anything in the subvolume tree.

Thanks,
Qu

>=20
>>
>> We do store the csums of compressed extents, but we deliberately don't
>> return them here: they're hashed over the compressed data, not the
>> uncompressed data that's returned to userspace.
>=20
> I agree with the skip of compressed extents, but I'd prefer to have a=20
> special flag to indicate that, other than NO_CSUMS.
>=20
> Or mkfs is unable to distinguish hole and compressed extents.
>=20
> [...]
>> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
>> +#define BTRFS_GET_CSUMS_HAS_CSUMS=C2=A0=C2=A0=C2=A0 0
>> +#define BTRFS_GET_CSUMS_SPARSE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 1
>> +#define BTRFS_GET_CSUMS_NO_CSUMS=C2=A0=C2=A0=C2=A0 2
>> +
>> +struct btrfs_ioctl_get_csums_entry {
>> +=C2=A0=C2=A0=C2=A0 __u64 offset;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* file offset of this range */
>> +=C2=A0=C2=A0=C2=A0 __u64 length;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* length in bytes */
>> +=C2=A0=C2=A0=C2=A0 __u32 type;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /* BTRFS_GET_CSUMS_* type */
>> +=C2=A0=C2=A0=C2=A0 __u32 reserved;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* padding, must be 0 */
>> +};
>> +
>> +struct btrfs_ioctl_get_csums_args {
>> +=C2=A0=C2=A0=C2=A0 __u64 offset;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* in/out: file offset */
>> +=C2=A0=C2=A0=C2=A0 __u64 length;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* in/out: range length */
>> +=C2=A0=C2=A0=C2=A0 __u64 buf_size;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* in/out: buffer capacity / bytes written */
>> +=C2=A0=C2=A0=C2=A0 __u8 buf[];=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /* out: entries + csum data */
>> +};
>=20
>  From the progs usage, it is always a single btrfs_ioctl_get_csums_entry=
=20
> at the beginning of buf[], then real buffer for csum, can we just=20
> combine both structures into one?
>=20
> Furthermore, since we only query one extent at one time, the offset/=20
> length are more or less duplicated between args and entry structure.
>=20
> We can just save the length into the args without the need for entry=20
> members (except the type).
>=20
> Thanks,
> Qu
>=20
>> +
>> =C2=A0 /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_* fla=
gs. */
>> =C2=A0 #define BTRFS_SHUTDOWN_FLAGS_DEFAULT=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x0
>> =C2=A0 #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>> @@ -1226,6 +1245,8 @@ enum btrfs_err_code {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btr=
fs_ioctl_encoded_io_args)
>> =C2=A0 #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65, \
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioc=
tl_subvol_wait)
>> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_get_csums_args)
>> =C2=A0 /* Shutdown ioctl should follow XFS's interfaces, thus not using=
=20
>> btrfs magic. */
>> =C2=A0 #define BTRFS_IOC_SHUTDOWN=C2=A0=C2=A0=C2=A0 _IOR('X', 125, __u3=
2)
>=20
>=20

