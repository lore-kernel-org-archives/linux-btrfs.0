Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C984C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 05:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8956214DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 05:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pwFPEgtj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8956214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbeJJNP1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 09:15:27 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:44299 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJNP1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 09:15:27 -0400
Received: by mail-yb1-f196.google.com with SMTP id x5-v6so1721417ybl.11;
        Tue, 09 Oct 2018 22:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AIPyAezBiBBQMWQx3rs6hdJ0xEAtOKaqMMPbuXSEZBw=;
        b=pwFPEgtjiJt++6+ANUZbPOuYfkjEszNVj7fpau0awLanvs9qR6VORp2Ot4i5YY0KMd
         bJsfydiZZRktA6k2ysSniV8oiMMJSOtc38XgJTQA2+04ScmzqJKrIUt3xYAA8nqR59yB
         dN7Zkda+wokQTSoAMq6ng8TU1OQXQ7XOMnYDOsQr2Jp0KdHPWemH1Gox09GwfiC7BWBl
         hnEr53zNHhXh9wNX9jhIWLxFqGGiKW06DOUNZHHVCMMMAOaA21iQNOEaSNXO0VWLPKeP
         J+tdZ4dadp2CJ2Dp13H+u9OFvemKHyafiXfthKeOZkLLDgz8/sgbULq0GalIdhjfqreS
         vrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AIPyAezBiBBQMWQx3rs6hdJ0xEAtOKaqMMPbuXSEZBw=;
        b=t184ocbsjNVfITB1S9+LI9wgn9Fuj5iDHPYx42XBbXd7yTNK7bLgL6BZalDT04gWq3
         h9zPQMYx0ydK6oKzawV8hDWqgoqmYqfSepTa8OU77CdLS54lIyNk3Cs+ILy7cIvf/Hrm
         8nioaGw6QI84YQcBrImw+O51X9/Fp1S/86QJjx55fPhxzmA7yzAR2+B3Kbm0CthuYI3K
         piUy/tbIqg9IIdJzdkhx0ZqvzdgVD6mFukDf35BqUQpE/GPLBfI2EZb7sP/W1YPHNQnA
         aS2kG8T+GQQuqjl/Okp1Fai0bO1jptR3OC/o0LkFMBUMR0GkpIQ3YRFK+SgnnEa4k4Rp
         Wxbg==
X-Gm-Message-State: ABuFfoghOdWe4xwuIyOgUU6xOjTudltWt4qFnsruT8HvX5ofPOROJBZO
        hwgoken74AeqPt86HAxZBCF2V9lQ21DPVoDUORA=
X-Google-Smtp-Source: ACcGV60/TKSr4ja/eRwEX0blcYfOXfo5JUU0yJrP5E3l//spRdN1AtBF9kJ8Rl11+/j/wKu+sP+QeawzbAygAg1Qtak=
X-Received: by 2002:a25:5555:: with SMTP id j82-v6mr18321620ybb.337.1539150895677;
 Tue, 09 Oct 2018 22:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913029885.32295.7399525233513945673.stgit@magnolia>
In-Reply-To: <153913029885.32295.7399525233513945673.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 08:54:44 +0300
Message-ID: <CAOQ4uxj_wftoGvub9n_6X3Qc64LKxs+8TB-opUiq59sGQ=YoKw@mail.gmail.com>
Subject: Re: [PATCH 08/25] vfs: combine the clone and dedupe into a single remap_file_range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        linux-cifs@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Combine the clone_file_range and dedupe_file_range operations into a
> single remap_file_range file operation dispatch since they're
> fundamentally the same operation.  The differences between the two can
> be made in the prep functions.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

I like this. Nits below.

[...]

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index d60b6caf09e8..e22b294fa25b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3627,26 +3627,6 @@ static int btrfs_extent_same(struct inode *src, u64 loff, u64 olen,
>         return ret;
>  }
>
> -int btrfs_dedupe_file_range(struct file *src_file, loff_t src_loff,
> -                           struct file *dst_file, loff_t dst_loff,
> -                           u64 olen)
> -{
> -       struct inode *src = file_inode(src_file);
> -       struct inode *dst = file_inode(dst_file);
> -       u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> -
> -       if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
> -               /*
> -                * Btrfs does not support blocksize < page_size. As a
> -                * result, btrfs_cmp_data() won't correctly handle
> -                * this situation without an update.
> -                */
> -               return -EINVAL;
> -       }
> -
> -       return btrfs_extent_same(src, src_loff, olen, dst, dst_loff);
> -}
> -
>  static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
>                                      struct inode *inode,
>                                      u64 endoff,
> @@ -4348,9 +4328,27 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
>         return ret;
>  }
>
> -int btrfs_clone_file_range(struct file *src_file, loff_t off,
> -               struct file *dst_file, loff_t destoff, u64 len)
> +int btrfs_remap_file_range(struct file *src_file, loff_t off,
> +               struct file *dst_file, loff_t destoff, u64 len,
> +               unsigned int flags)
>  {
> +       if (flags & RFR_IDENTICAL_DATA) {
> +               struct inode *src = file_inode(src_file);
> +               struct inode *dst = file_inode(dst_file);
> +               u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
> +
> +               if (WARN_ON_ONCE(bs < PAGE_SIZE)) {
> +                       /*
> +                        * Btrfs does not support blocksize < page_size. As a
> +                        * result, btrfs_cmp_data() won't correctly handle
> +                        * this situation without an update.
> +                        */
> +                       return -EINVAL;
> +               }
> +
> +               return btrfs_extent_same(src, off, len, dst, destoff);
> +       }
> +

Seems weird that you would do that instead of:

+    if (flags & ~RFR_IDENTICAL_DATA)
+        return -EINVAL;
+    if (flags & RFR_IDENTICAL_DATA)
+        return btrfs_dedupe_file_range(src, off, dst, destoff, len);

>         return btrfs_clone_files(dst_file, src_file, off, len, destoff);
>  }
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7065426b3280..bf971fd7cab2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -975,8 +975,9 @@ const struct inode_operations cifs_symlink_inode_ops = {
>         .listxattr = cifs_listxattr,
>  };
>
> -static int cifs_clone_file_range(struct file *src_file, loff_t off,
> -               struct file *dst_file, loff_t destoff, u64 len)
> +static int cifs_remap_file_range(struct file *src_file, loff_t off,
> +               struct file *dst_file, loff_t destoff, u64 len,
> +               unsigned int flags)
>  {
>         struct inode *src_inode = file_inode(src_file);
>         struct inode *target_inode = file_inode(dst_file);
> @@ -986,6 +987,9 @@ static int cifs_clone_file_range(struct file *src_file, loff_t off,
>         unsigned int xid;
>         int rc;
>
> +       if (flags & RFR_IDENTICAL_DATA)
> +               return -EOPNOTSUPP;
> +

I think everyone would be better off with:
+       if (flags)
+               return -EINVAL;

This way you won't need to change all filesystem implementations
every time that you add a new RFR flag.
Lucky for us, dedup already return -EINVAL if (!f_op->dedupe_file_range)
(and not -EOPNOTSUPP).

[...]
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 986313da0c88..693bd0620a81 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -489,26 +489,28 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>                             OVL_COPY);
>  }
>
> -static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
> -                               struct file *file_out, loff_t pos_out, u64 len)
> +static int ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> +                               struct file *file_out, loff_t pos_out,
> +                               u64 len, unsigned int flags)
>  {
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> -                           OVL_CLONE);
> -}
> +       enum ovl_copyop op;
> +
> +       if (flags & RFR_IDENTICAL_DATA)
> +               op = OVL_DEDUPE;
> +       else
> +               op = OVL_CLONE;
>
> -static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> -                                struct file *file_out, loff_t pos_out, u64 len)
> -{
>         /*
>          * Don't copy up because of a dedupe request, this wouldn't make sense
>          * most of the time (data would be duplicated instead of deduplicated).
>          */
> -       if (!ovl_inode_upper(file_inode(file_in)) ||
> -           !ovl_inode_upper(file_inode(file_out)))
> +       if (op == OVL_DEDUPE &&
> +           (!ovl_inode_upper(file_inode(file_in)) ||
> +            !ovl_inode_upper(file_inode(file_out))))
>                 return -EPERM;
>
>         return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> -                           OVL_DEDUPE);
> +                           op);
>  }
>

Apart from the generic check invalid flags comment - ACK on ovl part.

Thanks,
Amir.
