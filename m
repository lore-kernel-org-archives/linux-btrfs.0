Received: from mx.tnonline.net (mx.tnonline.net [135.181.111.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50DE374E7A
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 19:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.181.111.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775156834; cv=none; b=eRRyFrQv1MAi/HyKKYGVR2KfuVnKwab9eh3TUHTnhLvYCGJRmVZF8y1isxtgtAtc3lRW+p/UBItYINyNLKjy192spqW2erAKsmCI/heGHGt+jUn+YtEhK4FvLGad7wHHruAq2Zohl+xM1gtyFI6yn38uEfNJYsCVMe2oHrGfXL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775156834; c=relaxed/simple;
	bh=qmC9C+Xi9Rg373sY/Gy01oydpp80QpOMo1YEE/AAcDc=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=eXlUqefKkRVlNeNrhkyrlKwmss40QdCJpAVnnC9mvH054lyQ4rpInRdAqdyNLDvgGS5zkEZP18fNNHsE4eQcO6dV7Ps6wGjWoQDnPpF7FeyiaTrDeNJwfCHkDzUaQV3L/9PPRsQUbGFg7sBuoODWmrb/ItLw53a+UedgfBKsokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tnonline.net; spf=pass smtp.mailfrom=tnonline.net; dkim=pass (2048-bit key) header.d=tnonline.net header.i=@tnonline.net header.b=bGRrWG02; arc=none smtp.client-ip=135.181.111.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tnonline.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnonline.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tnonline.net header.i=@tnonline.net header.b="bGRrWG02"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=tnonline.net; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:References:In-Reply-To:Message-ID:To:From:Date:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KgSKHCBu6VbcwubQpEae5ejQ+ZgG09Ima/JpXDbbmJ8=; t=1775156833; x=1776366433; 
	b=bGRrWG02dSOCE1sIe2F+uO9z8BrjuhlUjEjSGJELn4Ttkb3PyALvMCEpXcy6dUcrRvIb5AvJHIz
	kE9RzzxGum9D00+8bJlFNN+pX4L+b2laJIHA0/Fd1h6vQqE69DWGICdx00g/KgwiB6kPK+PJZrBZT
	51FHK63ELH1Sx/DHGQt3/U0N5goMl9SmsS4RPdWK/HF6yNhmRGe2B8D2zf6vFfL3Ubpkd+iQqVjhi
	aaYz/Ue/6bni/wYYvUF1aQGB9HwH2DUchG5lqGbWBnQ+gSbcXkrU7WDT3dAoTdI58ewCwwEE62T54
	kb21QRuGVKX8irs0gVNa5/9+/8LOdpdGHw3A==;
Received: from [2001:470:28:704::1] (port=48888 helo=tnonline.net)
	by mx.tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <forza@tnonline.net>)
	id 1w8NNe-000000003ey-2nR2;
	Thu, 02 Apr 2026 19:07:03 +0000
Received: from [192.168.0.114] (port=57608)
	by tnonline.net with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <forza@tnonline.net>)
	id 1w8NNe-00000000Ci3-1cBL;
	Thu, 02 Apr 2026 21:07:02 +0200
Date: Thu, 2 Apr 2026 21:07:01 +0200 (GMT+02:00)
From: Forza <forza@tnonline.net>
To: remi@georgianit.com, Qu Wenruo <wqu@suse.com>,
	Amit Shah <amit@infradead.org>, linux-btrfs@vger.kernel.org
Message-ID: <87d1aca.ae41f579.19d4f977d95@tnonline.net>
In-Reply-To: <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org> <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com> <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
Subject: Re: Fixing a corrupted file system
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Mailer: R2Mail2
X-Spam-Score: 3.0 (++)



---- From: remi@georgianit.com -- Sent: 2026-04-02 - 20:32 ----

>=20
>=20
> On Wed, Apr 1, 2026, at 5:21 PM, Qu Wenruo wrote:
>=20
>>
>> Nope, btrfs will only try extra mirrors, but in your case your metadata=
=20
>> doesn't even have extra mirrors.
>> Which is not common, as the default btrfs mkfs profiles will go DUP for=
=20
>> metadata.
>=20
> I forget what mkfs version, but the default behaviour changed a few years=
 ago so the default profile is Single on SSD's. (Correct me if this has sin=
ce been reverted.)  Something about the way SSD's copy on write, the DUP en=
tries would end up on the same physical block, so the redundancy was not ef=
fective.
>=20

It is the reverse. Since btrfs-progs 5.15, the default was changed to DUP f=
or single device fs.

https://github.com/kdave/btrfs-progs/commit/65181c273e67bd48d01fc79f00826dc=
e38b93c4c

~ Forza

