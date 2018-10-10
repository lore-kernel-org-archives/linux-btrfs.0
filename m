Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E404C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D85ED21479
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 06:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPlP0mAs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D85ED21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbeJJOAi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:00:38 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:43073 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbeJJOAh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 10:00:37 -0400
Received: by mail-yb1-f194.google.com with SMTP id w80-v6so1756791ybe.10;
        Tue, 09 Oct 2018 23:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CRgyZVjFR/XVdeZOPLxrz4jFRyqeUaSMGx4MJkIivWg=;
        b=MPlP0mAsqPa/WYS3WzAWw07RzEKfO0EQm4xZqbbk87cFQ+qDkOBYMNQN6IbTOiXnGb
         1e2hz8lzPhvqYtJcEzNdkxsKP3pdPPEHNGLtmEJo7POGKlz0wIInETElFirarM5D3/Zn
         5Mge9LFRb98CFDLhn1b2ByWYq+PgKB5bn0F3NGgl09Q1ZwgVMF/VT0IqZFl358DEW2Ow
         xKXYDWIRbpwxxJy2ElvXGl/S6Nyw5mCAFsSn1uZnBEHCFQ/ZwRPP2KB95bINGSgjFiM8
         KKq3IJ24PAet3TsKqH199mFBrGFyjufUR9mKCs+0zcEiVTu0ohiFkuQUpMdP6Py4rU9O
         i46w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CRgyZVjFR/XVdeZOPLxrz4jFRyqeUaSMGx4MJkIivWg=;
        b=fm+WGnHxbgA0sA34FBH7l0WxWaRq2xYHI5vODHLR2fvc3btRKZLihRLL1tQOkHr4cF
         dHFPfGXWbeuefsp/XyGVB9izs26GOmx5LCqjPe14n2gqXWB3sQaFJgqFugu/OnrC/X45
         f8i/TmDBYxx9mcX/RfC4DH8PSppdJEhiIHuyHF3FBPXm6DnbEwGGJIUK65TCxkekBrvH
         4+hLWsA56PPImkMpW5s8GRKCeAZEF2b2bedgo10uVBzRCArgcDOTyNL8K4X9ijgPF8w3
         ooZptfk+liWzUQeB1r8IUzD677UBjz+dvCYgIoQUge8aiJM4ZhBV+sRhjhbmeqG1tR1D
         7onA==
X-Gm-Message-State: ABuFfogMiGs0p4PYqyjdltP+BP2JFqwT5hpxFQgxChtIAiV6xw+TkseA
        s1OIOjSLTTRw0qtn5M/otfgPVyNlOyOxNbSlcraQrw==
X-Google-Smtp-Source: ACcGV63vOSkGkmM5GM3tQKbWbBGqUEjnYkhfIgGIa8UmGGJeVyYAKQp44cMTQpOTnJaqIdZ0gCb1IIr/A47pmqGYKYI=
X-Received: by 2002:a25:1a85:: with SMTP id a127-v6mr18272633yba.507.1539153596137;
 Tue, 09 Oct 2018 23:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913041692.32295.9928643841686525236.stgit@magnolia> <CAOQ4uxgT-uBn=Zf=085J0HQNy8kgDzB=kNh_dXHXQEbr83Vehw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgT-uBn=Zf=085J0HQNy8kgDzB=kNh_dXHXQEbr83Vehw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 09:39:44 +0300
Message-ID: <CAOQ4uxiLye2PB3PBzYJ=CAbPx7Nnxti946pba=K-pu5cJfETog@mail.gmail.com>
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

On Wed, Oct 10, 2018 at 9:22 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, Oct 10, 2018 at 3:14 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Plumb a remap_flags argument through the {do,vfs}_clone_file_range
> > functions so that clone can take advantage of it.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> [...]
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index c8c890c22898..8b22035af4d7 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -462,7 +462,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
> >
> >         case OVL_CLONE:
> >                 ret = vfs_clone_file_range(real_in.file, pos_in,
> > -                                          real_out.file, pos_out, len);
> > +                                          real_out.file, pos_out, len, flags);
> >                 break;
> >
> >         case OVL_DEDUPE:
> > @@ -509,7 +509,7 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
> >              !ovl_inode_upper(file_inode(file_out))))
> >                 return -EPERM;
> >
> > -       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
> > +       return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
> >                             op);
> >  }
>
> This patch forgets to change args in ovl_copyfile() function definition.
>

Sorry, it was already there.

Thanks,
Amir.
