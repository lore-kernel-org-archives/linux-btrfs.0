Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34E5C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A31020657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="cZRBV1XV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfAPBLy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:11:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43738 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbfAPBLy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:11:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2-v6so3993271lji.10
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rv9w1QfgdPJ0n6pwSL45fxMOvjr+8ZD8KNsKIrKaDg4=;
        b=cZRBV1XVLzZ0cfxE5Ny3VFGtV7qQuwnFGaMF0gpLNYCBGKUQqer7OgHVaznHb+yiKb
         VhPrxmRdD2vsOeIMfLQz0BFAlocNT0WcHCL106POsfRvQhZmqz1PKGsnTLDxy/6xQHHn
         UucuucjD5bdyu/w+yjcWY+km01q5imQ3H8JCJePYoXSdZmIzKpUQM4ik4sdoLKfBkX8x
         L7QVvVx0H1BeAUrQkBBGyTaMem/amvGaLxGf4kmlsmIGeyEVAHLspGv0+8Mr2xWY6xvs
         JuA/EKwxVHNlevgy5SIrzAdbH0Xk9wVijkb0B8vMK4Yt21LOZUZ2GhvK0VSxO7rxyS5L
         kSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rv9w1QfgdPJ0n6pwSL45fxMOvjr+8ZD8KNsKIrKaDg4=;
        b=QP8g4J2lDFw6UjMIopTO+RmXYAHjSWaGXeeupYuVjJ6W9kn+aCq7A1NJpHdbCAggHZ
         kfrTnO6KezUpOr5p2IX7n4PeV/Y5MRChtkQaatGkEY/P9ejLc6l9oJJeli1aK68oduRK
         LNfsArRuQOXN7NuCT5vNVuhjHolE2WjUtYrDhIQhvQrTP7OF8GzI2VALRDlj8O+969de
         WiYNG2lquU2sxx8Lh9e/ORYUh0OcN03OXRHu9NuFgIX6KoJSopycjekx0NXBe/YyCGLB
         Ba0JC7mw+6xHrC4WhK/18Ypxt9LWylbJzZMwJsVuWLpEtN15kiB7yStl+9VwxGXatcwz
         wqWA==
X-Gm-Message-State: AJcUukf+wossZo/Oz3VH/Fd/9Oa5LK+lEgqeYS48cpaBx9GURGZdGtH6
        aipV+KHdZLI7m7L4kh8IJgZT18qm2r805+XWyrJS1oT5w/4=
X-Google-Smtp-Source: ALg8bN59kSn0s1K5Bof0RP+qSG/PGpJGaAd9ZzDKKPS5i9HjgyBiJghvbwzfH7dIG2xWkBR5odX9drSQeRdjUz5ZQ40=
X-Received: by 2002:a2e:9ad0:: with SMTP id p16-v6mr4950760ljj.102.1547601111656;
 Tue, 15 Jan 2019 17:11:51 -0800 (PST)
MIME-Version: 1.0
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com> <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
In-Reply-To: <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 15 Jan 2019 18:11:39 -0700
Message-ID: <CAJCQCtTzUHw5COdsEjskAHWJhAiiyOBtAxT0f7cf6oeziQ=1gg@mail.gmail.com>
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Oliver Freyermuth <o.freyermuth@googlemail.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 5:41 PM Chris Murphy <lists@colorremedies.com> wrote:
>
> The relevant error messages are:
>
> unable to find ref byte
> errno=-2 No such entry
>
> Somehow a reference byte has been corrupted and inserted into multiple
> locations in the tree and it's not repairable: i.e. neither a correct
> value can be inferred from other available information, nor do the
> tools have a good way to just trim out the item that contains bad key
> pointers - part of the problem with just cutting out the bad parts is
> it's not clear the problem is made even worse or how far the
> corruption extends.
>
> What's further troubling though is the idea that this corruption might
> have propagated to a separate volume via snapshot send receive. Either
> of the file systems might still be useful for a developer, it seems to
> me important to have some kind of check to make sure it's not possible
> for corruption to propagate in this manner.
>
> In the meantime, I think it's a good idea to do a memory test. There's
> some information in the archives about how to do this in a more
> reliable way than just memtest86 type tests, but if you can run even a
> memtest86 over a weekend it might confirm there's a memory problem.
> Unfortunately a pass doesn't necessarily mean there aren't rare
> transient problems.

Also, this could be related...

[ 4368.361487] CPU: 0 PID: 23915 Comm: kworker/u16:11 Tainted: P
 W  O      4.20.1-gentoo #1

Do you know why it's tainted? Looks like an out of tree proprietary
module. And also there has been a previous kernel warning but that
part of the dmesg isn't included. It's not possible to absolutely
exclude an out of tree kernel from being a source of memory
corruption, but it makes it a possible suspect and therefore it makes
tracking down the source of the problem harder.

-- 
Chris Murphy
