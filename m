Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795805478;
	b=RBDRrJ7jtv+6I2GeVLvTKtyZgx2tNKBB8KbP64i+YobRGiJ9JgLxoS/2X/N7MILwa8rS
	 L4Qp3rQmXb4c+8azurCziPhkahOpHimTtIe14y0mP9/fEVlfoq+i3K8MJMxeBVB/0OSou
	 7bZol8b8oQ9CG8fyetqAZkQQHYepiob5Za/9XPlJM4pyfuTgrTdg0jN12qxHXoST1HWmd
	 FuCg1czIGtECnKBptc/ysh7khJDQlFeuR29IL6nFzC/hP9X+Nlj1iTUZpS46vzkGboTYz
	 h9goLMTh7ea4jJ8cp/u01MMrC0xWCFaqmjqTYfpihP9JxE/ETIChTx+fW2LSj2LTQoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805478;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
	b=LDsLF09sxE1wefaowzQHU9q0iiQGvCg6jdjL1GH6w52xGFRjKsJKfx5r/4iCXYpBEmQ/
	 un0E6Gs++NfNG5Nm2V4szdqrmToTKK24rDv//dMOmP8TsacqCu4U0+nT8/mOm4I7/h/wn
	 OtmrJ3mH16OYbXsuKA0NgrVtZLDg/Fgpvxs5ov9roT/kt57v7O0ZaXOO7bLg3GaE2+IsB
	 XcW43xsRjP42qAJK+EKpR12p+tJlZzVDCANSphNQzV/HCw/TqplJOkZ83RxWKBS0onOVQ
	 tHz8V2ouLMx/dpkDVeNxi2DOfW6RxeMtyfEe5R/RIYrFb9fgkPY6wlyUofYotrPopew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1515606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 18:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1515606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m3pNdptj
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a2f4ca0dcfso4829758f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 10:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795805476; x=1796410276; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=m3pNdptjqW81pY9NLNr665+hJMXwfSRIqlg9cV1mmo9g7662QC2nuYP6a74k3dZ3Iv
         zvWxD2plIKeVWrLGkl0fu/pCXc3Vzo5AvT6VFc4h9ivwKjhKyhk7gIjLCx9npZwJUmyQ
         Nk4TvX4IzB2micR2Tn6o+UKGujjmbSTrorSwb1pZ/GkQGqOji8LqBS5bCMicKVrMKepu
         ioYd1kId/PYWHMgCja4C2aGhqgHUyOK5G1CCmNbKgHfRfy+Yjo4yFy+orjpyYzTB+iHt
         M9/R5HRHUsAyOqHMXuprEzV4ETE8D3x09EMM2j33PoYMAXrIBvD7VzX01Z6gcTlyJABk
         Dmow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795805476; x=1796410276;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JmL8LoMVs76VvbagqtHAZXdxFbOYrgh5zmv9OUe36GM=;
        b=vFflUoQNV3HHwD2u5Ejb8PYzx7ziObNPMI0qTotZQQAMPaikh0P4KtZSVLI9YwvgwS
         9xurVhMPIywj6rwE3zPmHw8PAPyRReQCe5CRWbGA9GmK7eEIWzTMWpE5cnaByVoMU0Jf
         SWBNdzCgCQq1TyxbYYhQ8eLPM6pnxZyq9RWvBevQ/yZM6bID+kfQKqvzMMTTzLIHS/EJ
         5ADUm3cs8yW2c7+qDQlDFH5y39qSENkt5wWZt38OXibU5gO1nndxcKjZyVC0/vBMzvr7
         c6vPKsjMVTuI7XHyIos0t/0y/w5HaWFwPu6JKpw3oXg2TP/raGfIcERPOXphW5z/KfWp
         KfnQ==
X-Forwarded-Encrypted: i=1; AL+hErEkgrQ6JTgE1mYugrCIJHS79Wjr4pM9uREgSJtSykmOQYEj9ZVxlEskkyKZ5kLMwdiBDFq7ycMODBkBPA==@vger.kernel.org
X-Gm-Message-State: APuU4Z8XYv6EhEPrSV/5UIF6YOyjQMuprqluRhq6rfV6USiA04XRMv4x
	vWYfashCZWglQHcBGHexvs5kuOWAY2ZSvwef1rYttooyCIqHKym+qsiL
X-Gm-Gg: AZFdTZfY6NzQizBkKtp+n4fBBkAk4Ux1lKjPlcS7xH9c/zkH8r3ClcjVuOPjVHS/5Ug
	R4/RGwdyhZ906yTfjJXSx6oK6fZjqy/RWM8tvdx4lK8xZSatZCn4jCCnpb4s4Mzn0eW5eQbn0B9
	8HG9SgUeClVlvxR/aSrmnFyUrzFIhtmrc1EYHMmZ1bM+Mcj5QHrfiEzs3IJJH3I7t38246sj768
	I/iy74Q7/LVrFzYKJDTkk3YnIQGIOxZuw6rmgN9BF5aw/9kFu2EDJY/KHgqff8nz/GhFzwTvTNc
	sZtee4ilZUVXPtHSBjES4Syo9gBsJcXDZ5bgf/OCc6Sp5/XH/Yu6DTBbOZQCc6f0gzXV5spxMQv
	3d8Legnj5+cEoyuFeqHNGpactJvWVJ2OufyxAF5QopwaguCiFrJkSsvvDm/4g1CQi0Vb0vgTHT5
	L+gcxL8kHI/ieYEqMVvt8Afjoz2OPj5NraWHSM/oplXddiGjVwc4W1mxQW5eDK9xnmdIkNSZ/5I
	w1KKfctY05REATopFV69XR0n+/OKbEi8t3QJPqJ716WBG0ApOPspCa7m+vJftgDozFyg59814ON
	I4tQMYs/HboclHmsh25vlNhu0A==
X-Received: by 2002:a05:6000:4812:b0:48d:b650:69aa with SMTP id ffacd0b85a97d-4abb55185e4mr49465105f8f.50.1795805475952;
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4bef07f9e0dsm4921752f8f.53.2026.11.27.10.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 10:51:15 -0800 (PST)
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
 boundary=3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 27 Nov 2026 19:51:13 +0100
Message-Id: <DN67WTNVL19F.1D5GOBP57BP1L@gmail.com>
Cc: "Namjae Jeon" <linkinjeon@kernel.org>, "Hyunchul Lee"
 <hyc.lee@gmail.com>, "Eric Biggers" <ebiggers@kernel.org>, "Theodore Y .
 Ts'o" <tytso@mit.edu>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan Kara"
 <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J .
 Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, "Lauri Gates"
 <lauri.gates@gmail.com>, "Christoph Hellwig" <hch@infradead.org>, "Dave
 Chinner" <dgc@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <ntfs@lists.linux.dev>,
 <linux-nfs@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] vfs: add xflags mask to fileattr API
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
 <20261126163114.403846-4-koray.fra@gmail.com>
 <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>
In-Reply-To: <CAOQ4uxhA+93bo5WseLxe7cAvJHJ8eQodoQHLwh=iToyEVkeXEA@mail.gmail.com>

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 27, 2026 at 6:48 PM CET, Amir Goldstein wrote:
> On Thu, Nov 26, 2026 at 5:31=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add fa_xflags_rw_mask and fa_xflags_ro_mask to struct file_attr, both
>> __u64 to match fa_xflags' size, and bump FILE_ATTR_SIZE_LATEST to
>> FILE_ATTR_SIZE_VER1, which is now 40 bytes.
>>
...
>
>>  #endif /* _UAPI_LINUX_FCNTL_H */
>> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
>> index a13c7b32a1bd..63d88ebe3420 100644
>> --- a/include/uapi/linux/fs.h
>> +++ b/include/uapi/linux/fs.h
>> @@ -238,10 +238,13 @@ struct file_attr {
>>         __u32 fa_nextents;      /* nextents field value (get)   */
>>         __u32 fa_projid;        /* project identifier (get/set) */
>>         __u32 fa_cowextsize;    /* CoW extsize field value (get/set) */
>> +       __u64 fa_xflags_rw_mask;/* supported writeable xflags (get) / fl=
ags to set (set) */
>> +       __u64 fa_xflags_ro_mask;/* supported read-only xflags (get) */
>>  };
>>
>>  #define FILE_ATTR_SIZE_VER0 24
>> -#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER0
>> +#define FILE_ATTR_SIZE_VER1 40
>> +#define FILE_ATTR_SIZE_LATEST FILE_ATTR_SIZE_VER1
>>
>
> Man... we really need a bot to review all UAPI changes
> Please someone tell the bot to check
> NO LATEST/LAST/ALL constants in UAPI headers!!!

Forgot to add: maybe Sashiko can do it if asked nicely :D

> Your patch does not introduce this constant in UAPI but if we change
> it we risk spreading different versions in installed headers.
>
> Honestly I see no reason for FILE_ATTR_SIZE_VER* to be in UAPI
> either. For other UAPIs those constants are not in the UAPI header:
>
> ~/src/linux$ git grep SIZE_LATEST include/linux/
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER=
0
> include/linux/seccomp.h:#define SECCOMP_NOTIFY_ADDFD_SIZE_LATEST
> SECCOMP_NOTIFY_ADDFD_SIZE_VER0
> include/linux/xattr.h:#define XATTR_ARGS_SIZE_LATEST    XATTR_ARGS_SIZE_V=
ER0
>
> So please move those contacts before adding/changing them
> (can be in the same patch IMO).
>
> This is a high level review.
> I did not look at the details of the conversions and validations
> Will do that for v3.
>
> Thanks,
> Amir.



--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawnRIQAKCRDmj22qf5IG
XJUmAP9OYQdkwBS0FIjyqP9a3I8gdrfFrp/bZms8ThGuY3SovAEA9zGXlhLiGxhC
iuYnX95tMjFyQ2w7/Y0yIwxjSTRZ7gg=
=DR0g
-----END PGP SIGNATURE-----

--3d0117b6230d8b8a6a185cfbfe10dda73718c7f46272653fffdbe69dff91--
