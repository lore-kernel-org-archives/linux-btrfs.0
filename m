Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E913B7A3
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2026 05:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782539995; cv=pass; b=Gwv2zqE879D71qydmuHORp8sJPEN1QCJXWN9x+9szjXwn/CD/NPzZJqILDodxmcUuep04B/bR/MW+qinm10fe9twrgFSL+iqaHX1QpP/SGf6NzvDVpfOTydEP+NSmiOTjzczSpkchiCGtvE5LQG6j7/oO2qlc8KVV2ncQ80ATyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782539995; c=relaxed/simple;
	bh=tB4SZpre35Tb5DjNL1P+JmO5F8oE26nhfvePSS2jUwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a9+k5PO/5pdAViTe+IoA9ToaBVf/vLHKmSxPZxiMcCB3gSfKSHcPpRwPqGqIUmKCewYZ/FuwDvtEps/y73y/pxiXs/ppcrv5WLHGwyi6hGdSZbjqaRufRGZluLQcV8i5UxcRyWmFe9cMFcC4jlfMMNyhzmYlJw8Pp6EHJsLsibw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net; spf=pass smtp.mailfrom=flipper.net; dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b=wHQJDNsy; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=flipper.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flipper.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flipper.net header.i=@flipper.net header.b="wHQJDNsy"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-693c69b97e7so3314860a12.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 22:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782539992; cv=none;
        d=google.com; s=arc-20260327;
        b=ba1Esj9K56Vw8Fet1OCAdvl3XoH5/yMM8O0+6ElJPCQk+rKl/WCbRi4+s1fNAjOJ3a
         v2notKJgXVpOD07rArAw1JpmDbPY4X6b1GICfOn1+EWHwhflF7Zk5tsDJervie9jHzLA
         IIrUvzY/Ks9KIzwldqSMKLjxX7gavLqYvfbRjCGwxP0WMD/7m3cM1wsh/3xd6lzeolfe
         cxIjF+/gypmYRdGHrgTs7/Ucs5kg96XHFy/CfauAceXvXgkuoV9vCEOeCSIYBvhEEXY1
         kqvlrLAgyjo2lgNX7GxL0e50lL2UKWl16SRkcDkbgbeatGOsx3aKTMDhi3IukYkVhjrC
         t42A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3JKBbDAKFHJRuZaoQJHSoT8GFtNjLpM9oT9HpgPx1tg=;
        fh=Vck4SA8E06ryMKvQOTjUKuKpa3Z1sy/igYcyK3e24JM=;
        b=HA0uc7jPobsnASgDQ1sRCSHJR+8mzmhvW8hdfbAFFssay7T7QW7vxinccT4aH1m40x
         F2PpHutkcrmYTHis1l9n1KgCdXAzqSmJ/8lYHFaHqqajuPlfklx51mMmF77/La6NzCAq
         aqERNn3NVdhihEMSozwQsluS1s5SSVLpRVb00ejUvSI7Otd8r0xnErUpjxWBnaVLQZaa
         fxXyoUaOwc9rjtMEykZO4VOypV6Uxq3ejI0EQiR9rMjGsJW0gBsMwJIVPDE0EhGe497D
         S/OdHuSJpeF8ubLF4ZyqEoDKgGrJGLOhE5DK1sMJNu2xoYASZVj8cxjbeGCxTU2aurx9
         AyEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flipper.net; s=google; t=1782539992; x=1783144792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JKBbDAKFHJRuZaoQJHSoT8GFtNjLpM9oT9HpgPx1tg=;
        b=wHQJDNsyGW0XrTTaCSgvyvXQ0iO7ROj1twap6hs99LYz5DK/vypvSD9G0B1FCbo6gK
         Vomv5CVrpH3Rl9RlWS/cOTzv1VND/Xny2O3bLuMHFPPgjxAmxwEdodliZVrJ+vJu4W0b
         xcVWcgYaeRnnYmRLT6Z/pXjM9unA59B6Betq33jnMlTrqjEQPIRchzEbK6hc8PMaSb0a
         7mNIGYRZTRjCMdPNKluovRK2I2CxqFdyEmVXgPeGjYxpv/uD4grLZ2B52Y0HwJGsQH1s
         8XMASjzSetUtd4pblO+u4C424s9Jc8vvBSrRRRs9yOJJwdCmfQRhf8dPazBB/WauP3+m
         rlSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782539992; x=1783144792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3JKBbDAKFHJRuZaoQJHSoT8GFtNjLpM9oT9HpgPx1tg=;
        b=WrGAvLt7LWH2W7tzFvK8jOuEnIVCbrJcLw+zT0VtgOxhZOt7qW8vEpa5k1oq772K/K
         oP2JNUadqX2cYJSNpU8Uq5OJj3hp3D9+djSWT7YPaGE3VwlJivLFWvX3BE/4IUmpRsdx
         r1w4RYKtYuMQpX0V8qOz++2Cj8wR65nQVhzoTtlXHK0tigmGy5bq1wofGYeODyO2zDLd
         3VwaBq5d9QJ3r8hp6dP2usjhRPGRoYhu+FLFPtqQgy0FEhrIZXiVrURKAPldOeyqNrU+
         330izeLUTxMPCSPTAYxkWwAzsm6eesvBvl1Ev2u7Z0AxZtLV7iUtHdy5/iEavg8N1t0C
         QybQ==
X-Forwarded-Encrypted: i=1; AHgh+RoSrIt9NQEN+ENOB01rfBNJ7tcvHR4CCUxgGn+kVsrssjOiz27bGw0NFg25B64P6w3p4iFmJgCQxiFE7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOmlM1nTVSvtq9qYtQntPw8jeu3QbN3Wl/mDmQA+2aOJLJa+nP
	2A5kuczjrDzrDf2IJVefHtDzWJ/7ozSTH8SeKQ4mamkxiR1M06DVgF3imQoFzZrUDybvnC2aLLK
	jawl9Wp/IjLH62B63SvjLFh/kedaxiobwS0w/Qu34oA==
X-Gm-Gg: AfdE7cnN8ACwnaHCk4QOqdtnDz+S5N6wPHBmCTXVDuVibA7rbbs7kmEXx9YJL0RdMJl
	s+/qwA4W+dvVT5Wc9vZrGIo0inAlx9AMdztk1fQGsLReAd4fxxl8MYVd3r11bs+5UF600BmdAyY
	Qxabf0JhGoCKUVjgMUX8hLZWmgQoLSiKeqLcGTTOsoRtu3E3M9zO8kn7CKZcVAu+u9G97irOxcA
	GZ82n0svPh/aIaTMsi+w9/lU2JE/eR3k677da1wR1J+AI6L48T6HYcpN/mM7UCjMbrDGgnWU8ig
	tLDc6HyOHUZbot/xvPtQi4r4RQIq
X-Received: by 2002:a17:906:ee84:b0:c10:1c55:8c4e with SMTP id
 a640c23a62f3a-c1205e7896fmr570502766b.18.1782539991980; Fri, 26 Jun 2026
 22:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
 <20260626-btrfs-readdir-v2-1-7dd43f72d1b4@flipper.net> <09eca73c-1f50-46b2-a307-76eef0408159@gmx.com>
In-Reply-To: <09eca73c-1f50-46b2-a307-76eef0408159@gmx.com>
From: Alexey Charkov <alchark@flipper.net>
Date: Sat, 27 Jun 2026 09:59:41 +0400
X-Gm-Features: AVVi8CcQPm_ZXAylGJpdx1I355VWn0TWOOa-Nt3eytYhyywARLCHf7On_OyDLLw
Message-ID: <CAKTNdwEdonby8W9=iD54Fw1UVH88CBmjf+3L9r-jCUfhZrxzpw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] fs: btrfs: implement opendir(), readdir() and closedir()
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, u-boot@lists.denx.de, 
	=?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>, 
	Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, 
	=?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>, 
	Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>, Yao Zi <me@ziyao.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 27, 2026 at 2:27=E2=80=AFAM Qu Wenruo <quwenruo.btrfs@gmx.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/6/27 00:48, Alexey Charkov =E5=86=99=E9=81=93:
> > Add support for generic directory iteration with opendir(), readdir() a=
nd
> > closedir() in the btrfs filesystem driver.
> >
> > Signed-off-by: Alexey Charkov <alchark@flipper.net>
> > ---
> >   fs/btrfs/btrfs.c    | 98 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >   fs/btrfs/ctree.h    |  2 ++
> >   fs/btrfs/dir-item.c | 73 +++++++++++++++++++++++++++++++++++++++
> >   fs/fs.c             |  4 ++-
> >   include/btrfs.h     |  5 +++
> >   5 files changed, 181 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/btrfs/btrfs.c b/fs/btrfs/btrfs.c
> > index f3087f690fa4..6f034861da90 100644
> > --- a/fs/btrfs/btrfs.c
> > +++ b/fs/btrfs/btrfs.c
> > @@ -8,7 +8,9 @@
> >   #include <config.h>
> >   #include <malloc.h>
> >   #include <u-boot/uuid.h>
> > +#include <linux/kernel.h>
> >   #include <linux/time.h>
> > +#include <fs.h>
> >   #include "btrfs.h"
> >   #include "crypto/hash.h"
> >   #include "disk-io.h"
> > @@ -159,6 +161,102 @@ int btrfs_ls(const char *path)
> >       return 0;
> >   }
> >
> > +/*
> > + * The fs layer closes and re-probes btrfs between readdir() calls (se=
e
> > + * fs_readdir() in fs/fs.c), freeing and reallocating fs_info, so root=
 cannot
> > + * be stored directly. The subvolume id and inode number are stable th=
ough, so
> > + * re-resolve the root from the current fs_info by subvolume id, which=
 avoids
> > + * a full path walk and is much faster.
> > + */
> > +struct btrfs_dir_stream {
> > +     struct fs_dir_stream parent;
> > +     struct fs_dirent dirent;
> > +     u64 subvolid;
> > +     u64 ino;
> > +     u64 offset;
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
> > +     if (ret < 0)
> > +             return ret;
> > +     if (type !=3D BTRFS_FT_DIR)
> > +             return -ENOTDIR;
> > +
> > +     dirs =3D calloc(1, sizeof(*dirs));
> > +     if (!dirs)
> > +             return -ENOMEM;
> > +     dirs->subvolid =3D root->root_key.objectid;
> > +     dirs->ino =3D ino;
> > +
> > +     *dirsp =3D &dirs->parent;
> > +     return 0;
> > +}
> > +
> > +static unsigned int btrfs_dirent_type_to_fs_type(u8 dirent_type)
> > +{
> > +     switch (dirent_type) {
> > +     case BTRFS_FT_DIR:
> > +             return FS_DT_DIR;
> > +     case BTRFS_FT_SYMLINK:
> > +             return FS_DT_LNK;
> > +     default:
> > +             return FS_DT_REG;
> > +     }
> > +}
> > +
> > +int btrfs_readdir(struct fs_dir_stream *fs_dirs, struct fs_dirent **de=
ntp)
> > +{
> > +     struct btrfs_dir_stream *dirs =3D container_of(fs_dirs, struct bt=
rfs_dir_stream, parent);
> > +     struct btrfs_fs_info *fs_info =3D current_fs_info;
> > +     struct fs_dirent *dent =3D &dirs->dirent;
> > +     struct btrfs_root *root;
> > +     struct btrfs_key key;
> > +     u8 type;
> > +     int ret;
> > +
> > +     *dentp =3D NULL;
> > +     ASSERT(fs_info);
> > +
> > +     key.objectid =3D dirs->subvolid;
> > +     key.type =3D BTRFS_ROOT_ITEM_KEY;
> > +     key.offset =3D (u64)-1;
> > +     root =3D btrfs_read_fs_root(fs_info, &key);
>
> You can save the root pointer into btrfs_dir_stream, so we can avoid
> subvolume root lookup for each dentry.

That was in fact the first thing I tried, but turns out that it
doesn't work because a root pointer created with one fs_info structure
stops working once fs_close at the end of the generic fs opendir
caller closes the fs and deallocates the fs_info structure, due to it
referencing trees allocated for that instance of fs_info. The result
is a synchronous abort.

Hence the comment above the btrfs_dir_stream definition and this
second-best solution.

Please let me know if I've missed a more elegant option!

Closing and reopening the fs at every call which the FS layer does
sounds like a huge overhead, but I must assume it was unavoidable when
the interface was designed.

> You do not need to bother the lifespan of subvolume roots either, they
> are properly released during the close of the fs.
>
> Otherwise looks good to me, except an unrelated question just lines below=
.
>
> > +     if (IS_ERR(root))
> > +             return PTR_ERR(root);
> > +
> > +     memset(dent, 0, sizeof(*dent));
> > +     ret =3D btrfs_next_dir_entry(root, dirs->ino, &dirs->offset, dent=
->name,
> > +                                sizeof(dent->name), &type);
> > +     if (ret < 0)
> > +             return ret;
> > +     if (ret > 0)
> > +             return -ENOENT;
>
> I'm not sure what is the proper/preferred/sane handling of end of directo=
ry.
>
> Ext4/fat returns -ENOENT, squashfs returned -1, erofs return 1, exfat
> returns 0 but without populating @dentp.
>
> Personally I found the exfat behavior more sane, but considering the
> caller fs_ls_generic() doesn't really bother the return value but only
> cares if @dent is populated, it should be fine either way.
>
> But still, returning -ENOENT will populate errno, which may be confusing
> for debugging.
>
> Anyway it's an unrelated nitpick.

Happy to switch to exfat-like behavior. I was only looking at ext4
implementation as that is likely the most widely used and tested in
various corner cases, but it sounds like either way should work.

Thanks a lot,
Alexey
