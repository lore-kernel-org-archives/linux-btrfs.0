Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4974EC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09A612086E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IFQzqoZU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09A612086E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbeJKMl2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 08:41:28 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:43152 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbeJKMl2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 08:41:28 -0400
Received: by mail-yw1-f66.google.com with SMTP id j75-v6so3108424ywj.10;
        Wed, 10 Oct 2018 22:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1RQ6tbOw4UzAvzY1loXkcInRnICJheNCySv92ZDHG/c=;
        b=IFQzqoZUg63gCSrKKGcZcSGwutE8jpiOV+8QeSdEHP46Ru1K3WZgjSxwOjMftbceCb
         s7MrPMEwPcphsHmGyQMN4P9EZwBb7ypBe5wvlswGe64rb3+xEYM/uIcOUDORdGYfLrEQ
         pleyQy9+uHHg+p/lxjOI6W+uVGw2oeLIvdlgynREn7BWU/mD/JA3jjTYV18DX6oRAdde
         B+P4U8m4zfgNJrz8XtyJInYk6ZnIrQLSsDRFXfDKsUYvA/IspiYABrpiJLwqW7delJD9
         RsXeB87lOusdXu3ghW2cYWI6s6ciNc5bs4AxMFkDaddm5C7KxV5GEUJmBlQqhQlhe5Nt
         /ePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RQ6tbOw4UzAvzY1loXkcInRnICJheNCySv92ZDHG/c=;
        b=UUkFbEskL1nEhwDnDvKcTpi4Ptc9QSjVuYjRNl70/O8pCPQcwA12pGGXzxC6kaNq44
         Tb3wc1IvVRPaxSAKvHMMfTj7Y8oDQRevkJE9ht4xVQu/rbqvA9pMc3z6g5Grvzrsht4w
         zKC8o7A1Jq+hycGViysO7K6LJ0SfK2a1weDMntpW5P1neFVALy66p3Yo6HzMOjQxJh4J
         BybOzuQ4Y5BGlLKjlfGca8suiOcKMQZ3+AOelNTBEf33ldq+eYuc5Fg2KRUpCQccAvBi
         1+hu3p6JSMZy6qpDfG/+Z9BEY/y4uqTIL5PDuG6IDqSYObp/VM9ysvmni1/25dFCM+5C
         K21w==
X-Gm-Message-State: ABuFfoixMbSTQrfmTA2CHXNgGlIJIGPDt1uLFbQz1WD8lmLy0n2TithY
        aqxnEz66rUJr7cb1bPTxKGAxNgnKh43PAWtdVCM=
X-Google-Smtp-Source: ACcGV61zdVe2t+mClKQ1oVwcw7UxQVVvuJxxJJT0AGep8mmhwRW73Zb472cOZCYTEfiBc90Yi2MNafeLYju5vso8jzQ=
X-Received: by 2002:a0d:d4c9:: with SMTP id w192-v6mr32541ywd.211.1539234954991;
 Wed, 10 Oct 2018 22:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <153923113649.5546.9840926895953408273.stgit@magnolia> <153923126628.5546.3484461137192547927.stgit@magnolia>
In-Reply-To: <153923126628.5546.3484461137192547927.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 11 Oct 2018 08:15:42 +0300
Message-ID: <CAOQ4uxgbTf0Po3stK4YZWqYPWTmwfqsSLGwV4p4be6gBrdLP+g@mail.gmail.com>
Subject: Re: [PATCH 17/25] vfs: enable remap callers that can handle short operations
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

On Thu, Oct 11, 2018 at 7:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Plumb in a remap flag that enables the filesystem remap handler to
> shorten remapping requests for callers that can handle it.  Now
> copy_file_range can report partial success (in case we run up against
> alignment problems, resource limits, etc.).
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/read_write.c    |   15 +++++++++------
>  include/linux/fs.h |    7 +++++--
>  mm/filemap.c       |   16 ++++++++++++----
>  3 files changed, 26 insertions(+), 12 deletions(-)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6ec908f9a69b..3713893b7e38 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1593,7 +1593,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>
>                 cloned = file_in->f_op->remap_file_range(file_in, pos_in,
>                                 file_out, pos_out,
> -                               min_t(loff_t, MAX_RW_COUNT, len), 0);
> +                               min_t(loff_t, MAX_RW_COUNT, len),
> +                               RFR_CAN_SHORTEN);
>                 if (cloned > 0) {
>                         ret = cloned;
>                         goto done;
> @@ -1804,16 +1805,18 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>                  * If the user is attempting to remap a partial EOF block and
>                  * it's inside the destination EOF then reject it.
>                  *
> -                * We don't support shortening requests, so we can only reject
> -                * them.
> +                * If possible, shorten the request instead of rejecting it.
>                  */
>                 if (is_dedupe)
>                         ret = -EBADE;
>                 else if (pos_out + *len < i_size_read(inode_out))
>                         ret = -EINVAL;
>
> -               if (ret)
> -                       return ret;
> +               if (ret) {
> +                       if (!(remap_flags & RFR_CAN_SHORTEN))
> +                               return ret;
> +                       *len &= ~blkmask;
> +               }
>         }
>
>         return 1;
> @@ -2112,7 +2115,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>
>                 deduped = vfs_dedupe_file_range_one(file, off, dst_file,
>                                                     info->dest_offset, len,
> -                                                   0);
> +                                                   RFR_CAN_SHORTEN);

You did not update WARN_ON_ONCE in vfs_dedupe_file_range_one()
to allow this flag and did not mention dedupe in commit message.
Was that change intentional in this patch?

After RFR_SHORT_DEDUPE patch the end result in fine.

Thanks,
Amir.
