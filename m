Received: from mx18lb.world4you.com (mx18lb.world4you.com [81.19.149.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6283264D5
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 19:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.19.149.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780256725; cv=none; b=IBcqDxXQAxCtVajPKCf/hj7YiPbe0V5/6W5HkjtlFgekQ4MoEl1cnFKFHkkaxSTdBE/cn+Bie1FB03uray5uU4snGiVgudIXLM7Fh+RqJR8IfSZVg7SiFh5dfEce+RvBRBF9fB9AFMNIcRUebetHPSqAPGepNKkHZlfdzH2etb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780256725; c=relaxed/simple;
	bh=LnkRJu4t03capS7kbBkJKds14l8/2vXrwoVYSDhGFSs=;
	h=From:Content-Type:Mime-Version:Subject:Date:References:To:
	 In-Reply-To:Message-Id; b=LptyeKAEWk2FveelmJ43qnDizIEPUwi8s2DlQ3kjyOln7gG3M4wvarNdlXbtjz/dKJ6Z19vNu0d9E1Up+Xdvq0c5uZYZmR5DoNpFexC0I3qXDYWAEHDyQv981fxkYitQyedatXeVlNch7wNlSceBhOeCfRUWJMZqv1RkB/v0PxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com; spf=pass smtp.mailfrom=bluemole.com; dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b=hMa89wvc; arc=none smtp.client-ip=81.19.149.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluemole.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluemole.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluemole.com header.i=@bluemole.com header.b="hMa89wvc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bluemole.com; s=dkim11; h=Message-Id:In-Reply-To:To:References:Date:Subject
	:Mime-Version:Content-Transfer-Encoding:Content-Type:From:Sender:Reply-To:Cc:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZPl/VK1m6hdgNMMzKPV3RlTC61SDfbGa5Ltx0auioaM=; b=hMa89wvciKRvEDLk+Uzm/A4UUG
	ofaFF4Nwa5SHSbu61K75DnrkE4SBh6U8N5qJRYWy5e3DkPtEcYE1UBXYTZNI1+2BHrUDLvYpd3fJP
	eiNb1/hhB1uWlP0qdCC1VrZb1E5w9y2/QlV0ovRr9b9t0BnrsbU/GcV/KIES/FVwZNKNgV/g+hkq3
	2XGEH8HviXr6hsxdcOelGi3kY3Iy9D0oIMeT/tgEz7cpCme40goXj6FRyySdBGyoxVWOhbpNAxT1e
	f2eFtdscGm/gz/MlQJN+iREHj3ATqqyH17yPw7Eh2wk6fEgp/v1d52HY1SUO8rFQJDYAj1kjEZei4
	XtO1CmQw==;
Received: from [41.66.99.8] (helo=smtpclient.apple)
	by mx18lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <ubu@bluemole.com>)
	id 1wTlDH-0000000072s-3S6Y
	for linux-btrfs@vger.kernel.org;
	Sun, 31 May 2026 20:48:44 +0200
From: Michael Zacherl <ubu@bluemole.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.10\))
Subject: Re: scrub error & discrepancy
Date: Sun, 31 May 2026 20:48:32 +0200
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
 <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
Message-Id: <F68EA392-6360-4899-AF7E-3AD00B994FDC@bluemole.com>
X-Mailer: Apple Mail (2.3776.700.51.11.10)
X-AV-Do-Run: Yes



> On 31.05.2026, at 10:27, Qu Wenruo <wqu@suse.com> wrote:
>=20
>> [4/8] checking free space tree
>> Space key logical 1048576 length 4194304 has no corresponding block =
group
>> Space key logical 5242880 length 8388608 has no corresponding block =
group
>=20
> This is a bug introduced in mkfs.btrfs, and fortunately it should not =
cause anything wrong.
> You can completely ignore it.

Is this valid for any "Space key logical =E2=80=A6 has no corresponding =
block group=E2=80=9C warning?

> With that said, your fs has nothing wrong, except the csum mismatch.
>=20
> Sorry, I have no clue how such corruption happened at all.

I had a look at the underlying SSD.
The number of unsafe shutdowns is IMO rather high.
I suspect the notebook=E2=80=99s power management in combination with =
Linux is a problem.
Quite a few times the OS didn=E2=80=99t manage to finish writing the =
hibernation image once the battery was depleted.
Resulting in a hard shutdown and/or an unreadable hibernation image.
How this may correlate with a corrupted config-file which is basically =
only read I don=E2=80=99t know.

Available Spare:                    100%
Available Spare Threshold:          10%
Percentage Used:                    0%
Data Units Read:                    132,882,223 [68.0 TB]
Data Units Written:                 49,545,231 [25.3 TB]
Host Read Commands:                 763,229,890
Host Write Commands:                1,041,806,327
Controller Busy Time:               2,205
Power Cycles:                       5,029
Power On Hours:                     837
Unsafe Shutdowns:                   336
Media and Data Integrity Errors:    0
Error Information Log Entries:      12,792

However, I=E2=80=99ll bring the system back to normal operation and have =
a closer eye on the fs and SSD.

Many thanks,
  Michael.

> At least the corrupted gai.conf fail should be able to restored by =
re-installing glibc package.


