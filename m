Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD5A2C00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7160A20834
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 06:10:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bn3QzIBw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7160A20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbeJENHg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 09:07:36 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37957 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbeJENHf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 09:07:35 -0400
Received: by mail-yw1-f67.google.com with SMTP id d126-v6so4817869ywa.5;
        Thu, 04 Oct 2018 23:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXmfAgMw9espQ+NSWqWRysI5sdwrphIGIxYKnH3v9/4=;
        b=bn3QzIBwrE9Rg14JnxALA9DOuNK1TnF4DtJROaquVlZQPzZ7ZXwaOKVNtw642qcYrk
         uCp+u21+RRkKz4du+IX1NMyv8uSwCsHNmOzMWaLFzrtgsTm/mBmUfsYIQvxuYm2xqikZ
         4YWtfYNl6bylw8UWT7qM6Pp7MGMXCYPiEaK2huzgV09yXyDUNr4oaM0urE81daIoW4Vb
         hBuiSatmVZ4xVVJfc4ORezf493IJZDHxo7NELBoPisYk/bitXyvCb6baxcO8c1Nt5YbM
         htyD1L1vzDdweQ6kqjJ0zpOqeccGtvNpyvVog16eh412F3IQ02gp/F98YlThf6cYKMcM
         U4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXmfAgMw9espQ+NSWqWRysI5sdwrphIGIxYKnH3v9/4=;
        b=Bp6/91bVNcJ88nXIyjz89Ird7osPAgMSIgqMjZPxTjIRLBHibII6qz8BCuwtjMHDMR
         TsgSWCSrgNOx97Qz9o/XfGhpa9KMHuRqZWNmFqIpErJeSq9scjuLcae6l6QoIf4T4qwk
         7Fm/wWSKwRAw1gNPs1UOzUVHx4TELgGnEdEcdK9Q0M3zg4VLU1vzqO4J6dLWTnlNdjsm
         cYILwH5y+8ZkkgcKyxV956s7N9K+EqzdIUh0pMlMoNb8uEJBIcmsAK2psiQt3aaIul11
         hrreS7fbfsDoUF6qANG3cRylJSApNUathYXfWSxuXAB9HB4gJgArSPVCjLVqxFhw0ksM
         6eeQ==
X-Gm-Message-State: ABuFfojl/b0JHKZ09NswyE6KJ8upXBJReAYf0tI3C/MzhKyULGYOp1kN
        4uvDBVO4Opza9pluDdgzRGXeI/bMNbHODjzJwcU=
X-Google-Smtp-Source: ACcGV61OSBgumZsKmAzKozTBEfjJ+f5+VLIe+VJkTXI6OU2FP5LRBMBvNWuZTySaJzFow7UvOS3nGadd3RyWTtXmRfU=
X-Received: by 2002:a0d:d4c9:: with SMTP id w192-v6mr5325290ywd.211.1538719823835;
 Thu, 04 Oct 2018 23:10:23 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870031519.29072.18289185889660082318.stgit@magnolia>
In-Reply-To: <153870031519.29072.18289185889660082318.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 09:10:12 +0300
Message-ID: <CAOQ4uxiVPvNPxTNZ-njeyte6yk3jo3tjNKv78kS9NqA_Xzxc6g@mail.gmail.com>
Subject: Re: [PATCH 06/15] vfs: strengthen checking of file range inputs to
 clone/dedupe range
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
> Clone range is an optimization on a regular file write.  File writes
> that extend the file length are subject to various constraints which are
> not checked by clonerange.  This is a correctness problem, because we're
> never allowed to touch ranges that the page cache can't support
> (s_maxbytes); we're not supposed to deal with large offsets
> (MAX_NON_LFS) if O_LARGEFILE isn't set; and we must obey resource limits
> (RLIMIT_FSIZE).
>
> Therefore, add these checks to the new generic_clone_checks function so
> that we curtail unexpected behavior.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mm/filemap.c |   31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 68ec91d05c7b..f74391721234 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3015,6 +3015,37 @@ int generic_clone_checks(struct file *file_in, loff_t pos_in,
>                 return -EINVAL;
>         count = min(count, size_in - (uint64_t)pos_in);
>
> +       /* Don't exceed RLMIT_FSIZE in the file we're writing into. */
> +       if (limit != RLIM_INFINITY) {
> +               if (pos_out >= limit) {
> +                       send_sig(SIGXFSZ, current, 0);
> +                       return -EFBIG;
> +               }
> +               count = min(count, limit - (uint64_t)pos_out);
> +       }
> +
> +       /* Don't exceed the LFS limits. */
> +       if (unlikely(pos_out + count > MAX_NON_LFS &&
> +                               !(file_out->f_flags & O_LARGEFILE))) {
> +               if (pos_out >= MAX_NON_LFS)
> +                       return -EFBIG;
> +               count = min(count, MAX_NON_LFS - (uint64_t)pos_out);
> +       }
> +       if (unlikely(pos_in + count > MAX_NON_LFS &&
> +                               !(file_in->f_flags & O_LARGEFILE))) {
> +               if (pos_in >= MAX_NON_LFS)
> +                       return -EFBIG;
> +               count = min(count, MAX_NON_LFS - (uint64_t)pos_in);
> +       }
> +
> +       /* Don't operate on ranges the page cache doesn't support. */
> +       if (unlikely(pos_out >= inode_out->i_sb->s_maxbytes ||
> +                    pos_in >= inode_in->i_sb->s_maxbytes))
> +               return -EFBIG;
> +

Forget my standards, this doesn't abide by your own standards ;-)
Please factor out generic_write_checks() and use it instead of
duplicating the code. The in/out variant doesn't justify not calling
the helper twice IMO.

Thanks,
Amir.
