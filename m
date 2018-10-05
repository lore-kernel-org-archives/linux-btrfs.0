Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC39C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D8720875
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FKSiSbKf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0D8720875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbeJENiL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 09:38:11 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45699 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeJENiL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 09:38:11 -0400
Received: by mail-yb1-f195.google.com with SMTP id d9-v6so4986539ybr.12;
        Thu, 04 Oct 2018 23:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vas4dRpbtpTulEnJmj/AVHrmEwEX74JBZzMGwuxbqe8=;
        b=FKSiSbKfC34zTepI7pAEyHqjgyVl5AXa/jmBcSZMO+RE6kfcam3zxgPpDTBRiWm/Pq
         Nk5qC6uuU91MKyHgb8dYpMSrpwYNZIc6T631y8BwHMvjm63uom4jkG6/N5wi9mEGxiZH
         m/WZN1HhYyce8jCBEimSXnv8V3f7TfrCeNyJhXBUvb9bH5rn3f66+gLIJHiLGZqqxxdE
         9r4kqiGN98E/Kf1sukdCX2sww0pQ2ve2ES5dSSzrDRFvcdTarLUQEPw5QihMEpwUGad4
         utN/GbJdiuEloNByqRaH5rYpCl+j1vHxw0stFUfYXSd26Sw1OwUASu3HOGIQS/q6ROvS
         pNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vas4dRpbtpTulEnJmj/AVHrmEwEX74JBZzMGwuxbqe8=;
        b=uGmRbO+2nfrYY5uF3eMJSFepHYHdDUtex/l7NLZeiokjBmrye1M/64jJZGgD2iwaZc
         g6DWopG8PazlGzt0B+MH/vlban3w/ghUMxr8g1RPI9HoFDAfIGxvphV/KlWDgJX8vT72
         W38uyKHGj2RVz8Mgrtr5voInUegNhhX+cULnkQa/iQf5dyX5rX4qyXghqwEtDBDxBNYu
         K4qC+3rOPYoSrzntoJuK+DGLs6I6cgtDSxp5tzhFuR9GoLNADuqdOaCPnbSYGPBTNhkz
         jC0FmAtEeT5+EAKPDD5OEZ9lnV/ego0ROaCWGflGG9Sg9BJnsQt5ttPfTS7uZq/hdJzQ
         p/ZA==
X-Gm-Message-State: ABuFfogiwmELv5A41jZQrs8h4Rxzj608Dzw2I9+cHnN0jUB8L9aQbLD6
        4humho8rp03EJgBxzalX8JeVth/IjLvhQJUs6Rw=
X-Google-Smtp-Source: ACcGV61Q/Lw2muehAFM9Yd2+rj9U6eMwtpdMS2Ti4a8VkwFxTswLNDVggA5NxMZfF+qm+1xTL7W+ex2xyCGjlpii8zc=
X-Received: by 2002:a25:5555:: with SMTP id j82-v6mr5811918ybb.337.1538721655620;
 Thu, 04 Oct 2018 23:40:55 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870036143.29072.11970142092673351715.stgit@magnolia>
In-Reply-To: <153870036143.29072.11970142092673351715.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 09:40:44 +0300
Message-ID: <CAOQ4uxgqQ9ovr1i5+uGz1hq=fedFGKK7TpPCUvXkYPXhoPji3g@mail.gmail.com>
Subject: Re: [PATCH 12/15] vfs: implement opportunistic short dedupe
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com, Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 5, 2018 at 3:46 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> For a given dedupe request, the bytes_deduped field in the control
> structure tells userspace if we managed to deduplicate some, but not all
> of, the requested regions starting from the file offsets supplied.
> However, due to sloppy coding, the current dedupe code returns
> FILE_DEDUPE_RANGE_DIFFERS if any part of the range is different.
> Fix this so that we can actually support partial request completion.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c    |   44 +++++++++++++++++++++++++++++++++++---------
>  include/linux/fs.h |    2 +-
>  2 files changed, 36 insertions(+), 10 deletions(-)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 292d68c2f47c..9be9f261edd2 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1781,13 +1781,11 @@ int vfs_clone_file_prep(struct file *file_in, loff_t pos_in,
>          * Check that the extents are the same.
>          */
>         if (is_dedupe) {
> -               bool            is_same = false;
> -
>                 ret = vfs_dedupe_file_range_compare(inode_in, pos_in,
> -                               inode_out, pos_out, *len, &is_same);
> +                               inode_out, pos_out, len);
>                 if (ret)
>                         return ret;
> -               if (!is_same)
> +               if (*len == 0)
>                         return -EBADE;
>         }
>
> @@ -1872,13 +1870,30 @@ static struct page *vfs_dedupe_get_page(struct inode *inode, loff_t offset)
>         return page;
>  }
>
> +static unsigned int vfs_dedupe_memcmp(const char *s1, const char *s2,
> +                                     unsigned int cmp_len)
> +{
> +       const char *orig_s1 = s1;
> +       const char *e1 = s1 + cmp_len;
> +       const char *e2 = s2 + cmp_len;
> +
> +       while (s1 < e1 && s2 < e2) {
> +               if (*s1 != *s2)
> +                       break;
> +               s1++;
> +               s2++;
> +       }
> +
> +       return s1 - orig_s1;
> +}
> +

A few nits:
'len' wouldn't have been ambiguous in this context.
I find the for loop in memcmp more elegant. It is definitely shorter.
Not sure how differently the variants compile, but decrementing
count/len seems much more sane then checking 2 conditions that
always have the same result.

Thanks,
Amir.
