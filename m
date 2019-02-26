Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4768CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 12:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B44C217F9
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 12:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kt5q0edA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfBZMI2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 07:08:28 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:45653 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbfBZMIW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 07:08:22 -0500
Received: by mail-ua1-f67.google.com with SMTP id u1so10837810uae.12
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2019 04:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=2R+2dB4cSYyvfDsMe2DZ3xfh2kG49mR3WcILORCQ27c=;
        b=Kt5q0edAU3k7W9Er4hJIWfs9ccHDs2115i8amRh6vZyhKq41MzCj2fm5ik4/LI19oX
         WWINMs1ZF/D/M6E/32+LKRURUOlpECWOHaaCpwXSyRnSWc1Lc5cq15GnvG6V6f6zzhh8
         68GhFvgMNt2NZdQ8rYgufKlVQVtMNMlwKBnwAuAqrBIfbDtR66YBEp3ETnhkfsgPPy2T
         nyUzI5OdhlDXD77+JyRC+GeZ72NzqgDaJAaP2eRiRf9frPKIL+3M+VX4jWM+PJ3iTVWm
         vaHKb8JRsWOHu2itbg6ni6f+lCBS//08jWR2Ww/9jrwAADHMHXzaFN9fHjNlaWRSXptd
         lGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=2R+2dB4cSYyvfDsMe2DZ3xfh2kG49mR3WcILORCQ27c=;
        b=Uc61c9A+yu/hPTorp6JM/9rpTfZw9kHFCBDB80yOnG4QJ61LwYuVjIzRoyI6zf2uu8
         vg6wLAmfX03d5bhHZqNYxzhID1i6f0UtjZo96OpcrSSUOWF1yj2tg7GTG1Dlc0tcmcKu
         WWcueiPxZ1zqbSCBdfGwqb+2yYphiG+JdraNnzEujcptj5RWKIYTLsoAP2IlTLyTuwY+
         yDy6C0XfbRi4phr08wIfuMLwmoXp/6o/1/FFUSOy6VrRIQZVVxGUX7MZgwUIV519GElg
         lwZZN7/8TeBe7+jfIZw42+racwy1LE+lsoziFXWn9xisZTWop2cOx/854lYXnfSS7f2V
         z8gA==
X-Gm-Message-State: AHQUAuajJs0P45hFhTQIX/2vqaE1Y0t97FKBVUDoC7hukgoSC+5Yhhl0
        duavSD/8Fv509qacszA5Qm9Hqz5QMhIGtgQ0kXZszg2B
X-Google-Smtp-Source: AHgI3IY94fX32uvko/FNQDHLzZbvrJwZZjDI6E4Pk2ScredsWI8yx02wmbPoh0KYrT8eUlGqW4FBZp0T/zXt5Xiwgfo=
X-Received: by 2002:a67:5e86:: with SMTP id s128mr12107760vsb.90.1551182900506;
 Tue, 26 Feb 2019 04:08:20 -0800 (PST)
MIME-Version: 1.0
References: <20190225190744.21664-1-rgoldwyn@suse.de> <20190225190744.21664-3-rgoldwyn@suse.de>
In-Reply-To: <20190225190744.21664-3-rgoldwyn@suse.de>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 26 Feb 2019 12:08:09 +0000
Message-ID: <CAL3q7H4JXORsxn5LB2ZK2Mg2wSyZcSgq3P4zFavN-nLQyn2V-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: Perform locking/unlocking in btrfs_remap_file_range()
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 25, 2019 at 7:08 PM Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
>
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Moves code to make it more readable, so as locking and unlocking is
> done in the same function.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/ioctl.c | 53 +++++++++++++++++++++-----------------------------=
---
>  1 file changed, 21 insertions(+), 32 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9c8e1734429c..f0ae1af91ff3 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3975,22 +3975,6 @@ static int btrfs_remap_file_range_prep(struct file=
 *file_in, loff_t pos_in,
>         u64 wb_len;
>         int ret;
>
> -       if (!(remap_flags & REMAP_FILE_DEDUP)) {
> -               struct btrfs_root *root_out =3D BTRFS_I(inode_out)->root;
> -
> -               if (btrfs_root_readonly(root_out))xfs_reflink_remap_prep
> -                       return -EROFS;
> -
> -               if (file_in->f_path.mnt !=3D file_out->f_path.mnt ||
> -                   inode_in->i_sb !=3D inode_out->i_sb)
> -                       return -EXDEV;
> -       }

Why move these checks?
The goal of the _prep function (both btrfs and vfs)  is to have the
checks for all needed conditions in one place.

As for the lock/unlock, it follows the same pattern from xfs
(xfs_reflink_remap_prep and xfs_file_remap_range).
No complaints about changing this, I'm just neutral about it.

> -
> -       if (same_inode)
> -               inode_lock(inode_in);
> -       else
> -               btrfs_double_inode_lock(inode_in, inode_out);
> -
>         /*
>          * Now that the inodes are locked, we need to start writeback our=
selves
>          * and can not rely on the writeback from the VFS's generic helpe=
r
> @@ -4022,26 +4006,14 @@ static int btrfs_remap_file_range_prep(struct fil=
e *file_in, loff_t pos_in,
>         ret =3D btrfs_wait_ordered_range(inode_in, ALIGN_DOWN(pos_in, bs)=
,
>                                        wb_len);
>         if (ret < 0)
> -               goto out_unlock;
> +               return ret;
>         ret =3D btrfs_wait_ordered_range(inode_out, ALIGN_DOWN(pos_out, b=
s),
>                                        wb_len);
>         if (ret < 0)
> -               goto out_unlock;
> +               return ret;
>
> -       ret =3D generic_remap_file_range_prep(file_in, pos_in, file_out, =
pos_out,
> +       return generic_remap_file_range_prep(file_in, pos_in, file_out, p=
os_out,
>                                             len, remap_flags);
> -       if (ret < 0 || *len =3D=3D 0)
> -               goto out_unlock;
> -
> -       return 0;
> -
> - out_unlock:
> -       if (same_inode)
> -               inode_unlock(inode_in);
> -       else
> -               btrfs_double_inode_unlock(inode_in, inode_out);
> -
> -       return ret;
>  }
>
>  loff_t btrfs_remap_file_range(struct file *src_file, loff_t off,
> @@ -4056,16 +4028,33 @@ loff_t btrfs_remap_file_range(struct file *src_fi=
le, loff_t off,
>         if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
>                 return -EINVAL;
>
> +       if (!(remap_flags & REMAP_FILE_DEDUP)) {
> +               struct btrfs_root *root_out =3D BTRFS_I(dst_inode)->root;
> +
> +               if (btrfs_root_readonly(root_out))
> +                       return -EROFS;
> +
> +               if (src_file->f_path.mnt !=3D dst_file->f_path.mnt ||
> +                   src_inode->i_sb !=3D dst_inode->i_sb)
> +                       return -EXDEV;
> +       }
> +
> +       if (same_inode)
> +               inode_lock(src_inode);
> +       else
> +               btrfs_double_inode_lock(src_inode, dst_inode);
> +
>         ret =3D btrfs_remap_file_range_prep(src_file, off, dst_file, dest=
off,
>                                           &len, remap_flags);
>         if (ret < 0 || len =3D=3D 0)
> -               return ret;
> +               goto out_unlock;
>
>         if (remap_flags & REMAP_FILE_DEDUP)
>                 ret =3D btrfs_extent_same(src_inode, off, len, dst_inode,=
 destoff);
>         else
>                 ret =3D btrfs_clone_files(dst_file, src_file, off, len, d=
estoff);
>
> +out_unlock:
>         if (same_inode)
>                 inode_unlock(src_inode);
>         else
> --
> 2.16.4
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
