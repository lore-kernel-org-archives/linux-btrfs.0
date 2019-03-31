Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02994C43381
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 21:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A62AE2085A
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 21:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="XK8dcpdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbfCaVfH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 17:35:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35300 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbfCaVfH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 17:35:07 -0400
Received: by mail-lf1-f67.google.com with SMTP id u21so4833575lfu.2
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Mar 2019 14:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjgLodXaWd73j2zyesKlCdIE6TT7rzt0M4RC+B5RhmU=;
        b=XK8dcpdpvWuBZgsyZHcA9hH5DvAM/srL+YPTsYHS3uwCgAkRob9i1oFL11cq/ug1Mt
         4JU/sEQaNuTTgqvKOcKBlCYfU/7vWtmYYDaMtChCbH+KN14UvdnwW2zNtbKWC8Cue4n8
         Vt8pQn2q+QXjIZzJDNLB5+vlB9DvQmq/wApOjcGOLxnweCCu90TPJFVuyhgNm2HOh+3O
         OtJeumtqkC4RfJJ+UWyp374nPY5bhP1gMfrg7WDH1P2aDJF/g33gReKQ3Diz8yJ2NGKM
         AAZZxm0W+THdgSegqOnMDjAJ7ROGJlTp685zWgiHlf+RK8Dsx0uHnDDNqqqLMTVU4iL6
         84pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjgLodXaWd73j2zyesKlCdIE6TT7rzt0M4RC+B5RhmU=;
        b=l9UmPoNd5DHmnYCUr8/njAs19TWZKk5QsGPMtyYLbZubmlMLyjVn7LELAqR+bt4qCC
         1SvrkGt1uqvpTft2d6idp4DLcztnd2Oen+9evyDGVFalZjNP4MF+FwqlJp3faAKK1+rf
         bu2VMmW+EL6MzpCVoWzic9ADMBNZ7GEh8qiPzrd3/kYVU0fWmp8mlElEulyZOHE8vNZo
         VJZULCsQsxVvfA6tlr7AgYTwhldnTqQuX8sf+37f2CC6bqGNv44wFxlVafZsLqfkDKK1
         UHzcXljvE/Pa+qZZLLNJE1srMgfiz0fhAVaDY8/cjk1fFac0QHzqgM8ImBCrebJuRGPi
         etXw==
X-Gm-Message-State: APjAAAVjAs5PWVrBQybY65oMjtfuTgvouDi5QbRO4XH8FRGozm+78Jih
        U3kLv9oSpGAitacZVUwIFKyX5s4213z1BtM6WvldLA==
X-Google-Smtp-Source: APXvYqxE9GZVZ2m2dymDlGllkWbXRVZjcBp6zgKs4vf7bYIw01enMLGeeFMgMPGy5u6mIsftP34gGtVARJ4eZ/99ftY=
X-Received: by 2002:a19:a8cf:: with SMTP id r198mr17033593lfe.19.1554068105054;
 Sun, 31 Mar 2019 14:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com> <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
In-Reply-To: <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 31 Mar 2019 15:34:53 -0600
Message-ID: <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Glenn Trigg <ggtrigg@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 30, 2019 at 5:43 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
>
> Hi Chris,
>
> Thanks for replying.
>
> On Fri, 29 Mar 2019 at 13:27, Chris Murphy <lists@colorremedies.com> wrote:
> ...
> > Seem in conflict. I don't really understand how the kernel complains
> > about a bad super and yet user space tools say they're all OK.  What
> > happens if you try:
> >
> > # mount -o ro,nologreplay,usebackuproot
>
> I got essentially the same results...
>
> % mount -o ro,nologreplay,usebackuproot /dev/sda1
> mount: /data: can't read superblock on /dev/sda1.

I'm confused because "can't read superblock" isn't found in fs/btrfs.
I'm only finding it in fs/gfs2/ops_fstype.c

From what you provided, /dev/sda1 definitely has a valid btrfs
superblock. I wonder if there's some other stale something or other on
this partition?

What do you get for

$ sudo blkid
$ sudo wipefs -an /dev/sda1
$ sudo mount -v -o ro,nologreplay,usebackuproot

-- 
Chris Murphy
