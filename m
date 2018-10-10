Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5040EC43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0320B214DC
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:22:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILjM+6S1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0320B214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbeJJNnG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 09:43:06 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35470 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeJJNnG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 09:43:06 -0400
Received: by mail-yw1-f68.google.com with SMTP id y76-v6so1735041ywd.2;
        Tue, 09 Oct 2018 23:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHow5VNqHPG8c8wVL15Fv88B/X0tkI3Nvr8ViHtNPcw=;
        b=ILjM+6S1x4Dsx4tUPRo8/Lei4rUodvpX+x0+1Vb46599ExhoqQRJv9PCUVe/wE2fFi
         prqig+fTfCuI8yKCkRAHs2azyZDWrQxvfRXRV/NiR+ulNpC24J3MZNxGoE9Zvu9zMuC0
         6FcK6emiBYDMJKMJ5UBpDCA2KL0xGn0KFLic21olV49b2X8UfGXAc5tcWEaXGLVVL+T2
         DqMWIvPO5js1McEBOEVjXwBpLSMy8mI4LeajhEQfY2R3CcqUUMcpoAzjLwvGMqif5U26
         1OLOmH6bFGoMPNL3Vn4mI6hZ28Ngsz6diAcG7pjKKGISog59iIWSsd0t7on8iaevXwWp
         7lAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHow5VNqHPG8c8wVL15Fv88B/X0tkI3Nvr8ViHtNPcw=;
        b=BdPyTdo6mABQmX1lCagH4IT74LBzuH20+8ZYRurERErHSJQRLH5Le3haMRXjvR/l8v
         ACCgyqJxKpHoxgrIkHgPevWsPJTTGzpmcnCBIhzdGFjIC2gFGlWCotovOK9JTQA5Nt2f
         iwDKIaX7AH6jAEd6kzW2BXu7zmMUNvTd5saB3RSIETloIRriBlrDKsciHb8DgSwzcoZ2
         6n0gXgcdI0ztNBC3Ai30gdbvDO1aC6/aFvjFmJStGVdH4RNelZnZlUn186iPwhY1fkQw
         WRNFHq+/J1h6FhjA8Jj+0V+kAofrPHPCO9hpOOsiTE6ILVJX8508Xt316W8Jg3+NlqbI
         hunA==
X-Gm-Message-State: ABuFfoh7ziWEQpEnNcsLsCVG8ImvFI5wWWUSunowIUHVyGIKhsCqE9WV
        wr2To48vQv2CE/PB8kMeOvZ0YVJNQAHdHhVC1tI=
X-Google-Smtp-Source: ACcGV63btYeb6ssN6pFLzYwl8LQIVAIqac3VktMAbLkVS+rNTA6WbEZuf+KZJxxheTTVj3YWx9PEPOp5gzY58m9tKZo=
X-Received: by 2002:a81:ae4e:: with SMTP id g14-v6mr17506393ywk.248.1539152548123;
 Tue, 09 Oct 2018 23:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia> <153913041692.32295.9928643841686525236.stgit@magnolia>
In-Reply-To: <153913041692.32295.9928643841686525236.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 09:22:16 +0300
Message-ID: <CAOQ4uxgT-uBn=Zf=085J0HQNy8kgDzB=kNh_dXHXQEbr83Vehw@mail.gmail.com>
Subject: Re: [PATCH 15/25] vfs: plumb RFR_* remap flags through the vfs clone functions
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
> Plumb a remap_flags argument through the {do,vfs}_clone_file_range
> functions so that clone can take advantage of it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
[...]
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index c8c890c22898..8b22035af4d7 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -462,7 +462,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>
>         case OVL_CLONE:
>                 ret = vfs_clone_file_range(real_in.file, pos_in,
> -                                          real_out.file, pos_out, len);
> +                                          real_out.file, pos_out, len, flags);
>                 break;
>
>         case OVL_DEDUPE:
> @@ -509,7 +509,7 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
>              !ovl_inode_upper(file_inode(file_out))))
>                 return -EPERM;
>
> -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> +       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>                             op);
>  }

This patch forgets to change args in ovl_copyfile() function definition.

Thanks,
Amir.
