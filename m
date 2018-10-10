Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45F4C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40DEE21479
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XApas3d5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40DEE21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbeJJOHy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:07:54 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:35944 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbeJJOHy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 10:07:54 -0400
Received: by mail-yb1-f195.google.com with SMTP id 5-v6so1777066ybf.3;
        Tue, 09 Oct 2018 23:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vz+7XhVMzFhyIq1lS9yP6TnlkcNOakFSEsU9WxxAfqo=;
        b=XApas3d5hIqSPYbNXt2SceIRdBCqqWhE46+cGY7AeTcoYEZ/t2R2UICfKxyoKAwEiC
         E9a1pd8uI6EnT50lu3Fg6uKoPZG0oGHoJcQl9iMgGOpYgSG+CvnlEmQiPHX/5SAD7+C2
         bQpcL3Y4/erI7DOxVN292CtUGbUWgQsHZ+8z/0HthdoL4Cw0j6s+Q6yKHffmt7via+dY
         m4+YywFeGHEoVmqdY36d9Pod2AZAnvZd2rIJ7cW9DBTdbWFSjB/YjjAmAlYj8Hv9NiKx
         KmD5w7ZsM0/kWEK2fgnSsKK1BMVys6Vieq7s5/0vH8/A/XSLIXViaOzM91g40RZEZbEZ
         +mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vz+7XhVMzFhyIq1lS9yP6TnlkcNOakFSEsU9WxxAfqo=;
        b=FdP6wN4mlOKsfZzT/PlvTWp5npDFU/o8H/ar4eRetaeZT75EFfNleaJ5rjs4SaW46v
         OF8nnNYIVo8kaet4bpCzBF60Re+WFqkQ9AcbwPYO8lxxBwwRmj99trCsS84TmWskWC8+
         4tRoGinnf5MJICSFwIvEn0S4HrXY5RmrOuNQjrbKmTSqB3P7BkM7dQvqhvs1PRcd88k/
         Xv8fJAvMan1NgwW6MLWCX2PDJ2tZGc0arkoO/Y4hdfNPOqSmlX4I/vL63hkaE/3RaIoK
         Wu+SAKjPFf6FVmN68/M6udXNwY8pqMmOzmzAsF+B0aZ8gdi+RfynSN42W8tGGt6MWkQO
         Ot6w==
X-Gm-Message-State: ABuFfoiQKHFrQDYe/bmhNpzdfGxfbKPuNO2gqLj2XACa3aYO2rVHuj55
        aELnW+pZGfKVNE4fF5RRKD5Z6jf1VM9y+q4wHqM=
X-Google-Smtp-Source: ACcGV62QwG/t4AVhNLVqpRJ1jYmXr1uMqgbMDI4FEHKoani4734xczEwNqT0oZI61PxSE1L+yJeHfokokCEHvDFXJ2E=
X-Received: by 2002:a25:af94:: with SMTP id g20-v6mr17932700ybh.320.1539154031087;
 Tue, 09 Oct 2018 23:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913040858.32295.9474188640729118153.stgit@magnolia>
In-Reply-To: <153913040858.32295.9474188640729118153.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 09:47:00 +0300
Message-ID: <CAOQ4uxg0=EJp1WJXmUeHT05yF1txRKKhPHVTWeG+rdtRD5FfHA@mail.gmail.com>
Subject: Re: [PATCH 14/25] vfs: make remap_file_range functions take and
 return bytes completed
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

On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Change the remap_file_range functions to take a number of bytes to
> operate upon and return the number of bytes they operated on.  This is a
> requirement for allowing fs implementations to return short clone/dedupe
> results to the user, which will enable us to obey resource limits in a
> graceful manner.
>
> A subsequent patch will enable copy_file_range to signal to the
> ->clone_file_range implementation that it can handle a short length,
> which will be returned in the function's return value.  Neither clone
> ioctl can take advantage of this, alas.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]
> @@ -141,8 +142,8 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>         }
>
>         /* Try to use clone_file_range to clone up within the same fs */
> -       error = do_clone_file_range(old_file, 0, new_file, 0, len);
> -       if (!error)
> +       cloned = do_clone_file_range(old_file, 0, new_file, 0, len);
> +       if (cloned == len)
>                 goto out;
>         /* Couldn't clone, so now we try to copy the data */
>         error = 0;

This error = 0 not needed anymore, but not a big deal...

> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 693bd0620a81..c8c890c22898 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -434,14 +434,14 @@ enum ovl_copyop {
>         OVL_DEDUPE,
>  };
>
> -static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
> +static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>                             struct file *file_out, loff_t pos_out,
> -                           u64 len, unsigned int flags, enum ovl_copyop op)
> +                           loff_t len, unsigned int flags, enum ovl_copyop op)
>  {
>         struct inode *inode_out = file_inode(file_out);
>         struct fd real_in, real_out;
>         const struct cred *old_cred;
> -       ssize_t ret;
> +       loff_t ret;
>
>         ret = ovl_real_fdget(file_out, &real_out);
>         if (ret)
> @@ -489,9 +489,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>                             OVL_COPY);
>  }
>
> -static int ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> -                               struct file *file_out, loff_t pos_out,
> -                               u64 len, unsigned int flags)
> +static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> +                                  struct file *file_out, loff_t pos_out,
> +                                  loff_t len, unsigned int flags)
>  {
>         enum ovl_copyop op;
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 917934770b08..f43b0620afd4 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1589,10 +1589,13 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>          * more efficient if both clone and copy are supported (e.g. NFS).
>          */
>         if (file_in->f_op->remap_file_range) {
> -               ret = file_in->f_op->remap_file_range(file_in, pos_in,
> -                               file_out, pos_out, len, 0);
> -               if (ret == 0) {
> -                       ret = len;
> +               s64 cloned;

loff_t?

> +
> +               cloned = file_in->f_op->remap_file_range(file_in, pos_in,
> +                               file_out, pos_out,
> +                               min_t(loff_t, MAX_RW_COUNT, len), 0);
> +               if (cloned >= 0) {
> +                       ret = cloned;
>                         goto done;
>                 }
>         }

Commit message wasn't clear enough on the behavior of copy_file_range()
before and after the patch IMO. Maybe it would be better to pospone this
semantic change to the RFR_SHORTEN patch and keep if (cloned == len)
in this patch?

Thanks,
Amir.
