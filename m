Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06BEC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F7C82084D
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 07:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmcM52lN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F7C82084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbeJEOFQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 10:05:16 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36021 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbeJEOFQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 10:05:16 -0400
Received: by mail-yb1-f195.google.com with SMTP id 5-v6so5036682ybf.3;
        Fri, 05 Oct 2018 00:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=irvS0/yyLva7NtY9K5OrB7KnPGY22KcwWAJaqwdGp5Y=;
        b=cmcM52lNU7UoVyeLTHbS5x3YPvRCM5MDvd7AqFv4DRdb5xdUXnqF9sFR8xWi058/uh
         EWsguNgeK+GXyIpCWqvGWiI1Z5rSQGNGzkS6DEscZWrNvbD0p2Nh3BLdiVyDI0COhd8S
         ZOIgQRx5BdUW8gNF/Ayr9BKgEAYlJKHa7JvWhai7tpawnRMv41Gb8iaDCxXr53t1gPir
         pwPU6LDxbfs6HPOnHxQOCOJ/TTVqqwJfmt7JbHCn8DEjG/bcrM3vHzRlot3nFti8/mwW
         nCMIDL4Oas1mO9QQeWSBxycIw30WT+6uxWdNXF7HaaVjmA8zHl9HcV5GjYRTBv/F+/Hx
         UYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=irvS0/yyLva7NtY9K5OrB7KnPGY22KcwWAJaqwdGp5Y=;
        b=f8g9W8okpXjJx4YjrnGtBvTE3q7ypQS++Qa1KC7oJiYkqMEfijCi9q4y21aVF5Mbpg
         ZkxqNa+hryGDNjXZfpTMkjt7mp4f2HtGN2W8+Fc+/bLoCUHyxEfHej5+FMokG8sa/Us4
         3WLfxz96Cyn7HYUGT8rB+NFpZHx0cI+NXU3aGxj41KPGb/vY+dS5nxAVGHhAyBDPY+Pq
         vl3zDIz+6rhoxBCo8Qq99YFLRQfOkZB3fOuag0CDpmIjnrGZujG9gySPSpEXCe6HZdkm
         6PtEqoTAfip95CKL0/OtBzG0riFNlwe17n5yZBeaerhG6T70H5L/wDqshkGv0snOHRBZ
         WMdw==
X-Gm-Message-State: ABuFfohWbXX/aZDvZ5d+gmKFA3RqJsvftrd7YoRCWgyFzyt6gRENzsIp
        DoNBk+pxVdt+ZsFm8s0VMacs0LTd6ouPcS9ev2s=
X-Google-Smtp-Source: ACcGV62/j3XcuiKqD6YLy11sV1OD+y291ZIgdOaop/jaIuLL1PcUny21XjWhjKbAxppVdOAYdxcylsxEZZcamBNSPrk=
X-Received: by 2002:a5b:f03:: with SMTP id x3-v6mr5680907ybr.462.1538723274730;
 Fri, 05 Oct 2018 00:07:54 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870034158.29072.8943691140742142494.stgit@magnolia>
In-Reply-To: <153870034158.29072.8943691140742142494.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 10:07:43 +0300
Message-ID: <CAOQ4uxhDhyx-SnyJ5mmsKMvvb883reCWgvyNbABKyC4-SO+1EA@mail.gmail.com>
Subject: Re: [PATCH 09/15] vfs: pass operation flags to {clone,
 dedupe}_file_range implementations
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>,
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
> Pass operational flags to the per-filesystem clone and dedupe
> implementations.  This enables the vfs to signal when it can deal with
> short clone and short dedupe operations.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1761,7 +1761,7 @@ struct file_operations {
>                         loff_t, size_t, unsigned int);
>         s64 (*clone_file_range)(struct file *file_in, loff_t pos_in,
>                                 struct file *file_out, loff_t pos_out,
> -                               u64 count);
> +                               u64 count, unsigned int flags);
>         s64 (*dedupe_file_range)(struct file *file_in, loff_t pos_in,
>                                  struct file *file_out, loff_t pos_out,
>                                  u64 count);
> @@ -1827,9 +1827,15 @@ extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
>                 unsigned long, loff_t *, rwf_t);
>  extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
>                                    loff_t, size_t, unsigned int);
> +/* Caller can handle a shortened operation. */
> +#define CLONERANGE_SHORT       (1 << 0)
> +/* End operation at the source file's EOF. */
> +#define CLONERANGE_EOF         (1 << 1)
> +/* Operation is actually dedupe, not clone. */
> +#define CLONERANGE_DEDUPE      (1 << 2)

That's cool. But you know what's going to be the next step, right?
Merging the 3 file operation interfaces into a single one.
copy_file_range() already has the flags arg for future extensions
and as you wrote somewhere, clone is really an optimized copy.
ovl_copyfile() already does that internally.

So the only take away for this patch series, please use constant
names COPYRANGE_* and also explicitly define:

/* Operation is actually clone, not copy. */
#define COPYRANGE_CLONE      (1 << 2)
/* Operation is actually dedupe, not copy. */
#define COPYRANGE_DEDUPE      (1 << 3)

Thanks,
Amir.
