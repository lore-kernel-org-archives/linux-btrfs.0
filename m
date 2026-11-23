Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795443739;
	b=hiy32ERYEfEei4+k5nt01LN6xN5JPlZ78i2J0POE9+wq4S3FIYZQTubB0J5/yq+7+XEM
	 vFZutiCJPXS6y3UqlQnkZ9Kj5NGrniLGyCCCC1l+Fq/XiH6XmJKj81OgXHmOdQGIeQ2mE
	 oo+vo1wGdZ/0vgintQ1QND/+T5cvISmzgAwDAn+0M+l0pXgeLO6ajwSMic/sN118UX0a8
	 U4fYXieZG4QMztHmBisP1EPDOETdppwWjhVEGBRNlah2QzNs3OLTKbPlBuHTZ8pbxtLhs
	 qNCTbOjbCUIz1iSB4Vb/PwKMzL6bCO3DZYHNXvLDUExdMBCTwU7zBQTiKIMAQnl9n/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795443739;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
	b=V2t+A4oB1prlqKMecqw6mmhmUo5bq18UJddtiSR87Wce2ewbK6sC4RGvlZ/1oMK3kE4k
	 JTMef5X3TzB1mX6njN+zxSzwerdfe/Tv50jnEKV1hNu9U6+Gmidga/FeYVR1g5/v34fhu
	 9FhtqdFtZ9nux6dxczk6SZcEKxSyFgYheNtoAFLb7BVy11M4Zq28u9TUac0qB0Cqlbj1S
	 C5cDqvYM1zOwa1prjj7Vg+FrRJB/JVXroc4Sfw+cDRfql4d/tkqh6wFDS65Us1JXOTEEY
	 mhZ3ZOX40BjOhtDMhSS9XRt9ppsoxIxWROieeYigv0q7/Mttuo+WeOVHaoPDyBBLi7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F916606A339
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 14:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F916606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=00fZwspv
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so22722435e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 06:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443737; x=1796048537; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=00fZwspvrkZHzlXeIp1sk0DPnZy6zbXYi6zIJ3d5v+w1NsTls89lOgHp7t/tKAch7D
         Hd4wIO6XRRuOp6DsoVpuy1fI1JBPDAuB4H2ar/Lx9QF9UMM3I2Bn+apTm6C02HriyEjS
         KA72OMzw0B/nPuHEn1s5VR5vbpTHGND2TpdI0u8SjlASUOf9KvX7qqbdv4pthaNSOPjC
         CBP+ouQep439U4VPJ4zVW33k/OEd+wxFLAmiROh0/cG1vbpp0ujnO+YiOIBm4UWAjdd7
         OjHijbDRGvuUxSrmtMDu3hyafB2uG4C7Vi4d2cljbIB0BPnpF3JySA7ndBemr4CxbXa8
         8Zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443737; x=1796048537;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MWpQl1xkyrhsa4v1aNpU05mPb+pCD8JS1KWXDWW/Gpo=;
        b=fi3S36/+Ez5gaKiXpUEHaKPzYC1oobTBTTsPhy1rDyvj1wFKX5TSg6mJKsQiJLhVEm
         Echr+Acev7yBR46vOGJ2JKVRwStFWat7kmv+aQs4geccWo06P8x1IoCqGVNjapM2o63i
         Yv/wev52bU0G0BM9z0C57Cbdk5pwLmBYOUeq1PvBc9sx1asz78+IzX8bDrfOIaGin7Ev
         jmPC1B6H90XKACiW0XUFa2bDDeCDsU9aTsXfUdtmvTaxEP4UuKt1TKL7RT3Q7+jnn/k3
         VZO1WpNxg8t1dNFik5UpOseXJa9hl9jDIWwmvAx0rH9h2rpte4xlmrIlozoRi58PMDx3
         8LaA==
X-Forwarded-Encrypted: i=1; AL+hErE+5hyK0zWx3ecT2hmRFAqDfwUANuYHLkhsI0sBIGq5IAWnyeGgrwf6T2I6mjjz+3dJg+HM38TGlIDVJA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8dGdSqtr3mVTg2+JQxtVRs/wAkIguOVz2GG7BSVy6RqPnZtVBy
	BaObOe6nn0FL1xbjwXfPqaDZtuZ/dOefSrF1LSW4Sgt9YoCSSL5IiT2K
X-Gm-Gg: AZFdTZe/04IMlD+/fuzU7PvMty1GSMnrkGj7JxKGT+735arOe7J3Pt8eL82Uplvrqxi
	1+t8zhhbwLpQ8Vr4YgBcTjszvPdWHTFxVe2EnZlFrSZIZTszn9Hc92xfD+58ihxPcjQdCL+w9ub
	uE/x5gQeHJYpIcIShlivfZjYFSkqY19wAjl8cJeY4I+Bm47+V0JbPmhafDiXK3w3VAzrfl+fmMg
	M4VBr0npQAMc58eSzV6Dp85kwEdgPUop8QC8NitrtnGr3YLLTLMp/Mvgm0Oi3mP9jwPKqsLbGFx
	1GvxmxVNcXh48bhLlcYMdaX9P/DI1InbExanBP9YESU6aq4kJSpNnkFdK1lNW2+Mpb+zN79sNk8
	SI9OUNDP4q4g30KS+B29LQbso++Ur/kDdBQaaP9DMGGsTjQrkjGIOzlXP4MRHPZeckuth32NG0q
	6zDZhZWj3ctnvygNNhVb/Tz6t30cv5jYTHtYFGDrk9elBNy3NDaj7Ax2Qtfsg71AQu5OWPA361d
	pUMKFNQk5/BIxVpTqggNvB6Ht8emiWeOqqgQvCjPAnqkA3EGVr3wgMxyINu545MqSg1Sook+3AG
	6XihqMu3C+j6By4v/9vROBsWjA==
X-Received: by 2002:a05:600c:64c9:b0:4bb:679a:86ee with SMTP id 5b1f17b1804b1-4bb88938dbemr253115345e9.29.1795443736768;
        Mon, 23 Nov 2026 06:22:16 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm170939525e9.2.2026.11.23.06.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 06:22:15 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 23 Nov 2026 15:22:13 +0100
Message-Id: <DN2NOOG9J6HX.1L4IO84SKCYOG@gmail.com>
Cc: "Andrey Albershteyn" <aalbersh@kernel.org>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH 1/3] vfs: use goto out on error in vfs_fileattr_set()
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261122000856.536902-1-koray.fra@gmail.com>
 <20261122000856.536902-2-koray.fra@gmail.com>
 <awP8S5KF9v-nqWVY@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <DN2NJH234CC4.2LSWRSOO4TX5I@gmail.com>
 <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiREfVU-WKiUVRZLb-uzMXzDEsmG13FVMW7YBoyq10=Nw@mail.gmail.com>

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 23, 2026 at 3:18 PM CET, Amir Goldstein wrote:
> On Mon, Nov 23, 2026 at 3:15=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> On Mon Nov 23, 2026 at 9:42 AM CET, Andrey Albershteyn wrote:
>> > On 2026-11-22 01:08:54, koraynilay wrote:
>> >> Switch from using if (!err) { ... } to the cleaner if (err) goto out;
>> >> in the main body of vfs_fileattr_set().
>> >>
>> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> >
>> > Looks good to me
>> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
>>
>> Thank you, can I add this tag to the v2 version of this patch (since it
>> won't be changed, and link to this thread in the comment section of the
>> patch)?
>
> You should always keep RVB when re-posting without meaningful
(RVB =3D Reviewed-by, right?)
> changes to a patch.
>
> That's how reviewing works.

Ok perfect, thanks.

Best,
koraynilay

> Thanks,
> Amir.

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawRMFQAKCRDmj22qf5IG
XCZkAQDH8wiuPEqDaB1cat+NLbwVTy9AgTGpQeVFZlTodz2juwEA00+c7xq8+RtC
rQ07nQ+3av0Gvb1S4BH2IP+66ik5awQ=
=/Ubu
-----END PGP SIGNATURE-----

--6835006247ad5b556582ac77c37dad0d5918ae309cf17b9da0cf6b359cde--
