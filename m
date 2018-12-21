Return-Path: <SRS0=cIUr=O6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E523C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 22:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0114621920
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Dec 2018 22:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="C0WlGpOl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404624AbeLUWZi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Dec 2018 17:25:38 -0500
Received: from mail-lf1-f43.google.com ([209.85.167.43]:40489 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbeLUWZi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Dec 2018 17:25:38 -0500
Received: by mail-lf1-f43.google.com with SMTP id v5so4923717lfe.7
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Dec 2018 14:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpd+XpVXe07YO2mHMrGUwhkEF8AnPWUWnCiRgqmqmdA=;
        b=C0WlGpOlJK0XeqYgD+wAYLi07TSmU6l9JEmn7nTpAxsnmpg2THoRIzoX/POaoG0EhM
         Wp5Sv2E2bEya9/tUfuP9cFXEbvSCuFrGymAz6LVqz7dg/KzVJViSDrfKX5G0Ig3bO2kx
         2I8aK8F6f3i0utS51iKBfEwZghoP90pR3mwBpUUYQMRDUKW9Wfhi2/1nbTVDE+pRdLUT
         OSjFKzcjft4TSoAeQfctvzVrEyfu2ui4Xqf9uZIxg1gBbj0BN9lByVdNXDop3ClAC3GX
         HXndN3mSMOjjxXUNX7CwlGXJvsIHaxgoruNc37pUZtJoSFPMsalfSW5aAr1iv2QPK4u3
         kxUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpd+XpVXe07YO2mHMrGUwhkEF8AnPWUWnCiRgqmqmdA=;
        b=d3fpXKebvkBRoKVpe4gZYk5tS5NTx5qcWRfBddvQxjKmCGt0zTsub4TURXz6Thp9GK
         jGX2nJGJzABtAAt0/d5z3bWHdcIf2y11MY9UugSLJHPGr2lKAZUnMoyTr69VMbLrYjdo
         D1kJO2sQvyfUrtOBuCTqD+pqFBNjFG5CQRNsTE0QdKbInX668NLPr9LBK5u8+2EBVReZ
         DEU39gZCTVyIqovEyIEVUEF6+VwUDSQzlrYqYlo1cql5b6+TKSAVsguv1+3wu03kCpZk
         4Nlq4us6OvmFaMLjiEwFqd6dxPa6cWK6iuOjRnVK3KU6/NlkDfL8GhDbIuwfn+WzIZBT
         AdDQ==
X-Gm-Message-State: AA+aEWbkifg8HSs+PqrDfSdqeCwbS3HpzgdBsxmVpYmM1FWw1UwyoD7H
        XlHIVC0y8rpgulTDqz4PX6q5OcwZtDtP+7kvXQuT1GFoK2I=
X-Google-Smtp-Source: AFSGD/XPTCHH4FHhazUoLE15xkNmbrbJilyTAx5Ta2HOt70vZvjdnAEf+O+F1nC1r6mlVN+DAWldgdHAI+FEhY0ihdM=
X-Received: by 2002:a19:a7c1:: with SMTP id q184mr2292997lfe.4.1545431136276;
 Fri, 21 Dec 2018 14:25:36 -0800 (PST)
MIME-Version: 1.0
References: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
In-Reply-To: <1aa82e28-3331-bc64-071c-6cf87b08ad94@petezilla.co.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 21 Dec 2018 15:25:24 -0700
Message-ID: <CAJCQCtRY-=AoHDxu--YOWfrs774QzrYj-AwvwD3H_YpTzDKfZw@mail.gmail.com>
Subject: Re: Mount issue, mount /dev/sdc2: can't read superblock
To:     Peter Chant <pete@petezilla.co.uk>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 20, 2018 at 3:23 PM Peter Chant <pete@petezilla.co.uk> wrote:
>
> I managed to break my root partition today.  Playing with GPU
> passthrough to a second graphics card, unsuccessfully, I suspect lead to
> some lockups and/or unclean mounts.

Should not matter, in theory.


> I've Googled a bit and tried a number of things stopping just before
> 'btrfs check --repair'.  I'm running kernel 4.19.10.  I now have the
> latest version of btrfs-progs, but I do admit to 'having a go' with
> btrfs-progs 4.4.something from a Mint installation.
>
> I've tried btrfs-find-root - and got the following:
>
> btrfs-find-root /dev/sdc2
> Superblock thinks the generation is 793794
> Superblock thinks the level is 1
> Found tree root at 1113905790976 gen 7937947 level 1

For all supers to be off by nearly 50 generations is really weird.
That's a lot of transactions to happen, and fail, and only for the
most recent super commits to happen successfully.

What do you get for ' btrfs rescue super -v <dev>'? That's a read only
command, I wonder if all the supers are really valid. And if they are,
then I'd like to see 'btrfs insp dump-s -f <dev>' and see if there's a
log tree. And then also the output from 'btrfs check --mode=lowmem
<dev>' which is also read-only, don't use --repair unless a dev
recommends it.


-- 
Chris Murphy
