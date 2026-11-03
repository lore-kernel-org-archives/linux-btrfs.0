Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793718889;
	b=x+w98oxKEvJpOKk8lPR3dx780gKv8TSiW0XQWoM48eHJC5hzmw2A9Kcaj4iNYFfHTl67
	 8ZXLVMdDKSxcVWHuS7Q6MljWw1nj+znTZJCfmdBQwohGh21pgpc+Z4/jguVypUCHNCGLN
	 yjA3YkAtXbTzMZJx3ktDJsZd6/TpB+OTO2swSkQSOMIbbYD3yaBhV7nId8X5CO6Di0oAY
	 RNCJk30Hdi6N/IWXbEcdyOh+Au/ekjbPa4mwhKLOmD9eYYingv9XFWbqSp7HoeUfEygh6
	 fZEl1YnY/KkTiSY7ndcmizMzxM/y92fjWveJQh804DxKgtf4VfwM8XqPO3ii/qCQKaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718889;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
	b=pAa1VujX9PADoq8hsNbblrpr/sYGikTAEdE9Gaf7zYmc9SYEfd+t1UGCc3+osrJBhCti
	 CVPvMKoqC3KjqcGGozxtgRHV2aOQNQp2kHJHz2uvEBCDwn+qdTvcAU6ZVnkqfitDH2AWM
	 OeuqpK2UhaU8ejONFQES6f54npsZZNwQoA8CKVOeizwmKaamm5UhfiobOm3wPZFbAIohi
	 o+9+kDAcZ+5zfbAvwUuLhqfrk01gdYWa1UCMP1Cyvu/C7475ysp5QojnSoEKPEe19Hyxs
	 uSn554nuAR7bWtlEUDJIswN4eX2pXN1OECKD2d9OC7jm4UvTXeWym6xoOBvnGrQiKvw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAw1L019;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7519D606EE8B
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7519D606EE8B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iAw1L019
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b4b7dee316so4158379a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:14:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793718888; cv=none;
        d=google.com; s=arc-20260327;
        b=GcpTqa+5wcnNAOLPtvQipo2ipfdo4VHFiGaG0rh6x4Bj2DQmjYO0dBxIChHIYdUVPW
         HCwnzzO7qUMoKO4cCo+u6G0DaF/ljVeabCxtAu11lffaxpCLfZta+NUkK5wCAIaxQoUG
         zEqyxz9/BOxlF6xjzRgVVOo7VyuPXSMe1HrotIhJO+3S12f9LhwQaJgRkYXIp2VZQ9+K
         2Ax9Cl8my0Ks8Bwt9DeuQYJ3UbaBwIukFSZf1xAbbKdbNUWRFD94uK+m73xYD+kx6lRZ
         hhU9nsjW9Y8TU5nQ4qwDLJ9gOLORaU7wULNf7hgjLbEC1TIPjRRKKttnLyvZFhKQgpTI
         Cqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        fh=fEgxkkWqXvNjLhWKFZTIRB8bkizgc60B6zU6nGLul2U=;
        b=hnicCUKehfjIYA44StEnMhwy0V7tMP/ELKnvPHEuPndYVvB2+1fgvQR/j3zl/qnk6y
         KgLhsWJiIPY8T7bHecuL9hGS+04Nj48qj/TgdClforFtCRg29XlLbv0sPvglIshc+ZTw
         CZzNbZSt0sa74SwtUkf+iORNTC5TTQXj79xTXJgp8YnKKP6Ddj9CThqCwzURHmfn3idc
         w4VKcYdzS5CL0KOoonzrIUF84bw16fBO1XfWzf5EDU+ggt/inC7bJ+YkNGpWircaLQ5k
         VTS2XJNjluILhEQh0Nnb0Dmxf2ptpVvCDIBTmCLHFC/zAfH/B+UN1V9PakAPNcE/TBcu
         kkBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718888; x=1794323688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        b=iAw1L019pbEECqKdWoucVoYt8cFM0CJimSPA3rGm9rZtMZpD0LGCCG5hkH3c1GOMpf
         IspJYDJNQRBAf5O6qxCrg24PZgTtDkgCcJNc+Te/FaLgF/P2D2ygdPGcLtFbCUaY0gnX
         nmK4XIqfh/wBKe13PTQ3kpyVHbCepAgmJlXpEqP8L3+CnEReQhrjzuddQkWkPc8aT2Ew
         WXWATOtMwvJL4pflCNbceNHwqDeFvIKJFx0h/Vg6B5F579r0iqYdPkfD5EDX+IkmrfUS
         8lO3wA9EaUVodg+Hln22pbunmgEx1YJidGyr6Qo2rLI9Snk3VNHTBqzw5kVIPPr31SEA
         cHng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718888; x=1794323688;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QDUu0ipWkEkr2evKB+VQexo3kZhP7laIpcWU434jcM4=;
        b=lhWiRKcbvGxDepuEtXYhXUzQNcpn//RhKOEN6EJ3Yi2+hbfEZM3d4OXXN9eOPeCapi
         EgRU7zty3c/8z+aP3r/KEG081iszGJ5qwfN6V7rz7WoNHGBpM3vPAF4fRX5NH3xamjIE
         IN6BBAxxBOJ0jcPivtFkq9IioeQJlNjZYBAD58ytRonjH3b7L8o/Gvy7wLw76qjE3ygV
         rDGYR83R2XsGkSe8vKsyUaF2e+c0GPzyZdw8z6Id0bX/k4rDsyAK7lOJPcVyq9MineTv
         6JGr9IJMtbhsOejhZrN2ibu8TDh47jO4IoGnpF1/Ma8wuLBo26BnCI4aJnSBte/tjUxP
         KEkg==
X-Forwarded-Encrypted: i=1; AKwUvBzf65d6jsg32PQd/6JXM5n03JvFyhunaFc5TTjehqwCVkomHrJ4RbM6VOvT+Q4ZUmjhy1GdgWJy3mB0kQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9myjxZ7R+sxg4y3Rir0yvVnH5RRNheC6EbLb0ttEU+RmB2CSuZ
	FPEyEVNQYS+xsITQRXlikDRg6JZ08AwpONWW2ygmwQqs2sXW4Y7c4qAz35XyjuicDk+lZ1QLtAs
	GWKy+xOTReupudXH3KeMWJmY9vXBEoEY=
X-Gm-Gg: AYBFou3tGa24YhjbNeVg36wHgC+HEr1esti8vwOOa8bz1I7P/F2X0oWUg6YF0n/STSu
	qWVHtYKFW4zjWqKm2qDf6A7vEWqIQsR+mK6JcgJr1zjRPYGyfO3jNOpXUTZUMaPwgGExv83Ul32
	PcvWgRdv1zLZM12ovh9koNkLneqxJk0cLQ7H0u/YiU5a0mDvbq4phIMXLlYWXIxtq8P0BicIEIL
	I8HRFPIhi5hpiLtY6KLCtBLM/6fDgwnC/1PlghBFAo/QadZvGMlYprCuhu9o5vz6EDZqa5APF5U
	+NQqqHRwQCfkNW5LcdzTQhDMJn9uj4E05DWjD2RCk+nTLZoe9RB2Dmik+JqVlx2Iuhzlpesu3hL
	9X36bKRSsoUjoKDvWzMXxzYQQylhWmnR7xruOsWGUjsWt6gPcgB0ZegZxI0MgL5MakP7SaCw=
X-Received: by 2002:aa7:d309:0:b0:6b3:f094:8ced with SMTP id
 4fb4d7f45d1cf-6b4d4683a29mr7344511a12.21.1793718887787; Tue, 03 Nov 2026
 07:14:47 -0800 (PST)
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101015551.786044-1-koray.fra@gmail.com> <20261101015551.786044-2-koray.fra@gmail.com>
 <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com> <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
In-Reply-To: <DMLJ5DR2A4KZ.28U8XSZ0KFJTG@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Nov 2026 16:14:35 +0100
X-Gm-Features: AclHuK-EjP75rU69csZK2uVzxHspULIwEcPYYUtLw5t3M157ApaMB9lhTx9MQvw
Message-ID: <CAOQ4uxiTS-QT7y1avNSasJSffkt2uRNkdrb2_GrK7kJ82-MoXw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] vfs: add provenance time (ptime)
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Chris Mason <mason@kernel.org>, 
	Jan Kara <jack@suse.cz>, Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <cel@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Sean Smith <defendthedisabled@gmail.com>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2026 at 12:13=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> On Mon Nov 2, 2026 at 3:00 PM CET, Amir Goldstein wrote:
> > On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com>=
 wrote:
> >>
> >> Add provenance time (ptime), indicating the time when a file or
> >> directory was created. This is user-settable via file_setattr() and
> >> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
> >>
> >> The semantics of when to preserve this new timestamp are the same as
> >> mtime, the idea being that there is a correspondence like this:
> >>
> >> ctime <-> btime
> >> mtime <-> ptime
> >>
> >> so every operation (copying, moving, ...) that currently preserves mti=
me
> >> should also preserve ptime.
> >>
> >> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> >> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> >> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() =
to
> >> allow ptime to be used with the file_setattr()/file_getattr() syscalls=
.
> >>
> >> [ This is a re-implementation of the initial patch[1] by Sean Smith
> >>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick =
J.
> >>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
> >>   utimensat() ]
> >>
> >> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@g=
mail.com
> >> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
> >>
> >> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> >> Signed-off-by: koraynilay <koray.fra@gmail.com>
> >> ---
> >>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
> >>  fs/stat.c                 |  2 ++
> >>  include/linux/fileattr.h  |  5 +++++
> >>  include/linux/stat.h      |  1 +
> >>  include/uapi/linux/fs.h   |  8 +++++++-
> >>  include/uapi/linux/stat.h |  7 ++++++-
> >>  6 files changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/file_attr.c b/fs/file_attr.c
> >> index 833e03810b24..c0645cb22bf3 100644
> >> --- a/fs/file_attr.c
> >> +++ b/fs/file_attr.c
> >> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
> >>  static void fileattr_to_file_attr(const struct file_kattr *fa,
> >>                                   struct file_attr *fattr)
> >>  {
> >> -       __u32 mask =3D FS_XFLAGS_MASK;
> >> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >>
> >>         memset(fattr, 0, sizeof(struct file_attr));
> >>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> >> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct fil=
e_kattr *fa,
> >>         fattr->fa_nextents =3D fa->fsx_nextents;
> >>         fattr->fa_projid =3D fa->fsx_projid;
> >>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> >> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> >> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
> >>  }
> >>
> >>  /**
> >> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
> >>  static int file_attr_to_fileattr(const struct file_attr *fattr,
> >>                                  struct file_kattr *fa)
> >>  {
> >> -       __u64 mask =3D FS_XFLAGS_MASK;
> >> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
> >
> > That is not the correct way to extend this API.
> > This fixed mask was added as a placeholder for
> > "We intend to add support for more xflags to selective filesystems":
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il=
@gmail.com/
> >
> > Please see this POC patch for filesystems to publish their supported
> > xflags mask:
> > https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il=
@gmail.com/
>
> Thanks, I did not think of adding a dynamic mask like that, I will look
> into it and implement it for v4.
>
> > This will allow callers of file_getattr() to know if the filesystem
> > supports ptime
> > without trying to set it and failing.
>
> So after adding fsx_xflags_mask to file_kattr, every filesystem would
> populate fsx_xflags_mask with all the returned (=3D=3D supported) FS_XFLA=
G_*
> in their own specific .fileattr_get, correct?

Not all filesystems. Just the ones that wish to extend the constant
legacy FS_XFLAGS_MASK.
So just the ones that you change to support XFLAGS_PTIME

Thanks,
Amir.
