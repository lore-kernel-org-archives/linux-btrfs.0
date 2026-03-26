Received: from mail.mailmag.net (mail.mailmag.net [199.192.20.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E0716F288
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Mar 2026 00:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.192.20.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774485110; cv=none; b=nkjRcVfPp3q9GX1M1biMHMS0ojcMyDb2zRKgY7Q06zi1fafyjVX6KayugTUnpf+cl6dBXEdiT+AwhuOx7QCHqkYUyTA+U2Ey8H0xf+nHRABQ3phbfvyLuPLCObNqBO6oSpi6iNn2UFW2+2InuQ+3Vx9LskHK98Fsy2n1mNLfVww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774485110; c=relaxed/simple;
	bh=0JbB86i4hxaJVNZAQgHhxE7w055V2Cul/YbHs+nmG6k=;
	h=From:In-Reply-To:Content-Type:References:Date:Cc:To:MIME-Version:
	 Message-ID:Subject; b=P0sZvwMd1Vk3Wq8D8xxvO7xTgE3pzwCBcX84yal12P0u+QSBmdkUB8zL4PKScTMhof8D3XPkydsi18GLjckRwkRuF/TGQI9dEqNIM2dJXZp+rk2vgpswmjfQsBvBCokbsm4yy8ho9iqa5BcMdKfI83L8wReo/kMegbomjkzRHls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mailmag.net; spf=pass smtp.mailfrom=mailmag.net; dkim=pass (2048-bit key) header.d=mailmag.net header.i=@mailmag.net header.b=oWfZA3sT; arc=none smtp.client-ip=199.192.20.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mailmag.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailmag.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailmag.net header.i=@mailmag.net header.b="oWfZA3sT"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPA id E5F93161D4C;
	Wed, 25 Mar 2026 17:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailmag.net; s=dkim;
	t=1774485107; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=0JbB86i4hxaJVNZAQgHhxE7w055V2Cul/YbHs+nmG6k=;
	b=oWfZA3sTO940xsjEQLbikJ0C+h/Tw5MO6Yr7govJll+Xyo7sBOZN8jnkakXug9DiABE3d+
	bmM5LYWeJ4QO44v9MXYYtOKfW19B8/9/ejFBgiqxR9n2+mug0F6XjH0aT/k1lyDCs7x+Ti
	CkzxWY6BusrKm3t74BlxljyNZZfzIWdz/Hp7F1IlNs9sbmC4qhUmJCGWa2nskLRAuQqWvn
	UIu6hYBW0NBb5bwW0hE6sn8KkggqduBLRQ2qZk3//XBXNF/dZWT3UNfgtcrbDoTo3Y4sUF
	1qMhXSoA5x8olhvf140ktBqdOlFGIehRyYpWff4ml+CjYc09Mp2DNSWTMngVmg==
From: "joshua" <joshua@mailmag.net>
In-Reply-To: <032be7a912897f0cf5ee90f3e5ee0b2c690ff76c.camel@scientia.org>
Content-Type: text/plain; charset="utf-8"
References: <f7b7f88c6f1b94b6f09f7f54bdaa3c0ee54f60ed.camel@scientia.org>
	 <2A0C37E0-28BD-4829-9778-AB20F4482F6D@mailmag.net> <032be7a912897f0cf5ee90f3e5ee0b2c690ff76c.camel@scientia.org>
Date: Wed, 25 Mar 2026 17:31:46 -0700
Cc: linux-btrfs@vger.kernel.org
To: "Christoph Anton Mitterer" <calestyo@scientia.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <4d1ee97f-0147-b303-6a88-dcdb253bb2bc@mailmag.net>
Subject: =?utf-8?q?Re=3A?= Btrfs progs release =?utf-8?q?6=2E19?=
User-Agent: SOGoMail 5.12.4
Content-Transfer-Encoding: quoted-printable
X-Last-TLS-Session-Version: None

On Wednesday, March 25, 2026 09:21 PDT, Christoph Anton Mitterer <cales=
tyo@scientia.org> wrote:
> On Tue, 2026-03-24 at 21:18 -0700, joshua wrote:
> > For what it=E2=80=99s worth, (not much) I used --convert-to-block-g=
roup-tree
> > on a large fs with precious data (~10 drives, ~100Tb, Raid1 data,
> > Raid1C3 metadata) and had no issues.
> >=20
> > Convert took a LONG time, but afterwards, all my data integrity
> > checks passed, scrub passed, and mount times are approximately 1
> > second now, compared to minutes previously.
>=20
> Thanks for the information. How long have you been running with it?

Don't know exactly, but it was shortly after the new Debian stable rele=
ase.
So probably around mid-to-late August.

I'd say a good 4-8 months at least since then, with no issues so far.

--=20
--Joshua Villwock

