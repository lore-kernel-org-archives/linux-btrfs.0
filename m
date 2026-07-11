Received: from va-2-38.ptr.blmpb.com (va-2-38.ptr.blmpb.com [209.127.231.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859336DA13
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783765996; cv=none; b=kOBPnpyDq6IBlLsTPWOwcg2KuvrTulb1/Hsp+tMUZz/HMRRS0UXWqhRt7szz+HVgs9hY61J5BdKwnIXPwsa1gGB50+SOSDw/XLBQFsDxqxdLpIlzR1uyw/e6+8QtwnzJD+dIUtHexvoxqv1YHMa48iou6EOBmFEgqf0050AXPKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783765996; c=relaxed/simple;
	bh=GAovgoFCViNQ32G7iYjt9YYEUOEODT4iT8XCqzVH2x8=;
	h=Message-Id:In-Reply-To:From:References:Content-Type:Cc:Subject:
	 Date:Mime-Version:To; b=i7UmQQfqgyGRiMkda26TeOZrpwnIebg1JH7d5oTZ9t9J52bQhBIX4Yfanm8nCYXLdzm4FGcn2ze2lniQTnmOPr7OwEXsA8urzjHKhdKcsH2PAWdqpwsjHGk8+s43jUi0moZi6+xX22sGpP1tJsd34ORd9BnlWE4r5fqMUIxd2QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=VqA+BW4j; arc=none smtp.client-ip=209.127.231.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="VqA+BW4j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783765988;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=GAovgoFCViNQ32G7iYjt9YYEUOEODT4iT8XCqzVH2x8=;
 b=VqA+BW4j96ShOrl8cy1pcWvwe6F/ADQsmA7Ul49HAHjzd1GlI5M99mXfdMJ/ZBqq1QEfyU
 6RkIy93U6LW23d4npiDZ1zdYD35vJxUz8TR9Ge4lIgVVQnlVdwLAIRWVFqcR7f0Q9bJeW9
 Rgt4XQrH71xf5rxldpx4yH1Lp/IEuM9DiMT1KiPvZ4gYVW7C/oft+nOGuF28ipYnsAmNSs
 ETSkwXRyWO/xZmIJNhv3dMpBML/2JGYFlD+lFPwI7oZ0bVr8EfJ9LmEVE6oXBUaeirhyc/
 ChA6mrktzVkYzxof5tHcWgxqLx9umYfNJ/mIbuOfKZ6RTAksaUZcaCfVazppJw==
Message-Id: <99099790-200d-431f-9009-5c121bc2b7bf@fnnas.com>
In-Reply-To: <df2d93c0-2e7e-422d-8c81-8ddb1dfc00c3@gmx.com>
Received: from [192.168.8.64] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:33:05 +0800
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
X-Lms-Return-Path: <lba+26a521be2+836b05+vger.kernel.org+zhudongjiang@fnnas.com>
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com> <20260711051909.1313584-2-zhudongjiang@fnnas.com> <2fc07620-861f-4bb8-ad36-71128ec1ab09@gmx.com> <46fb761c-838f-4701-89aa-e56a85cca972@fnnas.com> <df2d93c0-2e7e-422d-8c81-8ddb1dfc00c3@gmx.com>
Content-Type: text/plain; charset=UTF-8
Cc: <dsterba@suse.com>
Subject: Re: [PATCH 1/3] btrfs: avoid NULL pointer dereference when block group tree root is missing
Date: Sat, 11 Jul 2026 18:33:02 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/7/11 18:17, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/7/11 19:22, Dongjiang Zhu =E5=86=99=E9=81=93:
>> =E5=9C=A8 2026/7/11 14:20, Qu Wenruo =E5=86=99=E9=81=93:
>>>
>>>
>>> =E5=9C=A8 2026/7/11 14:49, Dongjiang Zhu =E5=86=99=E9=81=93:
>>>> [BUG]
>>>> For a filesystem using the block group tree feature, corrupting the
>>>> block
>>>> group tree root and mounting with rescue=3Dibadroots triggers the
>>>> following
>>>> NULL pointer dereference:
>>>>
>>>> =C2=A0=C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum veri=
fy failed on
>>>> logical 30654464 mirror 1 wanted 0x0f55b851 found 0xd7efdde7 level 0
>>>> =C2=A0=C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum veri=
fy failed on
>>>> logical 30654464 mirror 2 wanted 0x0f55b851 found 0xd7efdde7 level 0
>>>> =C2=A0=C2=A0=C2=A0 BUG: kernel NULL pointer dereference, address: 0000=
000000000100
>>>> =C2=A0=C2=A0=C2=A0 #PF: supervisor read access in kernel mode
>>>> =C2=A0=C2=A0=C2=A0 #PF: error_code(0x0000) - not-present page
>>>> =C2=A0=C2=A0=C2=A0 Oops: Oops: 0000 [#1] SMP NOPTI
>>>> =C2=A0=C2=A0=C2=A0 RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 =
[btrfs]
>>>
>>> The problem is why we need to use global block rsv in the first place?
>>>
>>> The whole fs is never going to be mounted RW as long as "rescue=3D"
>>> mount option is utilized.
>>>
>>> In the case of a rescue mount, we should just fill in a dummy block
>>> rsv, with block_rsv->full set.
>>>
>>> This will also fix the next bug you're fixing.
>>
>> That makes sense, thanks.
>>
>> I had considered simply skipping btrfs_update_global_block_rsv() from
>> btrfs_init_global_block_rsv() when rescue=3Dibadroots is set, but did no=
t
>> choose that approach in the end.
>>
>> Your suggestion is semantically more precise. If I understand it
>> correctly, would the implementation look like this?
>>
>> void btrfs_init_global_block_rsv(struct btrfs_fs_info *fs_info)
>> {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_space_info *space_info;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Existing space_info initialization=
. */
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(BTRFS_FS_ERROR(fs_info))=
) {
>=20
> I'd prefer to put this inside btrfs_update_global_block_rsv().
>=20
> Just in case there is some other call sites that can still hit=20
> btrfs_update_global_block_rsv() for a fully RO fs.
>=20
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs_info->=
global_block_rsv.full =3D true;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs_update_global_block_rsv(fs_info=
);
>> }
>>
>> Would you agree with using BTRFS_FS_ERROR() here, or would you prefer th=
e
>> narrower fs_is_full_ro() or IGNOREBADROOTS condition?
>=20
> I'd prefer fs_is_full_ro().
>=20
> BTRFS_FS_ERROR() can be met for critical runtime errors, and we do not=20
> want to mess global_block_rsv at all, as it may contain critical info=20
> for debug.
>=20
> For fs_is_full_ro() is very specific for rescue options, thus nothing to=
=20
> save for debug in the first place.

Got it. Thanks for the clarification. I'll rework this and send a v2 later.
