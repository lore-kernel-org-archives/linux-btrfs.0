Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E87335E929
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 03:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786247411; cv=none; b=Xh3NaifqkX25Nbo9ra5iLjO0BvMbLNmh/mNi23UOGos/nDWQbP8wwc87vhCGauH+2QKQrX6+JDNlul1qRGcfkyHp5VgRupIpY/bAqkiwYWV6xvRr9K+yqXVLCyUob3QluUy+iZ+92KRUxNPoTiQuJBTpMqIha4wYLUb/8VyKcH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786247411; c=relaxed/simple;
	bh=M2AYsws/h7aOUrvh5/8Ad0YOaffiDDePnNmASTC/5sY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=q655kHPu6qtElGUmYf+0mj3iJ0N2nkT7YqoGaLgMF5Ys3PLMkkPUpJOxKA+tclA5RhNBt46c0h2Mbv9ThWRvyDTxS42l45jEen4XcUkd1E9kNdMvdwZRhH9NPEDkK8MTF1GIPlnCoqWBigXKoBOU7oOinzaPjPYqaPVdyjCBqAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSH4j2Zh; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSH4j2Zh"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495437bb891so6167515e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 20:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786247406; x=1786852206; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wH6hrRa5kpbuNerXdUjBKiCFkBwW7uk2sNk+hvaxwPY=;
        b=NSH4j2ZhJvWWR1YN+tRJJW+85UGwU/zVBHubCMqfSRl8TMgtfYLbYAcCiik0n/4Sda
         Cnqr9EMVqmBVoGqLoj9EAJIybtArrNItJaJsdaH1KxZvEwUR+LeN2QoGynglkUL23sy7
         J1QdiYkav8aZMUebmhMpFNK2rpCRRRtAi62iCijRbV541LQXuURoL0JwBt9czG3OZdfl
         Gq8qupPkuORhlAxY/2Yi5htxrl3peGRWbZnpCOjSZSfRjfoGNOXPi1PkeVrzg/eJlHqL
         rrxagSxkQuiSkMmuCGzO6wsNmDFp2A/fTlKCS0EGSgkIB90Ae2JkyIEqX8nOBcWmEsv9
         zrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786247406; x=1786852206;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wH6hrRa5kpbuNerXdUjBKiCFkBwW7uk2sNk+hvaxwPY=;
        b=rSZBcHknpuCwDpBBGIOidqy/4bmScE0sOqnE4QF5wF8rjlMMTaT1NysbEA5hPNwg+m
         jksQ+n3X9PjWsaKyQGqTxujxrQBsg6A/6m0SV6O7AShAozKUeAYnTwmvqknk5HzPCOhT
         tQDmQY19f0J5IIMq+4yY88NaSr7gdVwHk8mEK4o2oSE7x2iTXTe0EdiczEbREO4yo1NY
         LQp4DSRxHe2hqbtsvTUoi6trwnJxgBboCUKRqzqxqrxMRA0YDALvq/FlfiIxqlfMp5CC
         By7MEOI0XXDsiZC8RQwq9cmCkSEK0D5vv6x3r671v7V+jzZZDkFSwga71tUeHSCKtFC+
         LMQA==
X-Forwarded-Encrypted: i=1; AHgh+RprzBODIRRsER/MPXsgtbXZQkJWceiIzM3qBmOVKQOgbKKNObu1WiR2e5ean0dp8HdVusKLPChvxypbkg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyixtwe39TsYKgQXDvkjQJcRyXBHFEkEqEhKzKiy/BH6nvExAv6
	/a94yMor3ZJXBCYDC5ZbdCKux173W7MyZi2oMJXGTYb/Jj/XQ6bB07Om
X-Gm-Gg: AR+sD12eOqpCec6OCRrba/FjbRjSi1HJdTvIsa4Ceet6NZJ4gTjAo1d/gWsZH8STEOw
	8eiJLYzyuCNwOVBNgq0Ba/Y7UatXcHes/pAngxEBtiOLpe9L/5f4pg426VhBEz8ThVhYskv8q4S
	VfmMl4co+o77NbPhaKeilrw6blJyExggsa3Bpenmd2d2FOB/WcSC70Saykco6pIm7z6UWiu5MIn
	bkReOB5EhM3bXCHkuP23W25bWCDJAguFh6yU1lRJ6aRO2f2PR/UUDobLhadN+UFLGqs10y+F/V0
	pYioRAjsU8BN0nncb74UDCvDBrnT/knAL37oEYuaF+ZOjHjs2LuQudYT7EH5+bgJoBpbpwuTGyO
	GhWLxT8Ae41Zam37DpYL0KBAUSuTW6H9e8DkGzTaa5U0ONzqUub+7a+r/rxzR4r7AAKaLIiSzKi
	KrzuaFpC3Xm0x6ibWiVCvLXH8a14K7pw/rn/pYQY2bHWL7q1jvPO+4zp9/
X-Received: by 2002:a05:600c:1d23:b0:499:596b:2e91 with SMTP id 5b1f17b1804b1-4996245c776mr96967515e9.3.1786247406031;
        Sat, 08 Aug 2026 20:50:06 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995c7a54f2sm145184275e9.2.2026.08.08.20.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 20:50:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=c164e85823a9545da25aa048ad13430233e3a01bc40308df9768973f8801;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sun, 09 Aug 2026 05:50:02 +0200
Message-Id: <DKK3UWEQ1P6G.JHCWEPD1M09Q@gmail.com>
Cc: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in
 xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "koraynilay" <koray.fra@gmail.com>, "Chris
 Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
 <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
In-Reply-To: <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>

--c164e85823a9545da25aa048ad13430233e3a01bc40308df9768973f8801
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

> I'd prefer to have a dedicated patch to set compress_level to the=20
> default value 0, as a proper bug fix as the first patch of the series.
>
> As you mentioned in the cover-letter, this is in fact fixing a bug in=20
> the old behavior (mismatched algo and level).
>
> So it's definitely worth a dedicated fix, so that we can backport the=20
> fix without pulling in the full series for older kernels.

Ah yes of course, although, would it be better to have a single patch
that looks like this[2], which would also need to add
prop_compress_level's initialization to 0 as per [1] (that would
probably be good anyway) or simply a:

 compress_type =3D inode->prop_compress;
+compress_level =3D 0; //level in xattr isn't supported yet

in the 2 relevant places?

Thanks.

Best,
koraynilay

P.S. I also noticed that defrag_compress_level too doesn't get
initialized to 0, so if we choose that approach a separate patch that
adds it would be in order IMO.

[1]:
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e057aceaa68d..aec977f47cfb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7896,7 +7896,8 @@ struct inode *btrfs_alloc_inode(struct super_block *s=
b)
                                              BTRFS_BLOCK_RSV_DELALLOC);
        ei->runtime_flags =3D 0;
        ei->prop_compress =3D BTRFS_COMPRESS_NONE;
+       ei->prop_compress_level =3D 0;
        ei->defrag_compress =3D BTRFS_COMPRESS_NONE;
=20
        ei->delayed_node =3D NULL;

[2]:
diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1082fa92c145..0a4e567d0109 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -130,6 +130,7 @@ struct btrfs_inode {
 =20
  	/* Cached value of inode property 'compression'. */
  	u8 prop_compress;
+	s8 prop_compress_level;
 =20
  	/*
  	 * Force compression on the file using the defrag ioctl, could be
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2534cd9284d5..cff4b3e97559 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work=
)
  		compress_level =3D inode->defrag_compress_level;
  	} else if (inode->prop_compress) {
  		compress_type =3D inode->prop_compress;
+		compress_level =3D inode->prop_compress_level;
  	}
 =20
  	/* Compression level is applied here. */
@@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *in=
ode, struct folio *locked_f
  			compress_level =3D inode->defrag_compress_level;
  		} else if (inode->prop_compress) {
  			compress_type =3D inode->prop_compress;
+			compress_level =3D inode->prop_compress_level;
  		}
  		cb =3D btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_=
level, 0);
  		if (IS_ERR(cb)) {

--c164e85823a9545da25aa048ad13430233e3a01bc40308df9768973f8801
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanf47AAKCRDmj22qf5IG
XG/6AQDhmxVylsQjinbpq8nvfum8uPTpe+B34b2EZgTJ5qZWTQD/drUGphhKqZq/
CFTfutA7yis1UkyD4Xe0RbO+7/6gCg4=
=OP/f
-----END PGP SIGNATURE-----

--c164e85823a9545da25aa048ad13430233e3a01bc40308df9768973f8801--
