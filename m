Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F931D366
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 05:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777354174; cv=none; b=nwkZ6YF65+zXzDfioaFOIdeByhIx5JTCsn9eSgHcB2D4IgkzRZhY8YpeJlWBPkkHkI7y3nMPGjAYnLpLi1khUlMSqZJyQTKqx9SnyGFUoL6jIvS6fd42OKxQefCTAzTtUal/d/PzFohKVjsDcI+4yWC12p6bmyEXodteOu7pAEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777354174; c=relaxed/simple;
	bh=FITGLxBZFLUD/ruyX/cXwGHMOgya5RPx2mUwZjJ7PLI=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=pJ0eR2ddz1MWOOncrzAcmBvKMRyaHj63+SW+Xo7qXol0WksyEniLO+4iY2R7YUlk3JDWF0+Gs0GaVMfy47Q4TEtzaoGxUBC4esrBv4yzMmQu+6WCv2XYg4xo8iGuw7dQWoCZk3hZag2Ue/GYVdfpvCKAE923GhZzPfZ61Fu0sQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ZbmwPNLf; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ZbmwPNLf"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4g4TWs0xwmz9vP3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 07:29:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777354169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FITGLxBZFLUD/ruyX/cXwGHMOgya5RPx2mUwZjJ7PLI=;
	b=ZbmwPNLfgFqyFZzNSi6IwNOD5lREQ/NY5oxoO9bRWsSrtpgsrAuxm5X1dUjLkqFkulybSb
	T2kkJ9wCJ4L98daVz7eYcgvQZq0s5NOjofB9rwqPMB8eWQx5saeuPB6zRy4kotrU7pMCGJ
	lP1AJ/MJZ5O7K7ckBP5LoPXeIr4ZlKb0hRc5iz+MV70gt6x+7q4OZbcUPLPfdLNhRZjg0T
	wbQ8gMuV3uL80ZWTvyu+GvRJG6JIW7A0pi9YSEAZYfYdHmR8dnpeToVdT06eNhveObHYTB
	5QkTcxrS0AMywrCGCfyY1HPHD/i84xeOdpIOC2mmif4qyuAsKYti0NX5aD8ckw==
Date: Tue, 28 Apr 2026 01:29:23 -0400
From: brainchild@mailbox.org
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
In-Reply-To: <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site> <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site> <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com> <KAR6ET.BWL8BEMZPLSV@mailbox.org> <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
Subject: Re: Strange behavior with scrub, quotas, and snapshots
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
X-MBO-RS-META: bhkc564u5xop5u349ecrsgxub5efnnap
X-MBO-RS-ID: c776246a3547577f0ba

The volume seems to suffer still from at least two problems:

- If scrub actually completes under any circumstances, it is required that =
the swap file is unused. Disabling swap is not always feasible during norma=
l operation of the system.

- Periodically, the filesystem reverts to a state in which creation of new =
files is prevented. Naturally, it is impossible to use a system normally if=
 the root filesystem is effectively read only.

As such, I feel less optimistic than you about the usability of the volume.

Apr 28, 2026 01:13:47 Qu Wenruo <wqu@suse.com>:

>=20
>=20
> =E5=9C=A8 2026/4/28 13:33, brainchild@mailbox.org =E5=86=99=E9=81=93:
>> I am simply reporting on my observations.
>> Deleting all instances of the file corresponding to the identified inode=
, across all subvolumes, has resolved the problem with nbytes, but fix-devi=
ce-size reported no action, and the super mismatch remains.
>> In case you have any further thoughts on finding a resolution, I am eage=
r for any suggestions. I would like the volume to be fully healthy.
>=20
> In this case, your fs has no problem and can be used as usual.
> That super block bytes mismatch can be ignored.
>=20
> I'll enhance the rescue command to handle the case you reported.
>=20
> Thanks,
> Qu
>=20
>> On Tue, Apr 28 2026 at 12:43:51 PM +09:30:00, Qu Wenruo <wqu@suse.com> w=
rote:
>>>=20
>>>=20
>>> =E5=9C=A8 2026/4/28 12:03, brainchild =E5=86=99=E9=81=93:
>>>> With swap disabled, the scrub operation seems to reach completion, wit=
h no errors found.
>>>> =C2=A0 =7FHowever, the check operation still discovers the same errors=
.
>>>=20
>>> Scrub is not a fsck, from man page of btrfs-scrub:
>>>=20
>>> Note:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Scrub is not a filesystem ch=
ecker (fsck, btrfs-check(8)). It can only detect filesystem damage using th=
e checksum validation, and it can only repair filesystem damage by copying =
from other known good replicas.
>>>=20
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs-check(8) performs more=
 exhaustive checking and can sometimes be used, with expert guidance, to re=
build certain corrupted filesystem structures in the absence of any good re=
plica.
>>>=20
>>>=20
>>>> =C2=A0 =7FThe output of `rescue fix-device-size' is "No device size re=
lated problem found".
>>>> =C2=A0 =7FAfter, check still reports the same errors, including the su=
per mismatch.
>>>=20
>>> If you do not want to manually fix the nbytes mismatch, go "btrfs check=
 --repair", which may also help to fix the super block size mismatch.
>>=20
>>=20
