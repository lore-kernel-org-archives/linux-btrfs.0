Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF2932FA2E
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 09:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783763572; cv=none; b=hHj38KOarO8GPQLsZCqIawKqaow7JpTjFgkIDSdV0RiZFUO27LGNzbAGd4h6IRLMGRspU7Aw6+6AKyE8lhg+w1EOK6T4aa5zrNlJXorJIAvgKbJJahRpEFpYPCgOLPzla7q6UKF4h5T0J+sPs9DG0Tj+DPsPN8ogF3lmtQx2eJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783763572; c=relaxed/simple;
	bh=i4fzFD+svgSTVgC0omIqm5oFU0NlgGXb1pekfzmZYTY=;
	h=Subject:To:Date:References:Cc:Message-Id:Mime-Version:
	 Content-Type:In-Reply-To:From; b=HLmHUANZkosdqvWJrD9EYRBMfRWVWWWgUrsAVhx6ZU6Wph9+lntzOMEWQkmVV0E74fWSYMKvtB0L1xyfrycbEYHJYay46uuBEgVmXRSdo6LCgduLuQcQLuh3ChoS9aNyxhbNZUJNnFjjaGVmPQCCBULKQSW3ZItJ5a1sPbU5ESc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AY8elYpU; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AY8elYpU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783763557;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=i4fzFD+svgSTVgC0omIqm5oFU0NlgGXb1pekfzmZYTY=;
 b=AY8elYpURlp8XMMZrYMaI2nthWZOkH0Lf4a6hxABoMfHeS8O7o4tIZtfSqHoWRZ9lEAVjA
 F305/S2HE0kCFtgO6TVg1Cc+BjnAz17ZizEsLRDxe73pMW0FNRCfh32oOz0Mrf0sW4+XVq
 qge4JMvLIrI53UEP4r0ohgTKGO873gR5zr9E0rysEdWXg2lU/Sb906qZmLikfCYZ1U0kjm
 eNKKPfi+Z39sw2Eyp+hHi1sw5Tbb8cupl034SMqSXCDLrrId1h6w0pup6C9euMNljq5nTy
 RGNNlGgq83pgdIgddqCPZ7dmFam0y30atO6FcJCVLlsVlWVW6MLoLN3H3aTs/Q==
Subject: Re: [PATCH 1/3] btrfs: avoid NULL pointer dereference when block group tree root is missing
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 17:52:32 +0800
Received: from [192.168.8.64] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 17:52:34 +0800
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com> <20260711051909.1313584-2-zhudongjiang@fnnas.com> <2fc07620-861f-4bb8-ad36-71128ec1ab09@gmx.com>
X-Lms-Return-Path: <lba+26a521263+10940c+vger.kernel.org+zhudongjiang@fnnas.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Cc: <dsterba@suse.com>
Message-Id: <46fb761c-838f-4701-89aa-e56a85cca972@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
In-Reply-To: <2fc07620-861f-4bb8-ad36-71128ec1ab09@gmx.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>

=E5=9C=A8 2026/7/11 14:20, Qu Wenruo =E5=86=99=E9=81=93:
>
>
> =E5=9C=A8 2026/7/11 14:49, Dongjiang Zhu =E5=86=99=E9=81=93:
>> [BUG]
>> For a filesystem using the block group tree feature, corrupting the=20
>> block
>> group tree root and mounting with rescue=3Dibadroots triggers the=20
>> following
>> NULL pointer dereference:
>>
>> =C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum verify faile=
d on=20
>> logical 30654464 mirror 1 wanted 0x0f55b851 found 0xd7efdde7 level 0
>> =C2=A0=C2=A0 BTRFS warning (device loop0 state E): checksum verify faile=
d on=20
>> logical 30654464 mirror 2 wanted 0x0f55b851 found 0xd7efdde7 level 0
>> =C2=A0=C2=A0 BUG: kernel NULL pointer dereference, address: 000000000000=
0100
>> =C2=A0=C2=A0 #PF: supervisor read access in kernel mode
>> =C2=A0=C2=A0 #PF: error_code(0x0000) - not-present page
>> =C2=A0=C2=A0 Oops: Oops: 0000 [#1] SMP NOPTI
>> =C2=A0=C2=A0 RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrfs]
>
> The problem is why we need to use global block rsv in the first place?
>
> The whole fs is never going to be mounted RW as long as "rescue=3D"=20
> mount option is utilized.
>
> In the case of a rescue mount, we should just fill in a dummy block=20
> rsv, with block_rsv->full set.
>
> This will also fix the next bug you're fixing.

That makes sense, thanks.

I had considered simply skipping btrfs_update_global_block_rsv() from
btrfs_init_global_block_rsv() when rescue=3Dibadroots is set, but did not
choose that approach in the end.

Your suggestion is semantically more precise. If I understand it
correctly, would the implementation look like this?

void btrfs_init_global_block_rsv(struct btrfs_fs_info *fs_info)
{
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct btrfs_space_info *space_info;

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Existing space_info initialization. */

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(BTRFS_FS_ERROR(fs_info))) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fs_info->global_bl=
ock_rsv.full =3D true;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 btrfs_update_global_block_rsv(fs_info);
}

Would you agree with using BTRFS_FS_ERROR() here, or would you prefer the
narrower fs_is_full_ro() or IGNOREBADROOTS condition?

Thanks,
Dongjiang
