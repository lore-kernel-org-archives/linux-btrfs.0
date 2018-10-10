Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C75AC00449
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 05:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E64C214FA
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 05:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FSGtDecU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E64C214FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbeJJMoF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 08:44:05 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:41574 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbeJJMoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 08:44:04 -0400
Received: by mail-yb1-f193.google.com with SMTP id e16-v6so1706424ybk.8;
        Tue, 09 Oct 2018 22:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUAuOV/9d6SeuXZv91i/aYa1g03t6wrfmz1jFjCG+JU=;
        b=FSGtDecUuDgmpFfZVrP4/Sgr4+CFWAS1fM2oilX9bpp1zLbyCuZghO8S7WTPFl0+C4
         N8VQkAjppn+xldKF/XX8i4PpQ+dgbzAX1psiC+4lWIYoWGvjOA9tcYRz5WEe7e3myOv0
         YWuTg72bxbCtXUvaWjJwkly1Pw4amQnbBL7OuFKWkwTMWUIjvTDa9/X1u8HxKQMCDvEL
         cv1q7u7NXXT0II3oSvUP2gcf9gc2b6/ZHjUrDgUi/CjL63ydSWFrDaoK5cRvkCLRjziR
         nMoOREvT1DOdm4GS3PJmcB1vMk1Gwa3Ko9lxvHYtnkSnr8W77bKUooYSeshOZNzcoH5D
         0Idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUAuOV/9d6SeuXZv91i/aYa1g03t6wrfmz1jFjCG+JU=;
        b=rwIxltvIV/hDEKsHrnVeIbNZZgiNtxv2SrUmN828YYBh9Ix+vUoOW4hCI6HlcBHF8G
         FKu2p7K6z/qmbbYQ4GWTaeQ+Py93+N8h8LWC1UOEEg1np1szwXCFGQi2xyPaZgcaqkYm
         DFL7lJQufgcRgYTyUIn0rsEjcxVI3cOzYwErjw0wsBZ5KqAS8T2Q0MmymenbjLgnJjsz
         UdS2FkPHlDR0O7poORx9Mo514+ia78VHyHkCgKTU4UybG765fJISvFNPy7sAVEdf3f7M
         QigSl5YDk695J2+Av8InIavyqnEXEEDMvANzldftlIetuntJ9fJcFbFSXAl0eBRBzZwC
         nITQ==
X-Gm-Message-State: ABuFfojbsV06W/LB5chCKalaBqLJil5qnLFoxYs9IFVEnFB1GFgRSVb1
        Ttfy66wzvUcgNW2uOIlLYUQNy++Psswqih00mt8=
X-Google-Smtp-Source: ACcGV60CpjQu7Nwheq4M0n2sjBo4polhKhUdlNiMZmrivAnmrkoSd0dCRl3VhxdUQKQ6kfrSN4wcX+MGPFix5O7eSyk=
X-Received: by 2002:a25:3a82:: with SMTP id h124-v6mr17450830yba.32.1539149018854;
 Tue, 09 Oct 2018 22:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913028015.32295.15993665528948323051.stgit@magnolia>
In-Reply-To: <153913028015.32295.15993665528948323051.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 08:23:27 +0300
Message-ID: <CAOQ4uxjZ1JuT3Ga1kTDF9boeYF5pafDmsnzWxVNPWcTpESchgw@mail.gmail.com>
Subject: Re: [PATCH 06/25] vfs: strengthen checking of file range inputs to generic_remap_checks
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

On Wed, Oct 10, 2018 at 3:11 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> File range remapping, if allowed to run past the destination file's EOF,
> is an optimization on a regular file write.  Regular file writes that
> extend the file length are subject to various constraints which are not
> checked by range cloning.
>
> This is a correctness problem because we're never allowed to touch
> ranges that the page cache can't support (s_maxbytes); we're not
> supposed to deal with large offsets (MAX_NON_LFS) if O_LARGEFILE isn't
> set; and we must obey resource limits (RLIMIT_FSIZE).
>
> Therefore, add these checks to the new generic_remap_checks function so
> that we curtail unexpected behavior.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mm/filemap.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 14041a8468ba..59056bd9c58a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2974,6 +2974,27 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  }
>  EXPORT_SYMBOL(generic_write_checks);
>
> +static int
> +generic_remap_check_limits(struct file *file, loff_t pos, uint64_t *count)
> +{
> +       struct inode *inode = file->f_mapping->host;
> +
> +       /* Don't exceed the LFS limits. */
> +       if (unlikely(pos + *count > MAX_NON_LFS &&
> +                               !(file->f_flags & O_LARGEFILE))) {
> +               if (pos >= MAX_NON_LFS)
> +                       return -EFBIG;
> +               *count = min(*count, MAX_NON_LFS - (uint64_t)pos);
> +       }
> +
> +       /* Don't operate on ranges the page cache doesn't support. */
> +       if (unlikely(pos >= inode->i_sb->s_maxbytes))
> +               return -EFBIG;
> +
> +       *count = min(*count, inode->i_sb->s_maxbytes - (uint64_t)pos);
> +       return 0;
> +}
> +

Sorry. I haven't explained myself properly last time.
What I meant is that it hurts my eyes to see generic_write_checks() and
generic_remap_check_limits() which from the line of (limit != RLIM_INFINITY)
are exactly the same thing. Yes, generic_remap_check_limits() uses
iov_iter_truncate(), but that's a minor semantic change - it can be easily
resolved by creating a dummy iter in generic_remap_checks() instead of
passing int *count.

You could say that this is nit picking, but the very reason this patch
set exists
it because clone/dedup implementation did not use the same range checks
of write to begin with, so it just seems wrong to diverge them at this point.

So to be clear, I suggest that generic_write_checks() should use your
generic_remap_check_limits() helper.
If you disagree and others can live with this minor duplication, fine by me.

Thanks,
Amir.
