Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09A9C43610
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97BCE2150C
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 15:23:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGggEL/H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97BCE2150C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbeJJWqf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 18:46:35 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46147 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJWqf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 18:46:35 -0400
Received: by mail-yw1-f68.google.com with SMTP id j202-v6so2306319ywa.13;
        Wed, 10 Oct 2018 08:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icljF4y+ikSuO6KOd/oSXw/ilriUZGZi/CAU9CWE6Xg=;
        b=iGggEL/Hcm6n4z6brQ5GFY7KQ76V89iNT0EtL4zbNYIkwgEoOr9IVDqJbsPAYhAxqO
         9nO/0MzrqyHHS2C22DOAboTSwgeOyrV5i2i2z5ds0gPkcObO2RMNVc+ImSjmewCRcsnY
         JiK9fEDpgZlG1B460CZgXfw74FWxQ3q6zxuiKliKSmHLTdHU0qJ/ClY+BUgvMyu/IyHy
         myJG89EDmPF8GE5eXY9YQVlWGeSqNF2wjzqwnBcHZ2JU20qptMTfTy4JRX8wynKnFHzp
         n7j5rXc6KfwvER2sW4BDAxnNJGEKjeHWIp6FgXs+OffVQbxAnwYJTcXTrSNoForcxVnA
         Fikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icljF4y+ikSuO6KOd/oSXw/ilriUZGZi/CAU9CWE6Xg=;
        b=SFIg0ARomTWYpqesWeoPVTVMfOerMfCkJ1h5j/pSP8Lx6jdWYE0LhiLe/v/QOjGLcF
         vjmZ/If2bEfHewrL+nihROaAZwe3ufDBrovvKUKu+S3ksVasp7qq3Z5YwHhTuaicAqSP
         3x7FHPLQqfg9uyvmxVYed/GzNacbS24eMe0iGg1xr9yXtFHEYd057uxsTRunoA5mEO/F
         CkkFq+LOesxzqoyRA87cldVs2fWdNrbuipPYClE+nzM3Lo3Yq0+NALiTlRM2+mtqxku6
         ANWxLtTYK7HxPNV2ZJ5WdOgi96dE7LOlj1JXxna6gzBFR9C+wHV7vbcFRY1jh3rhBRmz
         RnBw==
X-Gm-Message-State: ABuFfoizulz4jx8kIKcivh0GsbY/mXzkzJe0EGx0A5tnSFx+5XNuR/F9
        OhcMDi0gjOFqBhA0MRA6JDgGAnn/wLaPrmwVz8I=
X-Google-Smtp-Source: ACcGV60V1piiwXQP+rC+qUQhW6n4w/zd/p6P3uES9RKkxuUEZ+V+CzBfrCB1wslKCH2ucLcncrhDcjgW/r8M1pi958g=
X-Received: by 2002:a81:ae4e:: with SMTP id g14-v6mr18730360ywk.248.1539185034760;
 Wed, 10 Oct 2018 08:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
 <153913029885.32295.7399525233513945673.stgit@magnolia> <CAOQ4uxj_wftoGvub9n_6X3Qc64LKxs+8TB-opUiq59sGQ=YoKw@mail.gmail.com>
 <20181010151321.GR28243@magnolia>
In-Reply-To: <20181010151321.GR28243@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 10 Oct 2018 18:23:43 +0300
Message-ID: <CAOQ4uxjrkgiKXTYP8d93kLvU2zaKO14Wx3ZL7-7TnDd95CHnOA@mail.gmail.com>
Subject: Re: [PATCH 08/25] vfs: combine the clone and dedupe into a single remap_file_range
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

On Wed, Oct 10, 2018 at 6:13 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Wed, Oct 10, 2018 at 08:54:44AM +0300, Amir Goldstein wrote:
> > On Wed, Oct 10, 2018 at 3:12 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Combine the clone_file_range and dedupe_file_range operations into a
> > > single remap_file_range file operation dispatch since they're
> > > fundamentally the same operation.  The differences between the two can
> > > be made in the prep functions.
> > >
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> >

> >
> > Apart from the generic check invalid flags comment - ACK on ovl part.
>
> Thanks for the review!  Is that an official Acked-by to add to the
> commit message, or an informal ACK?
>

I would offer my Acked-by for whole of the vfs patches
if we agree on the correct way to handle invalid flags
(see more comments up the series regarding the "advisory" flags).

Thanks,
Amir.
