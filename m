Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24F7C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3E0218D2
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 13:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l4420JXc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfDXNxk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 09:53:40 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:42433 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730096AbfDXNxk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 09:53:40 -0400
Received: by mail-vs1-f67.google.com with SMTP id f15so10411203vsk.9
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 06:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=QEPtwb0QWcvnwzwwkKTQ4BPgW7JdIDfyu2T5siL18oM=;
        b=l4420JXcxNS4udnmRWBTDaCQ2EKR5WXB6KWMl1MKTcybuVYBpfh1Dl9oxITTqLBRyK
         0oEeK8FQ0vvrCHrvjm7zugXx0wCimJI5pERIC/Zqd1+wJyuhdwOF60EEaspewpUmLYwf
         3HPOofgPxjzYS+giTwd5einE+0POAdZwBLGf9EpplkA4RdVamQgwBSBQnVpJ24q6d7Lo
         qwzN46vnyT/kzxrmv7xoMi2mZeBJLs3uTwopYrp5pSiAcXyCQKT0F67lh4ypmHSk85YK
         4Cw/43c847SERh2CZ+/6ykQB8HWBjATjYj21bE8gpYixzxMAKURJdSHzIwA2I2uZ875A
         14BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=QEPtwb0QWcvnwzwwkKTQ4BPgW7JdIDfyu2T5siL18oM=;
        b=AjE8T13/DF835dMhylObznmqZ37xvJffylUqRKjch2JiAXoHSXKXeb0FTR5+s4Zsic
         YMG2OSp9G4euHkGq/Hmx53DNYzPs3ObgEfqfzaeOfhfyZujYm8CNvmI8Kvy1k/ILd65a
         DJBi220pfhndJegy+FEh+q/vk8MSWBmF8x0vkpW8v7UrFOwbu0LwzV+hKFIC+YdcogX9
         rIMDhtIomF6vim+yfJ9Qm9mC3OxtkOAT/1Nc0wQ3PqJicwimDFLZF5DYtSFuVLD72qUg
         U+mYI1hacT2/hB81IffLanolJnXnjstTOCdIREiRniNTUvVpTKo5FYJN2hB8t/B5KTM0
         mTyw==
X-Gm-Message-State: APjAAAXSkOslfvGcyinEofe6M3m76IJujYcYm2YeVz1UTGDwTx043StO
        NgqQ0N/ST7qXgKe4iK69hjU2EXIFW8UaGHWhb/M=
X-Google-Smtp-Source: APXvYqwBRx2tlhEwI9/knpXamxN6DHMF1s3lYRqWo88H5TBJLFZHYlk8EljFZkgTFupr9Lc/Xfm7nYzt4oDNf7zl4Ms=
X-Received: by 2002:a67:d098:: with SMTP id s24mr16505240vsi.95.1556114019018;
 Wed, 24 Apr 2019 06:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190424124829.14277-1-wqu@suse.com> <05b5b4bc-4849-61c9-79d9-72af22cfaf1e@suse.com>
 <9dd0ff19-97fe-1f43-f884-4d539fc34343@gmx.com>
In-Reply-To: <9dd0ff19-97fe-1f43-f884-4d539fc34343@gmx.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Wed, 24 Apr 2019 14:53:27 +0100
Message-ID: <CAL3q7H5ZZU0eEwUMH_SLcCuHd2jD-dEOFeWQBquNWFZyLoLV2A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: ctree: Dump the leaf before BUG_ON()
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 24, 2019 at 1:57 PM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/4/24 =E4=B8=8B=E5=8D=888:52, Nikolay Borisov wrote:
> >
> >
> > On 24.04.19 =D0=B3. 15:48 =D1=87., Qu Wenruo wrote:
> >> Let's dump the leaf content before triggering BUG_ON() so that we can
> >> have some clue on what's going wrong.
> >> The output of tree locks should help us to debug such problem.
> >>
> >
> > The reason is some sort of in-memory corruption/confusion of the extent
> > maps, causing overlapping extents. However so far it hasn't been
> > possible to reproduce that on-demand to actually debug it. Filipe
> > suspected it has to do with extent mapping merging logic. This only
> > occurs when working with the log tree which takes its data from the
> > in-memory extent mapping tree.
>
> Anyway, this won't hurt. right?
>
> If it gives us some clue, that's the best case.
> If not, it won't make the current situation worse, right?

Right, but dumping the leaf alone, may not tell you much (I've been there).
Printing the new key and slot, together with the leaf dump, helps much more=
.

Thanks.

>
> Thanks,
> Qu



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
