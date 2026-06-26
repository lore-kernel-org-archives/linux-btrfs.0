Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C73E4514
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782465692; cv=pass; b=HYMrXiDc2pVUC+UX+w6X85zL+zdf0i2hJML9J0PEKTVWRXz6pwj29DIfQxjFbJ9TD5hL00MwADn/37BAB1F3aIMji9qKL9jspdEK/jXO21CYg4xpNq2xg8ZJp9fCgB7Fr1adjpnrc6SkYn9769Qv78yP3cjK5soRd17cMlHKcMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782465692; c=relaxed/simple;
	bh=bvIRpfaE2FhdfeaB7ubvMJed0qYIbSsTK1leRCCgOCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MI3fOX0S+1L4r5k4qP8Ld3sGGUlAgq82bnWINTxcE9/tHJhldJu9S3jJ5saKo60+MZ4VQxrlJIv+0DzDb9KlG2c+8M+vPAXzqBv2hZgKsy8wOw+6pD+8ZKI84u9Te2UxNMpbnB38uXqQfShZFTQ4OX9wohSXAfgVLPa9A+OT5Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=M51J8xHg; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="M51J8xHg"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69532288224so1589636a12.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 02:21:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782465690; cv=none;
        d=google.com; s=arc-20260327;
        b=OJREF2Vh7gBydrT3s621SgAw54flEuxWKLzo4kD/Avdy9SUFmLYG5jiBRY1gL3ms6X
         rK7QQVDsQKBAM+K5I1Xpw6jQ5Kc/fz5Dhcn464nLny1cqfCci+f+XkU2cdHkI7C9IBfA
         sOojUuzZ/PNUR2z7pqngzxcOAFHfKrZbNXvupifCcperqpwMotlAGk6RBINKnUpYMADe
         Fza7l7C0AokTqHljomudwhEzbfd/b5+PD9yOXLvCAifCkaqKhnWBmMKRKe5yw+nSdmt0
         hxV1QX2jjmyAByLSfF12Z8WyXCGy+kADLZG4fQ3FHUK3/C/AvlOcRarWQkDncJ5d9/6k
         +8qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jge6G4TAFPrvXC1QniyTn5PKiUjUotDtBmFXmgksvLI=;
        fh=Oj4aAYRAGwAy7lx0e3HF1dBV6o0EGOnPr4Pfl0mW7R4=;
        b=bskW9uSMxYjV9MnkfM+Jt+RI26pUU7opHcjDKYP8R6cZ1GBC24OpDYjAEuvrD3sZQQ
         Wg7DNwmBtbjZeIhGrPLCKiPzYblZI1ZcuVvCSdsMmEh2Sfn2hHOKVtRi/5D6cR8Zyj17
         Vp07WzH49L+nTWfvBgr6gglD6fCp/JmkwNOfuiMg3RYiVN/aPM5co/OiSyiQma17Pe46
         6Ry2lvH5uk1Rt3wg5wFwiOFfCZa5Cq2gyV4HRrXpUgo+MrGEAAcL91ioWkxz3vrr4ZJv
         9VSS5xg/EBmEFRTiy8Yu7AzvREQ8zV3ETAoB+Uuv/A/aREpdxBPbFrNkxNGqvwbqE93k
         9FRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782465690; x=1783070490; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jge6G4TAFPrvXC1QniyTn5PKiUjUotDtBmFXmgksvLI=;
        b=M51J8xHgnSJw1d97nhaQHEQLIZNc0u5DMVqyZRFBseNJ0/HkfVz0+7raqx74GOxLtI
         bwlOnrL2MmSOPPa6czhVl6FoCNx/OW6pFrkdsJEmvsVGtxE7zFsyRGxFE3MC/XGrk3ao
         y+kVzHRP86FYtnzz88Jktp3bbgEPHOugEMpODO8bIftVAzqfuMGU2GUTEugJZFpjTbh/
         PsJKxVz/BfcCmTae6QT4DTpIPo51hL59d2y3vEUdfsAIMQsnLjthBZVAQMIa/KKPlq4Q
         7seaS6ucBHdBKwAve66tyIH1umvSiK/J9swj3jtOKiv6zdA+Cei5Chm52jPhv1ocN42R
         jW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782465690; x=1783070490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jge6G4TAFPrvXC1QniyTn5PKiUjUotDtBmFXmgksvLI=;
        b=oRczhwbmvacp6DcKTLK+znuRDHVZVa9sjM6VCpbtaYp3MedaIgkh4IxRZou8txp34q
         b/GtLElp+ALEMJ/CJk2q6JIizmVy+mSJy/m0pluAHHY++uHK/wXnbPur7p2nQt+TeEry
         bfO50+6/HfMBU7wsLqZW+saNouC6uHVejrAz/xPy5IVzumD5bdvX4fvZqYK1I3YQKLxi
         Im2OnVuP+I2SxKoy1pfcCRBxzyzgdXJkbmd1PVmG+DOOJtMfAY8LOPGRWAyFisX8A7aC
         2iaTriS4iiQHBJ1sfdPpD3E27UOaji0+ADVMKxthwDFVH2C0zrZXoBdbK18nFcGX3NOi
         Cedg==
X-Gm-Message-State: AOJu0Yxp9nn6bkIBcsLALinrziDguftBPKEUnu9W1Sw9Aqfs0Ox7tkAY
	lsomTeH1YtnlfolTiMWnA3faoj1g2IGl2Ps7Xa2zksmSbTpNsmh5jZPvDSpgEZHGGRcvgfGOzjl
	47lh9s47oedOdcebMJ/2X9j5qkT6574W5mMYrQt0hCQ==
X-Gm-Gg: AfdE7ckNvK2kGJIIagmt+mBrxOJPQGRERdaFAeoZgpo0vsR5VmibMW1vSbyRz0nRr7z
	0pKt5ZGJD+xNTg/gichYPBdi3y1c6//WtpRPJ5NS2v97VxMZW7E9gRPvhoCewJ8tc6rgbM6VXVM
	CkVMWttcR/jDWMqjowG59dltXZH8Vw8iusp824cYNRJ8qA37DheoBJpbhbeaSob19GruCC6lfgC
	9DNrxjCBPAk1MQiasVO8p/Ktu42JjSk07cRj1duiUg9FglwUlOz4Ir1EASZa2PDo5T8SH3YdvbH
	4Rq8o/v4LY/Y1ruiDyUmGNZRkRLMeQ==
X-Received: by 2002:a17:907:c445:b0:c09:2c22:16ac with SMTP id
 a640c23a62f3a-c1205f20228mr418020266b.48.1782465689600; Fri, 26 Jun 2026
 02:21:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260625-btrfs-readdir-v1-0-dd781a2b3965@flipper.net>
 <20260625-btrfs-readdir-v1-1-dd781a2b3965@flipper.net> <bbeac2f6-685d-4ace-b689-10d64c4e3ce5@suse.com>
In-Reply-To: <bbeac2f6-685d-4ace-b689-10d64c4e3ce5@suse.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Fri, 26 Jun 2026 13:21:21 +0400
X-Gm-Features: AVVi8Cfjpor4kVmvFDmltWs24y4yW5kbH4YQTBWs_yPanPJDk7g3J_iinR_jcyk
Message-ID: <CAKTNdwGH2OCWJ1A=jQWiLYQmxG8UFTBGwGh0Qno7OkUfxs4dtw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: btrfs: implement opendir(), readdir() and closedir()
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, u-boot@lists.denx.de, 
	=?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	=?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
	Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, Yao Zi <me@ziyao.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 10:38=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/6/26 02:54, Alexey Charkov =E5=86=99=E9=81=93:
> > Add support for generic directory iteration with opendir(), readdir() a=
nd
> > closedir() in the btrfs filesystem driver, following the ext4fs
> > implementation for opendir()/closedir() and the btrfs_iter_dir() functi=
on
> > for readdir().
> >
> > Signed-off-by: Alexey Charkov <alchark@flipper.net>
> > ---
> >   fs/btrfs/btrfs.c    | 92 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >   fs/btrfs/ctree.h    |  2 ++
> >   fs/btrfs/dir-item.c | 91 ++++++++++++++++++++++++++++++++++++++++++++=
++++++++
> >   fs/fs.c             |  4 ++-
> >   include/btrfs.h     |  5 +++
> >   5 files changed, 193 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
> > index f3087f690fa4..c647c8dedf4e 100644
> > --- a/fs/btrfs/btrfs.c
> > +++ b/fs/btrfs/btrfs.c
> > @@ -9,6 +9,7 @@
> >   #include <malloc.h>
> >   #include <u-boot/uuid.h>
> >   #include <linux/time.h>
> > +#include <fs.h>
> >   #include "btrfs.h"
> >   #include "crypto/hash.h"
> >   #include "disk-io.h"
> > @@ -159,6 +160,97 @@ int btrfs_ls(const char *path)
> >       return 0;
> >   }
> >
> > +struct btrfs_dir_stream {
> > +     struct fs_dir_stream parent;
> > +     struct fs_dirent dirent;
> > +     char *dirname;
> > +     u64 offset;
>
> This doesn't look correct to me, for an opened dir, we should have at
> least the root id or pointer, and an inode number.
>
> Not just an @dirname and re-do the path resolution again and again.
>
> In fact, I do not even think we should save @dirname here.

Thanks Qu, let me reshuffle these. I'm not a huge FS guru, so I was
just parroting what other existing U-Boot code does (ext4 in this
case). That might well not be the best approach here, even though it
worked for my use case.

> > +};
> > +
> > +int btrfs_opendir(const char *dirname, struct fs_dir_stream **dirsp)
> > +{
> > +     struct btrfs_fs_info *fs_info =3D current_fs_info;
> > +     struct btrfs_dir_stream *dirs;
> > +     struct btrfs_root *root;
> > +     u64 ino;
> > +     u8 type;
> > +     int ret;
> > +
> > +     *dirsp =3D NULL;
> > +     ASSERT(fs_info);
> > +
> > +     ret =3D btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJE=
CTID,
> > +                             dirname, &root, &ino, &type, 40);
>
> You just discard the most important @root and @ino.
>
> So what is the point here?

Thanks for the pointer, I will switch from repeated lookups to a
stored ino reference.

> > +     if (ret < 0)
> > +             return ret;
> > +     if (type !=3D BTRFS_FT_DIR)
> > +             return -ENOTDIR;
> > +
> > +     dirs =3D calloc(1, sizeof(*dirs));
> > +     if (!dirs)
> > +             return -ENOMEM;
> > +     dirs->dirname =3D strdup(dirname);
> > +     if (!dirs->dirname) {
> > +             free(dirs);
> > +             return -ENOMEM;
> > +     }
> > +
> > +     *dirsp =3D (struct fs_dir_stream *)dirs;
> > +     return 0;
> > +}
> > +
> > +int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **de=
ntp)
> > +{
> > +     struct btrfs_dir_stream *dirs =3D (struct btrfs_dir_stream *)fs_d=
irs;
> > +     struct btrfs_fs_info *fs_info =3D current_fs_info;
> > +     struct fs_dirent *dent =3D &dirs->dirent;
> > +     struct btrfs_root *root;
> > +     u64 ino;
> > +     u8 type;
> > +     int ret;
> > +
> > +     *dentp =3D NULL;
> > +     ASSERT(fs_info);
> > +
> > +     ret =3D btrfs_lookup_path(fs_info->fs_root, BTRFS_FIRST_FREE_OBJE=
CTID,
> > +                             dirs->dirname, &root, &ino, &type, 40);
>
> No, doing the same path resolution again and again is not sane.

Ack

> > +     if (ret < 0)
> > +             return ret;
> > +     if (type !=3D BTRFS_FT_DIR)
> > +             return -ENOTDIR;
> > +
> > +     memset(dent, 0, sizeof(*dent));
> > +     ret =3D btrfs_next_dir_entry(root, ino, &dirs->offset, dent->name=
,
> > +                                sizeof(dent->name), &type);
> > +     if (ret < 0)
> > +             return ret;
> > +     if (ret > 0)
> > +             return -ENOENT;
> > +
> > +     switch (type) {
> > +     case BTRFS_FT_DIR:
> > +             dent->type =3D FS_DT_DIR;
> > +             break;
> > +     case BTRFS_FT_SYMLINK:
> > +             dent->type =3D FS_DT_LNK;
> > +             break;
> > +     default:
> > +             dent->type =3D FS_DT_REG;
> > +             break;
>
> So it looks like u-boot only supports the above 3 types, and unlike
> linux kernel the values doesn't match the btrfs internal ones.
>
> In that case, I'd still prefer a proper convertor function.

Hmm, but the convertor function would still be the same switch
statement, and it's only used in this single place. Would factoring it
out actually improve readability?

> [...]
> > +
> > +             *offset =3D key.offset + 1;
> > +             type =3D btrfs_dir_type(path.nodes[0], di);
> > +
> > +             /* XATTRs share the key space but are not directory entri=
es. */
> > +             if (type =3D=3D BTRFS_FT_XATTR) {
>
> This doesn't looks correct again.
>
> XATTR has their own keys, they should not show up among DIR_INDEX keys.

Let me double check and adjust accordingly.

Thanks a lot for your review!

Best regards,
Alexey
