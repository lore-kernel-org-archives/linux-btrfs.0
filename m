Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793628043;
	b=sBqsbOPlOzbBF7gZxhZnOvtYr7Iq7nSI7t9zN4ZnvmvQprpGDQtHesk2tq8exFR442l3
	 q5/XymAOJmVFgJ/RiU/lb/Yb8E01R2eeSkdn59RobeTW8dVhcZvLQUkpyIJ/AjPaCATqr
	 LS5OoB3s58DZRtnF5PKzJfLBDkuKLH3fuscqAUcE1BxJHJrwBW1aIF7LBefP3EsYye2O0
	 S7B3Z28bXYuiKXkU1uIQbclagSaACZ1i9kSzXsrq1/quFBqdXMGoOKAMpMvipWbgH+0X+
	 3VMwEuhZu3t+4UMpaCzJMVeNyO7FnhTrwkmCOfEiiH+GzbuIkwfR5/ZZP7o1Oz/+wXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793628043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
	b=u+XRMKbvrqEjt/88VtT/1CkkxAuQsB1QfHIOGaSPz74VzorM/Jc0UL4epNfZEsfaIB9H
	 68gHfVCBUFyfe3gLGcwxJXfIMJ2l6hmqq6/S1rI6nGuxy6MYzTUiXUyZEOfoHuQFI678p
	 NeLmeGVObnBYpW4+1iavx1QFlVeL5GsItF2NFX+KYgMxN6uvjtnxnxrNo6RII/OzFP/5L
	 tzdYbSj+4OnqWm3FBVjNB/cYM9HdnywdLraR5qjWm8H2HiFTNWfRVGD8bTOkO3k5Q742I
	 Xw0XaJALwiEao6X55J6OvlNHuaLLRbwKaOMsGFHIuc7tQxieFJdz7sDsiwzvRriGiSA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sqAIi+u2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6404F60A381C
	for <linux-btrfs@vger.kernel.org>; Mon,  2 Nov 2026 14:00:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6404F60A381C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sqAIi+u2
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so488624566b.3
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Nov 2026 06:00:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793628042; cv=none;
        d=google.com; s=arc-20260327;
        b=YRQm+6vcyjCeh4PojiXjXCV/DlLCQZrgkpBVQJ5PAgeu4S0L94OAxbG778OL2WG6h2
         RSjEcA7G7XGeuYO8bogsiPH694lZ28fcJYkbwsHGmAhAv6nSsejPLEU83faxG7g83yAN
         IKKyQQy8oh4sG1ZRCeNUxw8fo6nrjihpYPFkU3quVs6TegJEbefAdND+BNLWEm2k+7mE
         C2ra/zXZtI3SkL0QDWU9i5D2HqTdt0XGVQsP4lakXgg8KB1e4/JEfYBIBeP5Jhf7+oB4
         fU9rD+X2NeEHqBFbnOLyNOIMMsIBxaHB5CuzuPiEhZ7liWHV4MTZGX2k8CQv1W1gqk1Y
         1Eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        fh=0wB5V9PZAPO1BVL48x28XUvZ3atiJqpbpccVzAM9fUM=;
        b=V6kheHZIJGlKafolpvUJi7300+l6W+L0lx8mvigr1wIUNpSsSS2g5dftUOOW8uella
         fG2b3qSZVMoRBMpE5JsU+UQyTa2F0BGl9XtGe3tsaAWeZl5MAKCx+H9XFayOopjaPeMM
         9iGvmUHXUw46UyeoZ+8r2LaiffcslRHe1KkwjybYSb4Tnjw7cFA/0xTic2Ac5nDUtEeP
         gmJHfuXt1Yz2gt0aLtEQjuEkVLvEdHM+vnYtfIrPn977oNHn8ZBBnKstBDp6r+ABW8qF
         CZr4AdBVsJ63XMXuOLL4sSV/09byHJ4lRaTbisCBXOI8vU3vHwAIuRJNikVuShUk3Pu1
         nFJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793628042; x=1794232842; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        b=sqAIi+u2ogK6jCFX9j76dArnOThd5X0GCkPk+9VoPxB/STC2ao3yNQSapJ/76uyvZF
         UQeJMLj3OjZQ6jYb3yKYpQYBgapfOVjbaeH6XWMUdukR6YyyOJiZarpmEibYav80QQel
         ARzb1zBdJX680p6g7SYIcqKej0UMKNcuV/AzvXi9sTPGi/DS+5e8TNR91gHolVHyQs08
         0pb9QRYTbtnS9lHSmz2/j9UIRd0UCpD0n6qnEqh4x5brTozZCvk/gpLraes7Ilzx05Qt
         g2ZPufDM/NVNfGkokXFUysAeDG9pH92EnlHodWhDjFX58izRV8iTvo18CdxRQeNzpMZ6
         WV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793628042; x=1794232842;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5Xf4onWksy+tbgDhi+LvOuZ3PKtrfpCQRc1Tg6vJHg=;
        b=f1QdOb6/UFbD7YejoA/WFoBbq9FOrIaE+edK6iWp9cav97BAxOlGMetLSjNo1gkRKq
         9KtJV3WDAmBZgRSYC7/jY/czeUz3ALEg4IvI7xi69i4CERGpL/NAtZFJ0qZ6wtPN1LHk
         Y/rwD8d+JEwpruFD/QGYdjDMdenX9dn6jMr+vr/N5TDHgrUPrrIf6XO8Fc8gvqzlhcBr
         7oLUfmP95+aSUYRxPoCl6YElam6ama2V81C/Govm0jkKv59jTg45ht9BvFvChh1lunKU
         5HcgciZ75oHjTEDDMAhz6Y8Q1+T+k7KlP5OnJ0SvHpZUvdQwahvR50YFwtm/W+oTZNSe
         ZcAA==
X-Forwarded-Encrypted: i=1; AKwUvBxF7CriF5ppa3Om6X2qf0LJ/nsp5Q1+xEjqIA+qStbjC+Zwen2Xm2CyjOJoWjG0bUu3Att5ZG6TYfN+Gg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+qFxB8xFdCUtyMCbTDQSfOkkx28cjbRFrMNzIW0bnGrzvBR1JI
	E28GezGZchwRkWlnk8mlXp1LaykQBrCmzo0BjYmNwuDLDgoYlCG/WOm70GehTmuaUh8DCbrmcij
	oC/+C/3e7ejuJw+9ACIw6vcgFUt+Bml4=
X-Gm-Gg: AYBFou2/xjBCr0ict1DHrz+0LQvzJWroQSnxtFVojHTi11WKo7eOVVaBDZaS7JmC0R1
	wjatrxUJTw6RL4Cs4h1+WSc9C6GWrQAIRrOdAqZYeeQitfVyxrGSVv2umX/JpAGP6bRZQOm4Odi
	z6Fgv02BI/483MVLbTbi220sEnm7TSe6kwzzix4SZy4TcQsMOojLSpMdsFx74xStiLOj3MufqI1
	h/xzzMa0m6m0jGk9GQh+3OSXVEkaFunqPWuOOnaJG6x3iZ+H89GeuCeD/QYFjfaQOIE0lwSnqdk
	54nyR1ltdJJiwzR/4gyn6GbTsYL0PlsaH0LrHOyoA58QcroPPqYjO518v1tzKcx9FLNKLQI9el0
	0mMuG/rtXWCyjMd0I8703zNj9c0jxIBJBuVIxI2eNFU8SmLhy2TvkA3O2Gqh+8nLS9KEHMw==
X-Received: by 2002:a17:906:9f87:b0:c33:9fab:5f61 with SMTP id
 a640c23a62f3a-c4ca7a80dfcmr888696766b.29.1793628041476; Mon, 02 Nov 2026
 06:00:41 -0800 (PST)
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
In-Reply-To: <20261101015551.786044-2-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 2 Nov 2026 15:00:29 +0100
X-Gm-Features: AclHuK8C6KXo0yGTK4G9AdpXOF6ch7dlD0GPHOdparCBMVqSIwGLvVGFGi1BG64
Message-ID: <CAOQ4uxiuJ=eZu28FZAUz3rpqPKqCimPxJucOnYYuBowvD09_Cw@mail.gmail.com>
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

On Sun, Nov 1, 2026 at 2:57=E2=80=AFAM koraynilay <koray.fra@gmail.com> wro=
te:
>
> Add provenance time (ptime), indicating the time when a file or
> directory was created. This is user-settable via file_setattr() and
> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>
> The semantics of when to preserve this new timestamp are the same as
> mtime, the idea being that there is a correspondence like this:
>
> ctime <-> btime
> mtime <-> ptime
>
> so every operation (copying, moving, ...) that currently preserves mtime
> should also preserve ptime.
>
> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
> xflags, and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
> allow ptime to be used with the file_setattr()/file_getattr() syscalls.
>
> [ This is a re-implementation of the initial patch[1] by Sean Smith
>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>   utimensat() ]
>
> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gmai=
l.com
> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c            | 33 +++++++++++++++++++++++++++++++--
>  fs/stat.c                 |  2 ++
>  include/linux/fileattr.h  |  5 +++++
>  include/linux/stat.h      |  1 +
>  include/uapi/linux/fs.h   |  8 +++++++-
>  include/uapi/linux/stat.h |  7 ++++++-
>  6 files changed, 52 insertions(+), 4 deletions(-)
>
> diff --git a/fs/file_attr.c b/fs/file_attr.c
> index 833e03810b24..c0645cb22bf3 100644
> --- a/fs/file_attr.c
> +++ b/fs/file_attr.c
> @@ -102,7 +102,7 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>                                   struct file_attr *fattr)
>  {
> -       __u32 mask =3D FS_XFLAGS_MASK;
> +       __u32 mask =3D FS_FILE_ATTR_XFLAGS_MASK;
>
>         memset(fattr, 0, sizeof(struct file_attr));
>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
> @@ -110,6 +110,8 @@ static void fileattr_to_file_attr(const struct file_k=
attr *fa,
>         fattr->fa_nextents =3D fa->fsx_nextents;
>         fattr->fa_projid =3D fa->fsx_projid;
>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>  }
>
>  /**
> @@ -141,15 +143,20 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>                                  struct file_kattr *fa)
>  {
> -       __u64 mask =3D FS_XFLAGS_MASK;
> +       __u64 mask =3D FS_FILE_ATTR_XFLAGS_MASK;

That is not the correct way to extend this API.
This fixed mask was added as a placeholder for
"We intend to add support for more xflags to selective filesystems":
https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-2-amir73il@gma=
il.com/

Please see this POC patch for filesystems to publish their supported
xflags mask:
https://lore.kernel.org/linux-fsdevel/20250329143312.1350603-3-amir73il@gma=
il.com/

This will allow callers of file_getattr() to know if the filesystem
supports ptime
without trying to set it and failing.

Thanks,
Amir.
