Return-Path: <SRS0=JEJz=MP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0F4C64EB8
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 14:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A672082A
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Oct 2018 14:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8qDA14e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58A672082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbeJCVnn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Oct 2018 17:43:43 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:42773 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeJCVnn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2018 17:43:43 -0400
Received: by mail-vs1-f68.google.com with SMTP id w16-v6so3386699vso.9
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2018 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=H8U841L+s0piP8xHhmoZQ9qMFkfdQbXqX5UGSw4dqrI=;
        b=s8qDA14ex6Y90pwIHEkyGVR7yywrYcMqtj4KVfHHljmIkqpaQtpw1U/6sebd7+QzWY
         CnzwFh6YpO4obSGU1Y1OaIa1pzjRgcOigvyqvlyNu26rZLW7/LNbc25IBFlTMrG/p/b8
         hhROkhophTlHkaY7WIsH5LHTtyKaoPMgIw+LaHIjIvIVnV779ABOlAKNPGdWTnRCeiY0
         1zPqa1KNdjxp4YAuMhdeAocsA+IXcAcJUcU0IO7noTAE7AIvT3pW3NkceJvM8hn1E5pU
         evX6i6zecokSXcJAovt3ZAwEQ3LA6r14LE/lY9KohIDojF21yLL43sc1WmDCVF6v4i72
         vblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=H8U841L+s0piP8xHhmoZQ9qMFkfdQbXqX5UGSw4dqrI=;
        b=l1x19fGdjMp6oxLF3AvysJj93EUNci800dsBx206bu8nd4i5yFo7SHAAZ3GPKFyW3G
         TzAeBLw45NEVDypcs2xDhUM83PcqMqeevrld7jk6lHfEo9sWxDf0wWUvefRmkePsuuwi
         7+cdzyb0sCh3wkIFi3TpX2spzqCo/658z/InmIwUTNkGHlg1nrZuZ3p6UZhCOgsb82iF
         YYY71yTmEavxRA2VCpB7SF7hCgb2ZjzICKV9uFJ3ojbIWXZ/awODk4E9aJ1+AeFr0Soa
         IOzK96TD7miCt1ulzfnyMB1D13cTQDGcuQ8acPUtpbYwgcMrDBs+4OOvkFIF0d12B0wy
         Zhtw==
X-Gm-Message-State: ABuFfoh5vmi9exAkqed1hT2GOdOzixx+u57GfG2zaxkwY/QhBVkY+UZx
        tXTThzsnEnyHsAivgD2LFSVhczqq36HSypnB55++Ng==
X-Google-Smtp-Source: ACcGV63BQPIOYmQo6lq85rKNUWhyZXpVs/l1IhRl8YVkEf9/fhzlpbXt0q2cteFgqzARod4OzJg65fmEd2y0BBF6wIs=
X-Received: by 2002:a67:8a82:: with SMTP id m124-v6mr705755vsd.206.1538578498509;
 Wed, 03 Oct 2018 07:54:58 -0700 (PDT)
MIME-Version: 1.0
References: <20180928111821.24376-1-josef@toxicpanda.com> <20180928111821.24376-19-josef@toxicpanda.com>
In-Reply-To: <20180928111821.24376-19-josef@toxicpanda.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 3 Oct 2018 15:54:47 +0100
Message-ID: <CAL3q7H4_Y93fD5DyS+W8ZFELZrv33XJRmwbKW8maHc9L8-O3Ug@mail.gmail.com>
Subject: Re: [PATCH 18/42] btrfs: move the dio_sem higher up the callchain
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     kernel-team@fb.com, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 28, 2018 at 12:19 PM Josef Bacik <josef@toxicpanda.com> wrote:
>
> We're getting a lockdep splat because we take the dio_sem under the
> log_mutex.  What we really need is to protect fsync() from logging an
> extent map for an extent we never waited on higher up, so just guard the
> whole thing with dio_sem.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks. However as David said, it would be nice to have a
sample trace pasted in the changelog (several fstests test cases
trigger this often).


> ---
>  fs/btrfs/file.c     | 12 ++++++++++++
>  fs/btrfs/tree-log.c |  2 --
>  2 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 095f0bb86bb7..c07110edb9de 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2079,6 +2079,14 @@ int btrfs_sync_file(struct file *file, loff_t star=
t, loff_t end, int datasync)
>                 goto out;
>
>         inode_lock(inode);
> +
> +       /*
> +        * We take the dio_sem here because the tree log stuff can race w=
ith
> +        * lockless dio writes and get an extent map logged for an extent=
 we
> +        * never waited on.  We need it this high up for lockdep reasons.
> +        */
> +       down_write(&BTRFS_I(inode)->dio_sem);
> +
>         atomic_inc(&root->log_batch);
>
>         /*
> @@ -2087,6 +2095,7 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>          */
>         ret =3D btrfs_wait_ordered_range(inode, start, len);
>         if (ret) {
> +               up_write(&BTRFS_I(inode)->dio_sem);
>                 inode_unlock(inode);
>                 goto out;
>         }
> @@ -2110,6 +2119,7 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>                  * checked called fsync.
>                  */
>                 ret =3D filemap_check_wb_err(inode->i_mapping, file->f_wb=
_err);
> +               up_write(&BTRFS_I(inode)->dio_sem);
>                 inode_unlock(inode);
>                 goto out;
>         }
> @@ -2128,6 +2138,7 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>         trans =3D btrfs_start_transaction(root, 0);
>         if (IS_ERR(trans)) {
>                 ret =3D PTR_ERR(trans);
> +               up_write(&BTRFS_I(inode)->dio_sem);
>                 inode_unlock(inode);
>                 goto out;
>         }
> @@ -2149,6 +2160,7 @@ int btrfs_sync_file(struct file *file, loff_t start=
, loff_t end, int datasync)
>          * file again, but that will end up using the synchronization
>          * inside btrfs_sync_log to keep things safe.
>          */
> +       up_write(&BTRFS_I(inode)->dio_sem);
>         inode_unlock(inode);
>
>         /*
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1650dc44a5e3..66b7e059b765 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -4374,7 +4374,6 @@ static int btrfs_log_changed_extents(struct btrfs_t=
rans_handle *trans,
>
>         INIT_LIST_HEAD(&extents);
>
> -       down_write(&inode->dio_sem);
>         write_lock(&tree->lock);
>         test_gen =3D root->fs_info->last_trans_committed;
>         logged_start =3D start;
> @@ -4440,7 +4439,6 @@ static int btrfs_log_changed_extents(struct btrfs_t=
rans_handle *trans,
>         }
>         WARN_ON(!list_empty(&extents));
>         write_unlock(&tree->lock);
> -       up_write(&inode->dio_sem);
>
>         btrfs_release_path(path);
>         if (!ret)
> --
> 2.14.3
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
