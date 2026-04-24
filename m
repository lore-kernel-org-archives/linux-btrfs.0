Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A347145B11
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777054222; cv=none; b=al5FWxqp/mZaoeeHzv9H0xjSEZXhmECD6f+kwgWm039B37rx6y3iixU4/R8nL8BwWhoeGAupHT7rKjVXiV+/ywe9fTbJNYGqWeMt2jV4iJWi3eRcL5sYnw4Sl1Ef0Uawu7TwTu2JTbTjQiGmy4hH2eDtjItAN3KWPH5qHBrYH0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777054222; c=relaxed/simple;
	bh=SnHVnugkmfHA/e0iXjmwQnD9E4gBKImfDgn4hEPdNKE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bT7AxrLk5L0lK2+nE+MZxv9mtQ3fJWZVkq6JC+rq98exxJSG+G3HpjRu0IOv2mZPVSvvHlggsNfBToEuPGRsoLD4ljvcXNllWFMu52JQ3zSb+MvaB40GqwdhJ6W57QdpygILSMw0P2aG4f1IOVJTElp23aXhrW4iEBFvwKrCP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=atF1I2ZS; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="atF1I2ZS"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8eb5ad01402so667453785a.2
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 11:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777054220; x=1777659020; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XoHZqpGW9i9gvn0+VJIrNwEX38tnRbwk/Tc7Ri4dyE4=;
        b=atF1I2ZSUcJf9O7+tMfWmd+foM6h9TDQ2e+G570Ba0FHe/vZiPI+LUSTMJ2NXsHUMk
         R94LgJ6hnGgON7nD5Co7W0PHO8BhafFjACWqv4+MpMB7x7EpbanDmjYkZtj6LXAZPc4l
         3iz0lAlltApovz1WcxsnAMoZBirehYzRABEbwFrrLLE1Zg6fyCA7D8Z7OePRXQQIqkNB
         2NlDSsiiU6ohqSeLS5fgzB4kArmLm0BTb21BpKTGy+28+SXu9x4akS5EPGuGQdt59dDH
         UC6qInl3Zc8ZWUoyKr+4Z+Bakpey1B6AgxaTEG1wrP2hWMQd1HZ55uai+4WNWj73QUuR
         3zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777054220; x=1777659020;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XoHZqpGW9i9gvn0+VJIrNwEX38tnRbwk/Tc7Ri4dyE4=;
        b=m8v70XjMYnOBJaLpBEyweX+c79lhNLqet8vAqsk/lNS3d3rrGBIjTjg3DGK+lzczqF
         B0XGUW1Gr2e+T4hNv3BQuaOcu031pAfPqnZDfD/BYWvXhLSdO1XXFQpTDtDs4/ASlTsA
         6NqHawSCycUHL5uzbCw/uSjs3D0Tm4yOD2Ut1oqZJHKAdXZBMkuv9ZigtQChNZ04BM9j
         wMrzLhorVCuVK1YtkSsmcA1VVsUc+fDhagP2cBPh9+r5pX8dq8Q5o2KwLPJjyp3c+bBe
         moHuocrenExmvmcsrlEms2k54D2FwS/bSNPGb5rm/nM+7ynvS3f0ENQ3PAUyjSjG4TuH
         9RhQ==
X-Gm-Message-State: AOJu0YwnyIICU7CNy5MA7zWbZ5ZPwX7WERNhEwTnb+3Psxem5VKTXRPt
	YGqjhbE5uCsBNEa62wiBkiC/tttvRW5YtO3X3pbD/qzc7vmSRETfIL1a6Xxazw==
X-Gm-Gg: AeBDietR2we2Mhy12PLTLF89bYHnTzt5TdIQZgK4wD1TtRwJvEJpgvDAjN4HQ3SH31l
	icn5Js7GDsV7MWJT6teS92+o4BZrjEBs+jbbo32nuDHVlOv4r2R+R8aZINzVwW9E4+dHOsxA1bR
	uHQslfmAOsS9IFefksO8Lwlpjv5D7hgnspYn3fj86+LIRKpJfIw4Y7Fo6016wGSRwlSLuCqdoRa
	4j3vIzi0ho6EoLAIVF/HjaOPWchaPd/RLSiK06AXnm42KUvkMxDMg3f+DgrM3s4sCb1afhHng4C
	LkCb0JP+Ezmc0eWLVRafoNiweQUozKZNqMylQ8fLf0b23mf9H1mzJKthZJtjV7IB7kV/mBWs4WW
	1L5W7cKRJjfwArD8RvYiltu16cIwERopj2Fj4mtUgZ8LHAnKsAfeZBVy7ctzukT1QymKVaLzxei
	pLU7EVU+x+LudNYyTjsv4V5CXAKaYuF7n3SBmoKgsGVIIGZ4jIjgLe5Cml2IzCbhKqhU8st+Zna
	SMjR0uXok3/FafhiqygmLSTz0W2oqUXku5umkD3Odv8fmWo4g==
X-Received: by 2002:a05:620a:4589:b0:8d7:cf69:3bf5 with SMTP id af79cd13be357-8e78fa245ccmr4585394685a.14.1777054219836;
        Fri, 24 Apr 2026 11:10:19 -0700 (PDT)
Received: from digitalmercury.freeddns.org (172-97-250-177.cpe.distributel.net. [172.97.250.177])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8eb19632130sm1702181785a.41.2026.04.24.11.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 11:10:18 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Roman Mamedov <rm@romanrm.net>, Ulli Horlacher
 <framstag@rus.uni-stuttgart.de>
Cc: linux-btrfs@vger.kernel.org
Subject: How to corrupt a btrfs fs [was Re: Fixing a corrupted file system]
In-Reply-To: <20260424174904.385e875f@nvm>
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
 <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
 <571fb6a8-d4e7-42ed-9f19-22962163918d@app.fastmail.com>
 <87d1aca.ae41f579.19d4f977d95@tnonline.net>
 <20260424082300.GA361238@tik.uni-stuttgart.de>
 <20260424174904.385e875f@nvm>
Date: Fri, 24 Apr 2026 14:10:17 -0400
Message-ID: <87jytwtek6.fsf@digitalmercury.freeddns.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Roman Mamedov <rm@romanrm.net> writes:

> On Fri, 24 Apr 2026 10:23:00 +0200
> Ulli Horlacher <framstag@rus.uni-stuttgart.de> wrote:
>
>> root@moep:~# btrfs filesystem df /home
>> Data, single: total=3D95.01GiB, used=3D54.27GiB
>> System, single: total=3D32.00MiB, used=3D16.00KiB
>> Metadata, single: total=3D1.00GiB, used=3D293.70MiB
>> GlobalReserve, single: total=3D80.53MiB, used=3D0.00B
>>=20
>> (How) can I convert /home to DUP for System and Metadata?
>> (/ looks good)
>>=20
>
> See https://btrfs.readthedocs.io/en/latest/Balance.html
>
>   btrfs balance start -mprofiles=3Dsingle -mconvert=3Ddup /home

FYI, I just tried this with linux-6.12.57, btrfs-progs_6.17.1 and it
corrupted my filesystem.  Luckily I only lose this morning's and
afternoon's work...

I am happy to provide post-mortem debugging info.

Regards,
Nicholas

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEE4qYmHjkArtfNxmcIWogwR199EGEFAmnrsgkTHG5zdGVldmVz
QGdtYWlsLmNvbQAKCRBaiDBHX30QYU9dEAC1XKnDrWdL+8/DKnadgt1dPLU5ZkcI
oNg7z5foi73mbov3bXPbEfoh0Ea4LAbFOCIes/RoD3QI3KcT8pcqiamPpyGIEPwn
eT40rbab9+YhLQafyinQxJCtigk9d8zz9PC3it4aFbl7vpj14MTuneXH4U7e5Dce
CpemKJGJcs9AMqtGAFDjsffRFK/4/Vs0Qj0pZP0WzQMMaknWxtX8AXxm74K1H+hq
y5F2ZrjaI9am3jJRWthXc6ypGTh7q8CJdlu72t11kUlKRQ9o+Hiwh3a2iiyrBnhZ
7RXRNn+ZgHe34A6Bjn3nt7LzI2EP5dCPYkc4srS9qF2lMgz/+8wZEDSKJqgs/JUJ
6ptjIr42+3/zt0KKjd9qRnwO1ldCM1VmRu1QTRslDpIqVPkkrSJ4cIjGlVcHDRmA
2guUT2fSKqm4kIc8568TOX7Wf9aA/1OrXwdpAaLxTZj+6OMi22I8WljftCEj7LJq
imYkMc7Xw3hOL6pX51sKaH7Z6tKn+P3Z4yVL4Pcy7G/Zgp42Vc1iKYC4b4DWDcID
gy+fpEXOS9EcoGFucdeKC8u/1kXAaCcp7KQ3CUmL0WQGlhyvowOZCww9PMQbyfcI
41VSkdDx91KW9pj4C7NJaBQFiYBIZxbsNgjwjYHI/Y8uD0NQD8K0wHQhe0IY6mEl
j7pPTRe/ACss4g==
=9CD5
-----END PGP SIGNATURE-----
--=-=-=--
