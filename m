Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8D8C65BA7
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0152098A
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FCA5EDgR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED0152098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbeJEPEm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:04:42 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:39658 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeJEPEl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 11:04:41 -0400
Received: by mail-yb1-f193.google.com with SMTP id g15-v6so276261ybf.6;
        Fri, 05 Oct 2018 01:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AHTHDQQa2jCHVJCqU31xV4F6Wiq+klDmcALeqJZ64Wg=;
        b=FCA5EDgR+L9YfkOR+/N+I5/KUNIDf/4C1WOcJjvcbbFOKVO9DX1l+kD4EZgfXKFXV0
         iHV7qivS7Q42hRaGna1a3NQztIXxZyUjuLBhU+7y3Eb0goeZcpjEsDuWBOzVAdcTNfO2
         1A8s6v1Y2jZXp7/BWTr5d0miUu9o0JbLThvaCKSfGrsH8R5+xQI3hjXik2D6k8G7SGPP
         I1IIWPrKEaiU216YqQ+WiZ530ujYFrbgRKqJ73PVd0++Pzr+idc1J3IgTvD01KyffGmB
         voGayhbvh5mtRx+HFheE5H42Kdaoh08j7bSaNWe0mBwdpmw6s66pH2hDFWNzb2y6EkET
         xjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AHTHDQQa2jCHVJCqU31xV4F6Wiq+klDmcALeqJZ64Wg=;
        b=TWaUtVxBqssTL/o8cEmDaw4kXNScdJblKaYIMnycS4FHbP7VeSx7/KaQ2XZWGHLPhS
         pceM0GDpq7JoqDBc2YiTx3f5UwnnexuUrPf9owR4n33YAPMXf1KictESk+gnUQxbJSLa
         llAYfNeTeyOi2JWTCTWZS+31sCCInlVMPhEzGdMFOZUEJYkDRXrUuMsI4C+UJd9EZf/w
         KlbhRtr5aZWVyxwF4jw3nSeB7nQ8jTCbbENRrbbpCeOgaIik4O0T8QY/1/NDeFok9zfL
         0S46I59O2Pblo4dAjfX2JGt1Gp8uMtZCYVYBuvxAvxvJEj9fbWpnx4pHuIL5RWfLqFO6
         f33g==
X-Gm-Message-State: ABuFfoiqmfcBCpbfBLbvzZGVS00Ufrsrr7ow4LV3SNuTiy7Ae+Fc16PC
        osPKzIWNNdQnUpe6gxxyDkQYgZDjN/n3O8ECBs0=
X-Google-Smtp-Source: ACcGV63CAXak7vn0OvRkDPo24ecmS/qHyiwnT0RltGElAMhpH3oKYAYYmxEtjM/OjE04lA0r9Ur7NkFylvLGKeodXX4=
X-Received: by 2002:a25:af94:: with SMTP id g20-v6mr5786504ybh.320.1538726826829;
 Fri, 05 Oct 2018 01:07:06 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870033496.29072.3660384210745578982.stgit@magnolia>
In-Reply-To: <153870033496.29072.3660384210745578982.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 11:06:54 +0300
Message-ID: <CAOQ4uxjjSFt07P1Qv9am9sN--UZOojzE4QGQSdx1o+sLN+M2RQ@mail.gmail.com>
Subject: Re: [PATCH 08/15] vfs: change clone and dedupe range function
 pointers to return bytes completed
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Change the clone_file_range and dedupe_file_range functions to return
> the number of bytes they operated on.  This is the precursor to allowing
> fs implementations to return short clone/dedupe results to the user,
> which will enable us to obey resource limits in a graceful manner.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

[...]

> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index aeaefd2a551b..6d792d817538 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -487,16 +487,21 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>                             OVL_COPY);
>  }
>
> -static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
> +static s64 ovl_clone_file_range(struct file *file_in, loff_t pos_in,
>                                 struct file *file_out, loff_t pos_out, u64 len)
>  {
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> -                           OVL_CLONE);
> +       int ret;
> +
> +       ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> +                          OVL_CLONE);
> +       return ret < 0 ? ret : len;
>  }
>
> -static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
> +static s64 ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
>                                  struct file *file_out, loff_t pos_out, u64 len)
>  {
> +       int ret;
> +
>         /*
>          * Don't copy up because of a dedupe request, this wouldn't make sense
>          * most of the time (data would be duplicated instead of deduplicated).
> @@ -505,8 +510,9 @@ static int ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
>             !ovl_inode_upper(file_inode(file_out)))
>                 return -EPERM;
>
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> -                           OVL_DEDUPE);
> +       ret = ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> +                          OVL_DEDUPE);
> +       return ret < 0 ? ret : len;
>  }
>

This is not pretty at all.
You are blocking the propagation of partial dedupe/clone result
of files that are accessed via overlay over xfs.

Please extend the interface change to the vfs helpers
(i.e. vfs_clone_file_range()) and then the change above is not needed.

Of course you would need to change the 3 callers of
vfs_clone_file_range() that expect 0 is ok.

Please take a look at commit
a725356b6659 ("vfs: swap names of {do,vfs}_clone_file_range()")

That was just merged for rc7.

I do apologize for the churn, but it's a semantic mistake that
I made that needed fixing, so please rebase your work on top
of that and take care not to trip over it.

ioctl_file_clone() and ovl_copy_up_data() just need to interpret
positive return value correctly.
nfsd4_clone_file_range() should have the same return value as
vfs_clone_file_range() to be interpreted in nfsd4_clone(), following
same practice as nfsd4_copy_file_range().

[...]

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2a4141d36ebf..e5755340e825 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1759,10 +1759,12 @@ struct file_operations {
>  #endif
>         ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
>                         loff_t, size_t, unsigned int);
> -       int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t,
> -                       u64);
> -       int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
> -                       u64);
> +       s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
> +                               struct file *file_out, loff_t pos_out,
> +                               u64 count);
> +       s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
> +                                struct file *file_out, loff_t pos_out,
> +                                u64 count);

Matthew has objected a similar interface change when it was proposed by Miklos:
https://marc.info/?l=linux-fsdevel&m=152570317110292&w=2
https://marc.info/?l=linux-fsdevel&m=152569298704781&w=2

He claimed that the interface should look like this:
+       loff_t (*dedupe_file_range)(struct file *src, loff_t src_off,
+                       struct file *dst, loff_t dst_off, loff_t len);

Thanks,
Amir.
