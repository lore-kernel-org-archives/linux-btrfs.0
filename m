Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA30332EC1
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774472664; cv=none; b=AK4qlFGiU6yqBDsZUP0iqk/w10o4U7zLYZ5UGR1DfiPokqCplK8FqWfAepCm+DwmveFW2wnqes0aC7hieITddS8AeB1X5bMYIOb7Z5MdR2H7cXo4JO8ujljHOC67Az8hbKVH3Rj6d9goDotAYRlEbQqgnuwoPTwAEhKm0vQVb8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774472664; c=relaxed/simple;
	bh=fZhOoAcgWMRNwXYKRqf2neXI4CKOIozhlnTPCjxHjyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XTI9XM3dhzY5uJabsV2ORis590pwxYOmvP3xzlmBTo9LKHzwUkR1COW+3mM74f5w7hzXa9FfHYviDtK5m7hve5vgqkZK5IkFE51HJ9RDtpe/164+MmohreQGPE/Y33eYva5QkvIZ44oaXJIJ4Y3Xr9sNJednw4OIYmeiTcBv/Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=o/6SqKp7; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="o/6SqKp7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774472660; x=1775077460; i=quwenruo.btrfs@gmx.com;
	bh=fZhOoAcgWMRNwXYKRqf2neXI4CKOIozhlnTPCjxHjyc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=o/6SqKp7XA4GRYKHASwPD8db3GiNZ+WP12SMLEykSSl3uLIHOEAER8LTWLF4/bhW
	 zVJs4IRGaPSIPPdMgIuYBZazBBoEAOjlY6OxSuEnxiL7m0BMhafjKLX7/j7xNSuG0
	 X1yLPGAWebLFAFxbGvcU9JC+WNzrcate1LEPTUScyis6xF8t7HJ6c0bGadz5w9w5k
	 EGkaCwMZjQNN5bZYqehuABxaBDYF111qyRQjbDxyizdgZP3WXobgPNqtOpsv/QKbs
	 BPviqeDNKoTj/6o3ckyRfRm6e3xmsCIMIPF+VTqYS/W1/P9mxOsExapTINIb6brY4
	 ATjzvJ8BTtDNPIgskg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M7b6b-1wBHcl2Nqv-00HCyk; Wed, 25
 Mar 2026 22:04:19 +0100
Message-ID: <a1675480-628b-46ba-95c7-f5ee29d6bf14@gmx.com>
Date: Thu, 26 Mar 2026 07:34:15 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: add BTRFS_IOC_GET_CSUMS ioctl
To: Mark Harmstone <mark@harmstone.com>, linux-btrfs@vger.kernel.org
References: <20260320125058.90053-1-mark@harmstone.com>
 <07cf5ebc-ac52-4fd9-82c5-404c0f4d6056@gmx.com>
 <3ad267b6-cc59-495f-b385-9b4b4686a473@gmx.com>
 <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
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
In-Reply-To: <39496ce5-74c2-4300-ba39-032edace4cfe@harmstone.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gqp0X2TrpihwTfK2+LoNlwWehwA317yL6Js8LWziJjkOKP1xh/Z
 0d1blW49JfLOYyKIbukNFc9/d2gSMiaKuSdrcEbVqy6y5ZAbb8GnLI2ci5q79zGKBVXNVi7
 TNO37tD9ByVSTlQy1OyCHZMoM8pYUz2C9l5gzzijGoiUSnWqoroS3sppRKHNeWXx2xfHOWT
 SsYcX/9WxgF7udZAX8lFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3t/SskEMzEs=;vO78bdmrVf3hnPh6RF7Y6Y6DZab
 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



=E5=9C=A8 2026/3/26 01:13, Mark Harmstone =E5=86=99=E9=81=93:
> On 25/03/2026 7.34 am, Qu Wenruo wrote:
>>
>>
>> =E5=9C=A8 2026/3/21 08:48, Qu Wenruo =E5=86=99=E9=81=93:
>>>
>>>
>>> =E5=9C=A8 2026/3/20 23:20, Mark Harmstone =E5=86=99=E9=81=93:
>>>> Add a new unprivileged BTRFS_IOC_GET_CSUMS ioctl, which can be used t=
o
>>>> query the on-disk csums for a file.
>>>>
>>>> This is done by userspace passing a struct=20
>>>> btrfs_ioctl_get_csums_args to
>>>> the kernel, which details the offset and length we're interested in,=
=20
>>>> and
>>>> a buffer for the kernel to write its results into. The kernel writes =
a
>>>> struct btrfs_ioctl_get_csums_entry into the buffer, followed by the
>>>> csums if available.
>>>>
>>>> If the extent is an uncompressed, non-nodatasum extent, the kernel se=
ts
>>>> the entry type to BTRFS_GET_CSUMS_HAS_CSUMS and follows it with the
>>>> csums. If it is sparse, preallocated, or beyond the EOF, it sets the
>>>> type to BTRFS_GET_CSUMS_SPARSE - this is so userspace knows it can us=
e
>>>> the precomputed hash of the zero sector. Otherwise, it sets the type =
to
>>>> BTRFS_GET_CSUMS_NO_CSUMS.
>>>
>>> I'm not sure if it's a good idea to put hole and preallocated range=20
>>> into the same BTRFS_GET_CSUMS_SPARSE.
>>>
>>> Although both means there is no csum, hole case means there is really=
=20
>>> no data extent, thus we should not create any extent instead of=20
>>> writing zero.
>=20
> Thanks Qu.
>=20
> "SPARSE" is probably a bad name for it. It probably should be "ZERO" or=
=20
> somesuch. The point is to tell userspace not to waste time calculating=
=20
> csums, but use the precomputed values because the data would be zero=20
> (for whatever reason).
>=20
>>> For preallocated, indicating it has no CSUM can allow mkfs to=20
>>> distinguish hole and preallocated, thus change to zero writes to=20
>>> prealloc, which is faster and make the resulted fs more aligned to=20
>>> the source dir.
>>>
>>>
>>> And for EOF checks, I think we don't need to bother that much, aka,=20
>>> just let it return the regular results.
>>>
>>> My assumption is, the mkfs shouldn't pass a range completely beyond=20
>>> the round_up(i_size), as non-reflink rootdir population would always=
=20
>>> read out the content of the inode from the host fs.
>>> Thus we won't really read beyond the inode size.
>>
>> After more investigation, I think we can put the hole/preallocation/=20
>> compression detection into the user space.
>>
>> The hole detection is already pending for merge, mostly through=20
>> SEEK_DATA/SEEK_HOLE flags of lseek():
>>
>> =C2=A0=C2=A0https://github.com/kdave/btrfs-progs/pull/1097
>>
>> I'm planning to implement preallocation detection through fiemap,=20
>> which also allows us to detect compressed range and skip them for your=
=20
>> case.
>>
>> With all those features implemented in progs, we can further simplify=
=20
>> the get csum ioctl, to something more aligned to=20
>> btrfs_lookup_csums_bitmap().
>>
>> We do not need to bother why there is no checksum for some ranges,=20
>> that will be handled by progs first, we only need to return all the=20
>> checksums found for the specified range.
>>
>> And as an extra safenet, use some bitmap inthe ioctl structure to=20
>> indicate which ranges have checksum and which doesn't.
>>
>> This will definitely simplify the ioctl as we only need to do csum=20
>> tree lookup, no need to bother anything in the subvolume tree.
>=20
> Unfortunately this won't work. You have to explicitly filter out=20
> compressed extents, and identifying these requires checking the FS tree.

That's done by progs through fiemap. There will be a flag ENCODED for=20
compressed file extents.

> The reason is that they may be "bookended", and you would leak=20
> information about other files if you returned the whole of the csums for=
=20
> the compressed extent. This is the reason why encoded read needs root.

Nope, for the fiemap call, we will never reach any bookend extents.

Thanks,
Qu

>=20
>> Thanks,
>> Qu
>>
>>>
>>>>
>>>> We do store the csums of compressed extents, but we deliberately don'=
t
>>>> return them here: they're hashed over the compressed data, not the
>>>> uncompressed data that's returned to userspace.
>>>
>>> I agree with the skip of compressed extents, but I'd prefer to have a=
=20
>>> special flag to indicate that, other than NO_CSUMS.
>>>
>>> Or mkfs is unable to distinguish hole and compressed extents.
>=20
> Compressed extents result in NO_CSUMS, a hole results in SPARSE.
>=20
>>> [...]
>>>> +/* Types for struct btrfs_ioctl_get_csums_entry::type */
>>>> +#define BTRFS_GET_CSUMS_HAS_CSUMS=C2=A0=C2=A0=C2=A0 0
>>>> +#define BTRFS_GET_CSUMS_SPARSE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 1
>>>> +#define BTRFS_GET_CSUMS_NO_CSUMS=C2=A0=C2=A0=C2=A0 2
>>>> +
>>>> +struct btrfs_ioctl_get_csums_entry {
>>>> +=C2=A0=C2=A0=C2=A0 __u64 offset;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* file offset of this range */
>>>> +=C2=A0=C2=A0=C2=A0 __u64 length;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* length in bytes */
>>>> +=C2=A0=C2=A0=C2=A0 __u32 type;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* BTRFS_GET_CSUMS_* type */
>>>> +=C2=A0=C2=A0=C2=A0 __u32 reserved;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* padding, must be 0 */
>>>> +};
>>>> +
>>>> +struct btrfs_ioctl_get_csums_args {
>>>> +=C2=A0=C2=A0=C2=A0 __u64 offset;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* in/out: file offset */
>>>> +=C2=A0=C2=A0=C2=A0 __u64 length;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* in/out: range length */
>>>> +=C2=A0=C2=A0=C2=A0 __u64 buf_size;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 /* in/out: buffer capacity / bytes=20
>>>> written */
>>>> +=C2=A0=C2=A0=C2=A0 __u8 buf[];=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 /* out: entries + csum data */
>>>> +};
>>>
>>> =C2=A0From the progs usage, it is always a single=20
>>> btrfs_ioctl_get_csums_entry at the beginning of buf[], then real=20
>>> buffer for csum, can we just combine both structures into one?
>>>
>>> Furthermore, since we only query one extent at one time, the offset/=
=20
>>> length are more or less duplicated between args and entry structure.
>>>
>>> We can just save the length into the args without the need for entry=
=20
>>> members (except the type).
>>>
>>> Thanks,
>>> Qu
>>>
>>>> +
>>>> =C2=A0 /* Flags for IOC_SHUTDOWN, must match XFS_FSOP_GOING_FLAGS_*=
=20
>>>> flags. */
>>>> =C2=A0 #define BTRFS_SHUTDOWN_FLAGS_DEFAULT=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x0
>>>> =C2=A0 #define BTRFS_SHUTDOWN_FLAGS_LOGFLUSH=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x1
>>>> @@ -1226,6 +1245,8 @@ enum btrfs_err_code {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btr=
fs_ioctl_encoded_io_args)
>>>> =C2=A0 #define BTRFS_IOC_SUBVOL_SYNC_WAIT _IOW(BTRFS_IOCTL_MAGIC, 65,=
 \
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioc=
tl_subvol_wait)
>>>> +#define BTRFS_IOC_GET_CSUMS _IOWR(BTRFS_IOCTL_MAGIC, 66, \
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_ioctl_get_csums_args)
>>>> =C2=A0 /* Shutdown ioctl should follow XFS's interfaces, thus not usi=
ng=20
>>>> btrfs magic. */
>>>> =C2=A0 #define BTRFS_IOC_SHUTDOWN=C2=A0=C2=A0=C2=A0 _IOR('X', 125, __=
u32)
>>>
>>>
>>
>>
>=20

