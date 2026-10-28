Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221955;
	b=kYZdW/QRQyr8jKSAyyZIEd9HXzPa36+sNEXjReC4FFzpQ2r6J/pUMQThio3R8sZ8Qh3/
	 FRKYzGxmf58cDU/dYJ2oHrv5YNhgwU/AJF35PnqaN4jPqPXIV2t9GNB/bP3bc5hHG4WhY
	 pqHSbVoLhgT4ezHD7M1oGbfpRGnR+Tn3vuev6nQj8IPVvz/Ts1l/mk43a5dHXxivZ5t+H
	 wjGX5hm2pqcz7q1IesujnXGNATmfeBlhpcLS79UuOYjWpTQAk/wm4cj5BZMXxeUTjVXm6
	 33oXTOoK5FfQPmI7gHUE3WM8za8K58ybibdZ0eQzl4BxXwXUGSjoTMj6SXOhb8rBCvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221955;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=xQYG6Eek7tElytcLfy1wx1UEuQsespAi1XALnFrixwk=;
	b=LUVByfd7QoDj4YQ6jeCr993rvsUcwpF5xNT2iDfwIsTlr8OgKRUetwmkiq5WJhjP2qg6
	 ivBgNxon54kvOlOCeW7nfSFFFanCxeKxWpPO5Edc71x8QRUr5vkFZoiUS758DTUbasSUY
	 lMtz/7wxSt/1TyN2VGljrYlkhrv7CxSBiynB7B87r9LyJmdCpAnivTup3BaEGu1/b5+rF
	 aF8fWg9x+H21sgrY1CZz2BDurjEMLCHRyInDL6sVs4Xjv+JE5LWqTT4vqCCOTeiXhm22u
	 QqILQ4nC4+fkXBJxMrEoBXvbrd9/BTWAN5KqeVnrxdlKqR2aHuXe+ruh8aJOuZyiGaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MBhdeAFs;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8254606A323
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 21:12:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8254606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MBhdeAFs
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c4d870d54so964631f8f.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793221953; x=1793826753; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xQYG6Eek7tElytcLfy1wx1UEuQsespAi1XALnFrixwk=;
        b=MBhdeAFsQ4fJS9yta/S1s+KXAQFfwSDfwbV5Eugq9byXI7ZZumVDaWmVrAY1pFSkU+
         WXtgEI+tt4/gCJESMnuNeIrRg84JRF6une+kiz0smneo63C7Mdba4MDTMJ8IXU3lkvQ6
         0lKJM/hz/wTYNxUYTr6KLA44Qv2kqBcbi2Twl2d3nJJVcCvb21BHZqCl0UC4kxxQG8h9
         JJ2qCT8UlStGXxTBua22UapnaM7e7nItbpLioHv6YZ7iCNfIgErMyNX9HdK421gmNfAR
         unCsxuxOkz4l92pugfOIkH5jV5WfcPbxMkAYkwZ0VX/3YZdv/2gd7rNhC6qdL7lZgH7v
         /XFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221953; x=1793826753;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xQYG6Eek7tElytcLfy1wx1UEuQsespAi1XALnFrixwk=;
        b=Wj7TD3v/c7DPIGIGG/+6A6pU0jtzZhLUtBUd78WZS2mCXKyLG46YGrPjkh2OL+x8gK
         4Z+EzdBXU+wUB75oyAaCMixmO3h7RRN2pf98kidB4JZGhH2eWLfP9jngF93QSO4BlhcJ
         Iox+sleHQBbJMd4xW6AU/drXxOWdd8oIGEzwYDBDAMRxizLxm4kxE/vbly4lzndq4Bkr
         kmQAXmdu/6Oj0XTYAj56tfZ57x8z4p0+zy6eOdhDgamcuDup+Jusz32qoydYuAKQ7byl
         fYdSAOwS4QHDBlU8/IJDxeaYm9QV4pf8r+RuDuqwbAgrBxHoK1q8MptVl/BYaM7PgmKS
         9dwQ==
X-Forwarded-Encrypted: i=1; AKwUvBxpe+WL6Sk2zqHBbmGU3tQWfDDAZ8oboL6CTx708l9SFtA8oe5GWw5ZHSwhwosbS6tYlrnbi1nQZinpOw==@vger.kernel.org
X-Gm-Message-State: AFq9FYK0pgHFGLEK0aAJ8hAsSVAopusOQlxZJL2fhaC8Txrg2hwj8J/z
	tmZEqVwHPEOpsHt1db5XA1X4qk6++eWyiL7JnqaNmP1jYRNaznrJOOO1
X-Gm-Gg: AYBFou0QH7x+cvJuIAcaEJK4mktxzgt0CsXnf+XLNge6bl9c4/8F17/wPl+/rnU4VQg
	zHXYFWppmA4wenz7zXk8Zp/Y/ze+uuqulynLf7INPUmSaAHe8eYW+g9ztrgQ+YqR1C83eMB9wOH
	opOF4/IQHxEdZ190tdtrQnZWVg4s65Ro67PW0J43xckMM2+1rWbFk7D6j6hiq+gOy79jhTn6rgt
	brdEddtrhuUbl1V7islGKSD/c/+XA0g/yAP/HL8s33xvYjMr+kZhtwANU5rSMi9lvyeB92ITGf5
	kmmSpL5e7Ec0rXfRd1YrfzfJenmpXi4u66mlqViiCDsIpIcdnHN1rgD09uqElQ+QWEIfiecoE02
	mh6OA2SMMzwy2nwtqzebMTKjkhM/dDKJpvpSQkxRmsYRA+9Ty7a1I7EJ8DX/NVitLx/91/vZ0Rr
	o3BTMZNuNvBoXgrS323i+QXMmAq5orFd9h/QeH1UEl9VUt0DdF9ivD239Yxiw/h66seEdaxk1K2
	i2wPFKlbiw7BKB2xVLlzSIuFqjdgcml8mhpEquRCjz9EXnLKp0kDM05W3Tp7O0XLF9CBcXvZcq7
	CKG1pV+hzW/r/TbL1qoWem0ZDQ==
X-Received: by 2002:a05:6000:2304:b0:486:f9ea:796f with SMTP id ffacd0b85a97d-48e5d5a4195mr8378579f8f.41.1793221952869;
        Wed, 28 Oct 2026 14:12:32 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48fasm30209675f8f.31.2026.10.28.14.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:12:32 -0700 (PDT)
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
 boundary=ef721ab95fb5240873f3268166b2e5d67a30159a361b9b3396093633bbb7;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 28 Oct 2026 22:12:24 +0100
Message-Id: <DMGS4KQLY24Q.14MUTR6U93GIC@gmail.com>
To: "Pedro Falcato" <pfalcato@suse.de>, "koraynilay" <koray.fra@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Chris
 Mason" <mason@kernel.org>, "Jan Kara" <jack@suse.cz>, "Darrick J . Wong"
 <djwong@kernel.org>, "Sean Smith" <defendthedisabled@gmail.com>, "Andrey
 Albershteyn" <aalbersh@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261028134728.294127-1-koray.fra@gmail.com>
 <20261028134728.294127-2-koray.fra@gmail.com>
 <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <auILs54TUcWXf3us@pedro-suse.tail5790ac.ts.net>

--ef721ab95fb5240873f3268166b2e5d67a30159a361b9b3396093633bbb7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Wed Oct 28, 2026 at 3:56 PM CET, Pedro Falcato wrote:
> On Wed, Oct 28, 2026 at 02:47:27PM +0100, koraynilay wrote:
>> Add provenance time (ptime), indicating the time when a file or
>> directory was created. This is user-settable via file_setattr() and
>> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>>=20
>> The semantics of when to preserve this new timestamp are the same as
>> mtime, the idea being that there is a correspondence like this:
>>=20
>> ctime <-> btime
>> mtime <-> ptime
>>=20
>> so every operation (copying, moving, ...) that currently preserves mtime
>> should also preserve ptime.
>>=20
>> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
>> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
>> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>> allow ptime to be used with the file_setattr()/file_getattr() syscalls.
>
> Random comment, but: could this be doable with xattrs instead? I'm not su=
re
> where I would put the xattrs code (if in userspace exclusively, or if hoo=
king
> the VFS up with this, or if doing it on the filesystem side), but it woul=
d
> surely be less disruptive than modifying a bunch of filesystems one-by-on=
e.
>

Thanks for the comment, I actually wanted to include the "why not xattr"
explanation in the cover letter but totally forgot lol.

I actually have been using fully userspace xattrs[1] for a few months,
mostly for backups, and it "works"; but last week I wanted to merge 2
FSs (and have another merge I have to do), so I ran [1] on all files and
then compared all metadata/data between source and destination and
noticed there were quite a lot of files that didn't have the xattr set.
So I looked online and learned that xattrs only work on regular
files/directories, not on symlinks or anything else (and the missing
ones were of symlinks).
This is what prompted me to search more if anyone had already proposed a
new timestamp (instead of making btime settable) and found the linked
email thread from april, which gave me the excuse to finally work on a
proper patch.

[1]: https://github.com/koraynilay/btime-to-xattr

> This patch is quite simple, but changing btrfs, then ext4, xfs, etc is a
> mess, and inevitably you can't get these timestamps until you upgrade you=
r
> filesystems.

So yeah while I do agree it touches a lot of code that could create
problems, IMO this is the best solution and it would complete files'
timestamps like other OSs have (and this, I think, is necessary for
both backup/archival and migrations).

Best,
koraynilay

--ef721ab95fb5240873f3268166b2e5d67a30159a361b9b3396093633bbb7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCauJlOAAKCRDmj22qf5IG
XM7fAP9ndP88PL7Eqo6Vig804tPfrb6wBJOZQWGAifFB0IK6hwD/YzPGX0GZGF3x
jpAvJTnHPxC3rS9RbTeSHSP+qDz7igE=
=GcKG
-----END PGP SIGNATURE-----

--ef721ab95fb5240873f3268166b2e5d67a30159a361b9b3396093633bbb7--
