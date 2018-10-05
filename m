Return-Path: <SRS0=6tJf=MR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E0BC00449
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1170D20875
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Oct 2018 08:39:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NjPTp6Za"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1170D20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbeJEPhS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:37:18 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35135 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbeJEPhS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 11:37:18 -0400
Received: by mail-yw1-f67.google.com with SMTP id y76-v6so4938020ywd.2;
        Fri, 05 Oct 2018 01:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/fu/BTydMXzRWN2CrdV31OzloX1CkvgJoxVjiOoyqyM=;
        b=NjPTp6Za/WgiigIh/Ti9SWRU3QV5k0piZ54NHY19P0hfQhjU7diqTnc7m0LNkb1scF
         f1XI8M3xVYPJOeDwtdxpzxUXkRNLoVhdfiYimChokAXVzwGr9Quelo92rSS7MlFGxTrH
         Nqncfwkc82MVgiJaq3zEED/LvXT2+IkoPRulOUv6UGLQgWp/NukWe/iS09L2X+jhRkaW
         jtvYy6PY5eRc91saUcVQPA8tYbG/V+VyWFwSkGgj81/HjgJqVQIx4euLxUSl/OHIwat2
         TZN/UA+ZLtJ9xphlGgJMax+VSbX8uxxt9grZqQs56Z6nzGKVeUd/wQBmeLj4BroxL4qh
         7nJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/fu/BTydMXzRWN2CrdV31OzloX1CkvgJoxVjiOoyqyM=;
        b=ho2oiXtQt0+FPxHfGfAwda1n4Kt4ZEeIPIXY037geYTHL6TJIZrMlVSrJBvl+wZi7k
         wVz1LlWLwdGCLqp2pJpCKHVXFmsWze6EQDIhOR1ein+TB3g8uFQq9+6lAhdfc8MP/2S+
         YMTMWt8Q6ptWcVdIzyDGLVh2eFfkkegbVLUv25STkWGHAHdDXp0qvQAA/2jW41zgJK8H
         cFfsiSHFP4cNEEGaSRfU+cP1MMJNIG4XwOmMcAxlDEGGxbgGnwxj9RBUns4KIdSjb9zy
         C5OvRAM7e/VfB0dqAuriW7vdhIeKbtoIOHWjPf7uCgp3fwHs2AKeDlhH3jCMJGhfxSxv
         vaaw==
X-Gm-Message-State: ABuFfojs8F5+NAHdbnL8WyGY245Vh/9FN+QEKBkotQ5Vzy6nn/ELkulW
        C5Ce8PKErn7/KaVaL/1NJNeArsqWzN2WqK6gT0c=
X-Google-Smtp-Source: ACcGV63BSdyUuq3ufP+fWrI0JwMlh1uMdlX9gsfJPWPsmpKILHbK6W1rWTui9qVYTcRV68KKJR4PU/jHyoZGfK2dE9E=
X-Received: by 2002:a0d:c947:: with SMTP id l68-v6mr5678893ywd.404.1538728775837;
 Fri, 05 Oct 2018 01:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <153870027422.29072.7433543674436957232.stgit@magnolia> <153870032167.29072.11158511021942868400.stgit@magnolia>
In-Reply-To: <153870032167.29072.11158511021942868400.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 5 Oct 2018 11:39:24 +0300
Message-ID: <CAOQ4uxha3=jyVmZ0ArbSsO-CSMeQb43p7YTMGazZRB_M8zS0SQ@mail.gmail.com>
Subject: Re: [PATCH 07/15] vfs: skip zero-length dedupe requests
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
> Don't bother calling the filesystem for a zero-length dedupe request;
> we can return zero and exit.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 973d3da78c09..99b2f809180c 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1966,6 +1966,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
>         if (!dst_file->f_op->dedupe_file_range)
>                 goto out_drop_write;
>
> +       if (len == 0) {
> +               ret = 0;
> +               goto out_drop_write;
> +       }
> +
>         ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
>                                                 dst_file, dst_pos, len);

I suppose it is best to let user get the same errors he would get
before this change rather than skipping zero length copy at
vfs_dedupe_file_range() level, so looks fine.

Thanks,
Amir.
