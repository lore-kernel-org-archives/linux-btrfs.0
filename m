Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795733916;
	b=xZ+YK9mFZi5kpoFeR38WRX5UqG3tpgVlihkfKt4WS3v/5U7l5JhaPohIYQoGyI1Zth4Y
	 lmD8WBOkyqHj3IpwL/qYCrPUIQIlwfJi3VcAVjBwfZ5oxR4rzvIB2zPH7pYgLI90FJlKC
	 3Yac0J8nCHPUgzh9zsRq8bBXvHWjqc6j1YSqjEmHru4ufRqFqw8KhjtB3b2P8K7ZaB+u1
	 K5XWF4opR9r0b9r4n8/KRhxrHItU+H+BSL92NePNK7Zx117xplNzpAuc90FZGJ7G8aKYG
	 kSvTobO1tP+Bti9MMbKoTzAqPpeee4/aQ4IxXSKQr5JfeZGVyjcocgl+2+OBaRTIjKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795733916;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:X-Mailer:
	 References:In-Reply-To;
	bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
	b=Eg7sneTOV/JACMSkGydXGrbcAZ2YeKe5Eh/QLXfKXVSFzNACj4/zjcySJZ+mnBDq3Znd
	 IA390kul7rPo8y8OMtC0zsQFrz7vrBmvrYj4Gvu6Bbmq7JuHcIzEHqXRttp8OyRSr81P4
	 Mwa2n4Zg7CLQDXlwGR0o8Xu5ENqKUrhdzTIr474AoZTcdjmNjYFoKVZT00LYte7PAR5id
	 aaNL4Y7H3R+cKU4bTQdWjSug7r1pCMazo6PScyXjdC6tEXBp5B+AmJe+RbPZKc7Yp3nId
	 2OkdR8oNJA97hO9OMOLtTiWXc8WiFES3jLoGVIkVaIB787EJI5tCci4mk1TJgrkyLgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B4E606A327
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 22:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44B4E606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Slgjv2rC
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so51437845e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 14:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795733913; x=1796338713; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=Slgjv2rCfiamg+O9GJlFWAOQ9tg1YUbYxrZ9VVQK1e3h5ZRy4TxckJc3EvLoHkPBcp
         6JFfOqwouWJHw9vFwDGw5BKLK/q4FoMI7a/1JQPvJVVt92csAcY0NU1qXo/KRh5S9t3I
         8s5YGzWbAkRGZqQ5yBUMWlQmj1gSwN/6uNKcvQbVoSKqbpgTXmaqjewhAp0RZtZkwIVp
         N07Kpy7P09kbXO7OWl47yKEzBcSb0PEkzk3p0gJ90757PLddYD3e7pKI2zllVzgTjXak
         Rs+BXgOS+tT2mG06wnEKBDGNAQQXcRnPnBLeg0r8YS8lC083UKyytdUQ5+LaBSlDVwfq
         fo7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795733913; x=1796338713;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m8YUNG0289MJznW1Ljl78OszeJ++5ltmCqqiqlxz4Gk=;
        b=HY4HdnwppZU8uM4f7LNDL/zDXVlMp7cgMJjk4yhWRBhA13+1OFSE1NUUaO3DtlEa/K
         628XFIS7+2hA24aNN6oMIiCObuLGvctwFfKSeCbCpenlPXpdM04J1lhNcQrQn9bknbM5
         3Mw5Hz2Zm24q1jxDHrP4CYP1NJmENpYgRU0MuWPk9GFRQTO7Xm0awx/+/6a5G1W7zpvD
         cL6mZAYV0Nb2OeQtgtHuPfr8mSRzUmfssPK98vQVMMpUASt5e75gUVIE2GgjJLAesVuR
         A8UbuXdHfQEsKoZWsbmEdFuCOAnVqUUBRFr8vOHKy1pbK14VworsH3PvdigXN+fCBrx5
         ZMtQ==
X-Forwarded-Encrypted: i=1; AL+hErGyTrJMt3RX/B1ARpo5yl50SYA7aHK5McISumgBKdU08HqCuZOKZL4KASrTNUWqhqBvoLfV3/wkZFkMMA==@vger.kernel.org
X-Gm-Message-State: APuU4Z98+deLnBJPoeWOU7qVw4hvXofvEwODiTXlNdGmTQogkAB3IB1b
	sYyrtQEwZ7oOS9MVNirRjRBPvafVSXLkXcKjH3qcarXArn6Owapzvljv
X-Gm-Gg: AZFdTZchNbTSWkI4jmkSCJZOhwOeiPgsemh6H6QbB02MtdQZfFbvGHZABG1EHVTVXkt
	3eQQ5Kr1lNZ/RTArKToYDjD9pBWcec/7gMpLM2T1boJjfcUfI8w4Rbpc+kdufpH42ANlnhGX+t6
	2AWEHrNdP1cTcJIPWsHLV2DqI2qXxaFjXbiadX90HkNBW35LzWKSijG9qZDhjPFQbo/BOhtswSc
	E3kaw8bWrqxbX/72W1GIrBnppXYwCWW/fM3T+Gjl+HvbopY+5Ul78wMFYqEuMdZglQe5607Cz8k
	aOsO5Qunbz0aNlTb8ye7IrskyWeju5H6YutQF4eBxzoVWxWHkCfrRqPGsHmywoHg4Tcb7i79QA9
	6xZ3BgbYKAqS0k0p2S5xci40XLZKSd7hcKQCwpGlPNg0bZCVsQMwuOOdYbX4evHZbxmkcFESYGK
	1dtUPo39bNMm10w02m97p6H+bu1SexJYEwyGcD9DAOJ1APYPftToFf2OmGIL+lGPI+ek3FLewXt
	fA+MW4KrPmoLpV0jZBZ85E+DCGuwonjiiV02d0hlR6ZJG/xPx1w/5No7mh48fRvVbNw/h6TbCdE
	ssUdvyKunJqn6e/KXnRAsuobNQ==
X-Received: by 2002:a05:600c:4e87:b0:4a7:6bc7:f778 with SMTP id 5b1f17b1804b1-4bb88938d38mr467930345e9.30.1795733913027;
        Thu, 26 Nov 2026 14:58:33 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110c3csm41489064f8f.36.2026.11.26.14.58.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 14:58:31 -0800 (PST)
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
 boundary=05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 26 Nov 2026 23:58:25 +0100
Message-Id: <DN5IJJMT5L0L.QV32G91MJ6D7@gmail.com>
Subject: Re: [PATCH v2 0/4] Add f*_xflags_{rw,ro}_mask flags to the fileattr
 API
From: "koraynilay" <koray.fra@gmail.com>
To: "koraynilay" <koray.fra@gmail.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Hyunchul Lee" <hyc.lee@gmail.com>, "Eric Biggers"
 <ebiggers@kernel.org>, "Theodore Y . Ts'o" <tytso@mit.edu>, "Jaegeuk Kim"
 <jaegeuk@kernel.org>, "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>
Cc: "Chuck Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Alexander Aring" <alex.aring@gmail.com>, "Darrick J
 . Wong" <djwong@kernel.org>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Amir Goldstein" <amir73il@gmail.com>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, "Lauri Gates" <lauri.gates@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, "Dave Chinner" <dgc@kernel.org>,
 <linux-btrfs@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <ntfs@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261126163114.403846-1-koray.fra@gmail.com>
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 26, 2026 at 5:31 PM CET, koraynilay wrote:
> This is a follow up patch series stemmed from [1] and [2], splitting the
> _mask change for the fileattr API into its own separate patch.
>
> The first patch is a preparatory cleanup so that the code in the later
> patches can be formatted better.
>
> The second patch updates fscrypt_prepare_setflags() to take FS_XFLAG_*
> xflags instead of legacy FS_*_FL flags.
>
> The third patch is the actual implementation, which introduces:
> - fa_xflags_{rw,ro}_mask fields to struct file_attr
> - fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_ka=
ttr
> - AT_FILE_ATTR_MASKS at_flag for file_[gs]etattr()
>
> These masks have the following semantics:
> - rw_mask:
>   * for filesystems: advertise which xflags they support changing
>   * for userspace: specify which xflags it wants to modify
> - ro_mask:
>   * for filesystems: advertise which xflags they support only reading
>   * for userspace: ignored

...and I forgot to include the improved explanation.

I'll write it and send it tomorrow (hopefully).

> This allows userspace to not have to do a RMW cycle when using the
> file_[gs]etattr() syscalls, avoiding possible race conditions and
> simplifying their usage.
>
> Patch 3/4 also introduces the missing FS_XFLAG_PROJID flag so that
> programs like chattr can leverage the new mask API.
> FS_XFLAG_PROJID is kept out of the legacy FS_XFLAGS_MASK and so it's
> defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
> will be used moving forward for any new xflag (like the one proposed in [=
2]).
>
> Patch 4/4 converts fs/ntfs to this new API, to show how it can benefit
> filesystem drivers too, and for this purpose adds FS_XFLAG_COMPR and
> FS_XFLAG_ENCRYPT from their FS_COMPR_FL and FS_ENCRYPT_FL counterparts.
>
> The series has been tested with custom xfstests [3] (generic/816-835,
> xfs/611, xfs/673) across NTFS, ext4 (project quotas), XFS (project
> quotas and extent size hints), Btrfs, and F2FS.
> Note: these tests were written by gemini and not manually checked,
> before sending them upstream (if needed) I'll have to review/rewrite
> them manually.
>
> Note 2: there are apparently quite a few bugs with overlayfs and a few
> other issues, but I wanted to get the final API design out first.
>
> v2 changes:
> - make fa_xflags_{rw,ro}_mask in struct file_attr __u64;
> - add AT_FILE_ATTR_MASKS to opt in to mask semantics instead of needing
>   unreliable heuristics on usize and mask values;
> - reject intermediate sizes between VER0 and VER1;
> - reject non-zero masks on SET without AT_FILE_ATTR_MASKS;
> - add patch 2/4 for fscrypt_prepare_setflags;
> - add xflags_to_flags() / flags_to_xflags() and
>   fileattr_set_{legacy_to_mask,mask_to_legacy}() to translate between
>   legacy RMW callers/filesystems and _mask callers/filesystems;
> - clamp fa->fsx_xflags to rw_user_mask in file_attr_to_fileattr();
> - update fileattr_set_prepare() to validate capabilities and projid
>   changes against rw_user_mask / xflags;
> - move the rw_mask =3D=3D 0 early-return no-op from file_setattr() into
>   vfs_fileattr_set();
> - put FS_XFLAG_COMPR in FS_XFLAG_RDONLY_MASK only (keep FS_XFLAG_ENCRYPT
>   in both FS_XFLAG_COMMON and FS_XFLAG_RDONLY_MASK);
> - update ntfs_fileattr_set() to apply only bits selected in
>   fsx_xflags_rw_mask;
>
> Thanks,
> koraynilay
>
> [1]: https://lore.kernel.org/CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFs=
bcGp1ew@mail.gmail.com/
> [2]: https://lore.kernel.org/CAOQ4uxjVQ9cjV=3D_jBjQtNg9zCuWUEJT9KNYMKV+1j=
wBkHen5OA@mail.gmail.com/
> [3]: https://github.com/koraynilay/xfstests/tree/patches-in-queue
>
> koraynilay (4):
>   vfs: use goto out on error in vfs_fileattr_set()
>   fscrypt: update fscrypt_prepare_setflags() to use xflags
>   vfs: add xflags mask to fileattr API
>   ntfs: switch to the new xflags fileattr API
>
>  fs/crypto/hooks.c          |  10 +-
>  fs/file_attr.c             | 357 +++++++++++++++++++++++++++++++++----
>  fs/ntfs/file.c             | 109 +++++------
>  include/linux/fileattr.h   |  14 +-
>  include/linux/fscrypt.h    |   6 +-
>  include/uapi/linux/fcntl.h |   6 +
>  include/uapi/linux/fs.h    |   9 +-
>  7 files changed, 409 insertions(+), 102 deletions(-)
>
>
> base-commit: 3857587d9d6fa44d40d1c73bde6a39f6f7a5216c



--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawi5kQAKCRDmj22qf5IG
XG6WAPwJQXkvnYM2T6CI+OL3CbCXJcdyvNtTqqpqmtzkWtEBdQD8CWhtnTm8Mn20
vvyMXHnKEDWD/QMw27jw1T31axApsQ0=
=Trt/
-----END PGP SIGNATURE-----

--05d75f0ce163acd47afe49ecf5a8d87df78d75f96b711c550e361cecbf9b--
