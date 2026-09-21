Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBBD47886A
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789987177; cv=none; b=Rs89EIq9VPMtIACDM8jOHmDBrCNWapxuBA/1pz6TVYfAA3Xvm5toC6bquFxC3f5cV+nTaN3T2jj50ni0Xn/qDSN+V+iix8x++g/w4OhQSiNpnnf1udHZmblxly1QwQKBVwYYVWIThvRIsJ66dn+3fy52urk1t0bVSzm4r9MOS1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789987177; c=relaxed/simple;
	bh=BEHtexpR+BodYOHeefgY3bWxxo4BJ/59TAaYKP7UF1k=;
	h=References:To:Date:Message-Id:In-Reply-To:Mime-Version:Subject:
	 From:Content-Type; b=O0Is6AHF0kvPB9mDDYihbbTsV6BuLtdDW3kCwtyPE0ktysaLM8ySoPMwhMFCZk0aM/ZK6eH4/czALU/FFKK9h8MlaRvc+tgX8PfqWzCcsS1SHpnAQotHzALPM+phg/l6mJf2b8LVLMPLHjeeAhdjq7TtrfR/IhcReDd8+gN7jnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=WkV699A6; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="WkV699A6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789987160;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=BEHtexpR+BodYOHeefgY3bWxxo4BJ/59TAaYKP7UF1k=;
 b=WkV699A6uCOjMEFLA6w7hUC9h0GdaSm9MfSEYc8H2628h7IriDSWRwt2S1OzYcnnmZoIho
 BASM/EGpuKA3pCgZW7VYiJvN8MkDTkg82NUFL+NLp506mEgCwIEDmk6mcO8dFdGOR4NKo1
 3zfdOEG978lsFxfH4WIV/LQOC9a2b2+kSTDnTWYjEoutUI4JFtKRLEA5phc5V7VUCsxg4j
 UnHfs0XwOYTqOMsQd4dyLiv15OmSUSgrPuKE205y+GmfAY1jxj40lXVhendvJweI577Coa
 5TJDStBzJr1QGwfKlQ4qUcL2GtloFHI8PkI6qIl8jYeAHm5MXrlUEwVxKI95SA==
References: <cover.1789981860.git.wqu@suse.com> <b0f743a5d512c45d5184086c1b7f26af65cc261e.1789981860.git.wqu@suse.com> <e6a0a484-c404-4f52-a30d-2c112efe493e@fygo.io> <ab276690-ccd3-4d37-84d0-77f8796615a9@suse.com>
Received: from [192.168.8.64] ([183.34.169.232]) by smtp.larksuite.com with ESMTPS; Mon, 21 Sep 2026 10:39:19 +0000
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
Date: Mon, 21 Sep 2026 18:39:14 +0800
Message-Id: <62de623f-9ea2-45f7-9895-b7a0d45445f1@fygo.io>
X-Original-From: Dongjiang Zhu <zhudongjiang@fygo.io>
In-Reply-To: <ab276690-ccd3-4d37-84d0-77f8796615a9@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/3] btrfs: let rescan_should_stop() decide if the rescan flag is cleared
User-Agent: Mozilla Thunderbird
From: "Dongjiang Zhu" <zhudongjiang@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26ab10958+29bc29+vger.kernel.org+zhudongjiang@fygo.io>

=E5=9C=A8 2026/9/21 18:26, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/9/21 19:44, Dongjiang Zhu =E5=86=99=E9=81=93:
>> =E5=9C=A8 2026/9/21 17:16, Qu Wenruo =E5=86=99=E9=81=93:
>>> Currently if rescan_should_stop() returned true, aka the rescan should
>>> be stopped, then we won't clear the BTRFS_QGROUP_STATUS_BIT_RESCAN
>>> unless the BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN is set.
>>>
>>> However the reason why we should stop rescan is also affecting whether
>>> we should clear the rescan flag:
>>>
>>> - fs closing
>>> =C2=A0=C2=A0 Should not clear RESCAN flag, as the next mount will resum=
e the rescan
>>>
>>> - fs remounting (from RW to RO)
>>> =C2=A0=C2=A0 The next RW mount will resume qgroup rescan, so we should =
not clear
>>> =C2=A0=C2=A0 the RESCAN flag.
>>>
>>> - quota already disabled
>>> =C2=A0=C2=A0 We should clear the RESCAN flag.
>>>
>>> - CANCEL_RESCAN bit set
>>> =C2=A0=C2=A0 We should clear the RESCAN flag, for now it's a special ca=
se and
>>> =C2=A0=C2=A0 checked manually later.
>>>
>>> So it's better to let rescan_should_stop() to determine whether the
>>> RESCAN flag should also be cleared.
>>>
>>> Since we're here, also slightly change the message, the CANCEL_RESCAN
>>> bit is already cleared before outputting the message, so that
>>> corresponding branch is dead.
>>>
>>> Save whether we still have the RESCAN bit set when still holding the
>>> qgroup_rescan_lock instead, and use that saved result to determine if
>>> the rescan is properly paused or canceled.
>>>
>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>> ---
>>> =C2=A0 fs/btrfs/qgroup.c | 41 ++++++++++++++++++++++++++++++-----------
>>> =C2=A0 1 file changed, 30 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index 05e35eb126dc..eb71f5d7c1a5 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -3862,16 +3862,31 @@ static int qgroup_rescan_leaf(struct btrfs_tran=
s_handle *trans,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>>> =C2=A0 }
>>> =C2=A0 -static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
>>> +/*
>>> + * Return true if the rescan should be stopped.
>>> + * If returning true, update @clear_rescan_ret to indicate whether the=
 rescan
>>> + * flag should be cleared.
>>> + *
>>> + * Return false if the rescan should continue.
>>> + */
>>> +static bool rescan_should_stop(struct btrfs_fs_info *fs_info, bool *cl=
ear_rescan_ret)
>>> =C2=A0 {
>>> -=C2=A0=C2=A0=C2=A0 if (btrfs_fs_closing(fs_info))
>>> +=C2=A0=C2=A0=C2=A0 if (btrfs_fs_closing(fs_info)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *clear_rescan_ret =3D false=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return true;
>>> -=C2=A0=C2=A0=C2=A0 if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->f=
s_state))
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +=C2=A0=C2=A0=C2=A0 if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->f=
s_state)) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *clear_rescan_ret =3D false=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return true;
>>
>> What about an RW-to-RW remount, such as:=C2=A0 mount -o remount,compress=
=3Dzstd /mnt
>>
>> If the rescan worker observes REMOUNTING, wouldn't it stop with RESCAN s=
till set, but without a corresponding resume call after the remount?
>=20
> That's an existing problem, feel free to fix it.
>=20
> Here I only care about preparing it for the incoming freezing check.

Understood, thanks. Once your series is merged, I'll update and rebase my R=
FC series, then resend the remaining fixes.

Thanks,
Dongjiang
