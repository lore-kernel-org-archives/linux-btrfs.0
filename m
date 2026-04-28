Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C2A21B9F6
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 04:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777349049; cv=none; b=jtY1Lq7T6Gu3NdnpVtpHQPdOyPs61iJ0aTlcpdhsWySL01Ps4xdVQ9Gn/6zco6HcN+TnxWuCpYC4JGLV42E7AuZd3fATK1WysOI6cAJJtW3+jDPnIl1qr6VWJpPw/mA2MUPsZ6nx0fixRWXYHhPbWvfrL0eM0hUd0GnBYWemdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777349049; c=relaxed/simple;
	bh=Vf9meAD2C5oerFibtdfbn+0wJlxQPRg1RvHVR6eNf4k=;
	h=Date:From:Subject:To:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JLPlEuiWI3xiEIw7bCIqPBhljG9B8545n+qh5SJTbXOWFJEDyrCzeSDxMEJ9/3hxSUwHg4d+o7FKXUHeRD8E8AdkvNW6C3JWyZb3xciziojKwEFC/VVoVbh7uwZCiZ+v+TyBJrIZcykkVGrs7I0YaXvqJvaqtL19GloL5vK238Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=vdT5vQpd; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="vdT5vQpd"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g4RdJ0KlRz9tC6
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 06:04:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777349044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pI5sFeAF/++qVwj/7+VGlZfxNqoNjKSJhJgj8gQvMMQ=;
	b=vdT5vQpdXdyZ1OqM8020iLmuTk2wD4KNc6Y3WxvlzAiBYKYQTzG6DJLENRjtusncRrEpns
	stpZ+k78wgICUxtvMJwGmkJ5SkiRbgY6O63xxV7WCWPIQmhtV1cW83Fnhpt16N1OCC3SAN
	cevtzR8BdNqEW2MCYT2c8i84uZvR8wEeWb053a0xaXGXM3hyAbZi5v+Gl1tg5WFbVI/O26
	sb5bEpuPCF2bxUra7rMQhPyxnWxCJz/lrGMIgvG9Cz3uoEwWjzVGBJ0iPBWmSgQIf6Vud/
	p6QAEs64wOVo16rBIvnQCntNcYp7gmhjDkCefxENbViIESzibLur1e+dW4A0cQ==
Date: Tue, 28 Apr 2026 00:03:56 -0400
From: brainchild@mailbox.org
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <KAR6ET.BWL8BEMZPLSV@mailbox.org>
In-Reply-To: <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
	<20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
	<2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MBO-RS-META: hoz3q4y4yup4egr3dofizuik3qezq1co
X-MBO-RS-ID: cffa3af044ed8a888ca

I am simply reporting on my observations.

Deleting all instances of the file corresponding to the identified=20
inode, across all subvolumes, has resolved the problem with nbytes, but=20
fix-device-size reported no action, and the super mismatch remains.

In case you have any further thoughts on finding a resolution, I am=20
eager for any suggestions. I would like the volume to be fully healthy.

On Tue, Apr 28 2026 at 12:43:51 PM +09:30:00, Qu Wenruo <wqu@suse.com>=20
wrote:
>=20
>=20
> =E5=9C=A8 2026/4/28 12:03, brainchild =E5=86=99=E9=81=93:
>> With swap disabled, the scrub operation seems to reach completion,=20
>> with no errors found.
>>   =7FHowever, the check operation still discovers the same errors.
>=20
> Scrub is not a fsck, from man page of btrfs-scrub:
>=20
> Note:
>         Scrub is not a filesystem checker (fsck, btrfs-check(8)). It=20
> can only detect filesystem damage using the checksum validation, and=20
> it can only repair filesystem damage by copying from other known good=20
> replicas.
>=20
>         btrfs-check(8) performs more exhaustive checking and can=20
> sometimes be used, with expert guidance, to rebuild certain corrupted=20
> filesystem structures in the absence of any good replica.
>=20
>=20
>>   =7FThe output of `rescue fix-device-size' is "No device size related=20
>> problem found".
>>   =7FAfter, check still reports the same errors, including the super=20
>> mismatch.
>=20
> If you do not want to manually fix the nbytes mismatch, go "btrfs=20
> check --repair", which may also help to fix the super block size=20
> mismatch.


