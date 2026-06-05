Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1D73B1EC7
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780649645; cv=none; b=CCSk+a555rB/eQJ5bbuh3D75Vt1yNTNuNO1E5WpE1T6P43b+sI3Hi7rYBQBJqCqFOu5ZJ4mSQYCIwvSO8G0+IMayi+4gRRJw47+AQi4s2rSku48Nb38lSSDx/C5mhvbPzeQimYmKZmZTWh7xSrlHPToL6dekDgZ6qP54BepHS9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780649645; c=relaxed/simple;
	bh=owjNzcuDPD7nbq3jWXusvnPTckp/yrW708U04yRyuwc=;
	h=Cc:Date:Message-Id:Mime-Version:References:To:From:Subject:
	 In-Reply-To:Content-Type; b=AohBpzU9uRwnlQyef+QAXRb63wdjeERhOXg4l4omil0ETsT1990qit9rH5IfCcH7GBPuoXZXUutyqQrLZhDI8Sqbi/atqZrQsmRfxxmaf0Tz8On57G3Kw9lYb3TMNfbU6K8JnZw7E5IJ2KKWb/B9mr1Umrsr5POF++yHNzLwC1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=19nz3PYe; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="19nz3PYe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1780649630;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MQLWW7hW65ghUg6EKlfGGOf9BByq3Hh29MdpEKcvogw=;
 b=19nz3PYepfJ8Mv48JGifRs0ZjG1DBm4+dONhjIlVFY9wyNeHDnGsYPu93Aknauj24VavUe
 Mw1bEeQ2dBuUsfQgIHIzwDZ3mv3Te4vVs6bKlB8UT2w/mOVBY/lS8vxMylS9VGuyC9QDoE
 kt2jGVr0eukQSDqUBZFtauWVlV9V01WYfwbOzSfrag9Y6BtzfR4LMFm9K7x4y1oEe2cPT6
 IL9bkIPybiqemeeXY/bVrVkPZYz31rdKArEzafV/9ZQNa/HyvhmSBE6/7Woogz9MjnElLY
 Ga9gOVrNsliqYVZ5B1i/NFjt9O6lL2iMiMg/QROMpzlyBi0cb1XyGnZhNR8qew==
Cc: <dsterba@suse.com>, <fdmanana@suse.com>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 5 Jun 2026 16:53:42 +0800
Message-Id: <e9967ac7-05a4-484d-b2a7-8b246890fe0b@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260604085522.3872126-1-zhudongjiang@fnnas.com> <02849934-ca88-42a7-ba3e-a7196e1fcef1@suse.com> <60e3c20b-8490-41b6-8189-ea595dd2ffa5@fnnas.com> <f7550cda-a443-4979-b6c4-be086d23dfad@suse.com> <8a85da40-4c7f-4366-b4da-fecec9d33970@suse.com>
X-Original-From: Dongjiang Zhu <zhudongjiang@fnnas.com>
To: "Qu Wenruo" <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
X-Lms-Return-Path: <lba+26a228e9c+799b56+vger.kernel.org+zhudongjiang@fnnas.com>
From: "Dongjiang Zhu" <zhudongjiang@fnnas.com>
Subject: Re: [PATCH v2] btrfs: start qgroup ioctl transactions on the quota root
In-Reply-To: <8a85da40-4c7f-4366-b4da-fecec9d33970@suse.com>
Received: from [192.168.8.79] ([183.34.165.103]) by smtp.feishu.cn with ESMTPS; Fri, 05 Jun 2026 16:53:47 +0800
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2026/6/5 7:02, Qu Wenruo =E5=86=99=E9=81=93:
>=20
>=20
> =E5=9C=A8 2026/6/5 08:21, Qu Wenruo =E5=86=99=E9=81=93:
>>
>>
>> =E5=9C=A8 2026/6/4 21:44, Dongjiang Zhu =E5=86=99=E9=81=93:
>>> =E5=9C=A8 2026/6/4 17:15, Qu Wenruo =E5=86=99=E9=81=93:
>> [...]
>>>> Furthermore, all those qgroup related operations (including enabling/
>>>> disabling) are all holding qgroup_ioctl_lock, thus there is no way the
>>>> quota root is gone halfway.
>>>>
>>>
>>> I may have misunderstood this part.
>>>
>>> The ioctl handler checks btrfs_qgroup_enabled() before starting the
>>> transaction, but it does not hold qgroup_ioctl_lock between that check
>>> and btrfs_start_transaction(). btrfs_quota_disable() can clear
>>> fs_info->quota_root and put the quota root under qgroup_ioctl_lock.
>>
>> Then enlarge the lifespan of qgroup_ioctl_lock.
>>
>> btrfs_add_qgroup_relation() and btrfs_del_qgroup_relation() they are=20
>> only called inside the assign function.
>> You can drop the mutex lock/unlock inside them, change then to do a=20
>> lockdep_assert().
>>
>> Then hold the qgroup_ioctl_lock inside the assign ioctl for the whole=20
>> duration, after start_transaction().
>>
>> Then you can safely access quota_root without refcount.
>=20
> My bad, this is totally wrong, you already need a quota root at start=20
> transaction.
>=20
> I think the better solution is something like this:
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(qgroup_ioctl_lock);
>  =C2=A0=C2=A0=C2=A0=C2=A0quota_root =3D btrfs_grab_root(fs_info->quota_ro=
ot);
>  =C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(qgroup_ioctl_lock);

Yes, this makes sense. I missed that the quota root lookup and ref grab
need to be protected by qgroup_ioctl_lock.

>  =C2=A0=C2=A0=C2=A0=C2=A0if (!quota_root)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>=20
>  =C2=A0=C2=A0=C2=A0=C2=A0trans =3D btrfs_start_transaction(quota_root);
>  =C2=A0=C2=A0=C2=A0=C2=A0/* Do the work */
>  =C2=A0=C2=A0=C2=A0=C2=A0ret =3D btrfs_end_transaction(trans);
>  =C2=A0=C2=A0=C2=A0=C2=A0btrfs_put_root(quota_root);
>=20
> Even if there is a race with quota disable and quota disable later=20
> removed the quota_root, later functions like btrfs_add_qgroup_relation()=
=20
> will still do the proper fs_info->quota_root check and exit early if=20
> quota is already disabled.

I am still trying to understand the needed lifetime here.

I rechecked this qgroup ioctl path, and I did not find a post-start user
of the root pointer passed to btrfs_start_transaction(). The trans handle
does not keep the root pointer, the quota root is not retained by
btrfs_record_root_in_trans(), and the later qgroup helpers re-check
fs_info->quota_root under qgroup_ioctl_lock.

So for this specific case, is dropping the temporary reference right
after btrfs_start_transaction() still unsafe, or is holding it until
btrfs_end_transaction() mainly the conservative pattern?

Is dropping the reference after btrfs_end_transaction(), but before the
transaction is committed, safe in this case?

> But I have not yet tested this, you still need to run fstests to be=20
> extra sure.

Sure, I will test it carefully with fstests.

Thanks a lot for your review and guidance.

Dongjiang
