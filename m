Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E5DDA9
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650705; cv=none; b=VWKBN9+prlP0zjsL2jp85As9ByayGvvWsL6YTYKq1gCszJ7FLXGLCS2O48A1JeFvNAboKsOInFqVrc1T5o8MhB5iWtD9vA/LvNOnAeD25aA1O3+Zsj56psbOypgucGlp+G6cGPpaHZBDYVh33V71jabmq/6LaTHFSwEtDJp9F7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650705; c=relaxed/simple;
	bh=JP9gzr3aGXGeNLrdcmpvn1bOK5sfzeXW0RUMt1fIxBk=;
	h=To:From:Mime-Version:References:Content-Type:In-Reply-To:Cc:
	 Subject:Date:Message-Id; b=Y277iKvlqZTqO7UOwFzVhA/cJZDdyebs6T8I4BR01KeMmt6iP2ityo25/EyP9a7SlaNeqt6T7NzPmhQEbyPL8SMxvE6av3qp8QaV5m2BVHi7gRciDXJGXi9D/YUmULSR+ClBUTOt0ssL0xkVy+jt7VDQHx+CUo4jG1E7XOkSNdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rYY1DCOv; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rYY1DCOv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780650692;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JP9gzr3aGXGeNLrdcmpvn1bOK5sfzeXW0RUMt1fIxBk=;
 b=rYY1DCOvuVuFX5JEbstfv5i7T902jBzuvilEekpthTicb1byE4PG7jNyez76s4CF5Ad2ox
 JTLJL4kmqGUaN0Pdccv7hMk7Vbtav3HVbXN7SECZSuK3C0WHZ0RzfBRZMQ7hBH9d5oOrYy
 ZfS72mpgZEEnsB08vACrCjIKqY1Hs3NUVBKM3iIQwKHvIZDunfpWNsGxMZms2nbM2edKt6
 0dthwe555TuoYe7H1ju2HLniQXb1x0dLVZ9DxpNG/mQEEHJY/Nr1XC9iPX4qyoKkxsB+vP
 pplXgtB744mEHV/mOTNlyolPnqivyGOUmJBczav7wzHb/cDKpLSGUONnJ+t8HQ==
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
Received: from [192.168.8.79] ([183.34.165.103]) by smtp.feishu.cn with ESMTPS; Fri, 05 Jun 2026 17:11:28 +0800
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com> <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com> <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com> <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com> <8a85da40-4c7f-4366-b4da-fecec9d33970@suse.com> <e9967ac7-05a4-484d-b2a7-8b246890fe0b@fnnas.com> <e714a93e-a0b4-4cfd-afa3-adc912bd44ad@suse.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a2292c1+f2e749+vger.kernel.org+zhudongjiang@fnnas.com>
In-Reply-To: <e714a93e-a0b4-4cfd-afa3-adc912bd44ad@suse.com>
Cc: <dsterba@suse.com>, <fdmanana@suse.com>
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota root
Date: Fri, 5 Jun 2026 17:11:22 +0800
Message-Id: <2ab64718-f26d-4584-b9ad-384a745ec411@fnnas.com>

=E5=9C=A8 2026/6/5 16:57, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/6/5 18:23, Dongjiang Zhu =E5=86=99=E9=81=93:
>> =E5=9C=A8 2026/6/5 7:02, Qu Wenruo =E5=86=99=E9=81=93:
>>>
>>>
>>> =E5=9C=A8 2026/6/5 08:21, Qu Wenruo =E5=86=99=E9=81=93:
>>>>
>>>>
>>>> =E5=9C=A8 2026/6/4 21:44, Dongjiang Zhu =E5=86=99=E9=81=93:
>>>>> =E5=9C=A8 2026/6/4 17:15, Qu Wenruo =E5=86=99=E9=81=93:
>>>> [...]
>>>>>> Furthermore, all those qgroup related operations (including enabling=
/
>>>>>> disabling) are all holding qgroup_ioctl_lock, thus there is no way=
=20
>>>>>> the
>>>>>> quota root is gone halfway.
>>>>>>
>>>>>
>>>>> I may have misunderstood this part.
>>>>>
>>>>> The ioctl handler checks btrfs_qgroup_enabled() before starting the
>>>>> transaction, but it does not hold qgroup_ioctl_lock between that chec=
k
>>>>> and btrfs_start_transaction(). btrfs_quota_disable() can clear
>>>>> fs_info->quota_root and put the quota root under qgroup_ioctl_lock.
>>>>
>>>> Then enlarge the lifespan of qgroup_ioctl_lock.
>>>>
>>>> btrfs_add_qgroup_relation() and btrfs_del_qgroup_relation() they are
>>>> only called inside the assign function.
>>>> You can drop the mutex lock/unlock inside them, change then to do a
>>>> lockdep_assert().
>>>>
>>>> Then hold the qgroup_ioctl_lock inside the assign ioctl for the whole
>>>> duration, after start_transaction().
>>>>
>>>> Then you can safely access quota_root without refcount.
>>>
>>> My bad, this is totally wrong, you already need a quota root at start
>>> transaction.
>>>
>>> I think the better solution is something like this:
>>>
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(qgroup_ioctl_lock);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0quota_root =3D btrfs_grab_root(fs_info->=
quota_root);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(qgroup_ioctl_lock);
>>
>> Yes, this makes sense. I missed that the quota root lookup and ref grab
>> need to be protected by qgroup_ioctl_lock.
>>
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0if (!quota_root)
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>>>
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0trans =3D btrfs_start_transaction(quota_=
root);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0/* Do the work */
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0ret =3D btrfs_end_transaction(trans);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0btrfs_put_root(quota_root);
>>>
>>> Even if there is a race with quota disable and quota disable later
>>> removed the quota_root, later functions like btrfs_add_qgroup_relation(=
)
>>> will still do the proper fs_info->quota_root check and exit early if
>>> quota is already disabled.
>>
>> I am still trying to understand the needed lifetime here.
>>
>> I rechecked this qgroup ioctl path, and I did not find a post-start user
>> of the root pointer passed to btrfs_start_transaction(). The trans handl=
e
>> does not keep the root pointer, the quota root is not retained by
>> btrfs_record_root_in_trans(), and the later qgroup helpers re-check
>> fs_info->quota_root under qgroup_ioctl_lock.
>>
>> So for this specific case, is dropping the temporary reference right
>> after btrfs_start_transaction() still unsafe, or is holding it until
>> btrfs_end_transaction() mainly the conservative pattern?
>=20
> Just for the sake of consistency, I would prefer to not have a new=20
> pattern of doing grab->start_trans->put.
>=20
> Just follow the common pattern would be much easier to maintain.

OK, got it. I will update it that way.

Thanks a lot,
Dongjiang


>>
>> Is dropping the reference after btrfs_end_transaction(), but before the
>> transaction is committed, safe in this case?
>>
>>> But I have not yet tested this, you still need to run fstests to be
>>> extra sure.
>>
>> Sure, I will test it carefully with fstests.
>>
>> Thanks a lot for your review and guidance.
>>
>> Dongjiang
>
