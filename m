Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7DCC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BC722084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 21:31:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="NLOD4FTh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbfBRVbL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 16:31:11 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:41409 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfBRVbL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 16:31:11 -0500
Received: by mail-lf1-f47.google.com with SMTP id e27so13353334lfj.8
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 13:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kRwjGGf9u2hoXxlOObpPGJPK+1SL2nmRIDPAUQrWJOQ=;
        b=NLOD4FThtrC0RasQ3Ya1QDZJN+JXnKXpnDHZeE4khKXGPllnZm6zUJWv6L2vMR7zRP
         +aIxE7Bqlw3zGZsdYbUDwgkeV+N+NkHphU3fZVC2xtD58swWQhwcFI3v1Sh5cpDxUycM
         Q/sceizQZiZHTbvsce5sO989ZEH0U6EKUoBWAZXrzHxIWBMQ5zrHLYJuvDRwcIpIQFj2
         hcVjlO7uvLMIlOStw0Q7UXkGZ3HNEuWsCScvr0j9hg8KVP6/oPU57V+FG0mVkkTN2I1c
         7Vx+bzFOd0Gw/loaI7/+5IGMZtucC6mWBNADMkjAuu2AfraEJ1D3PzLi5phR7WhejMSV
         KiXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kRwjGGf9u2hoXxlOObpPGJPK+1SL2nmRIDPAUQrWJOQ=;
        b=Ti+tVStl/8z60SUcCMAnWwcNJlE0eby4AzB/+q4cLvGmzhcOqYrU8pQCsy3nIX/1di
         EDed8CBqk1wynpFDqDRAElvs1TNQj7W5WpVV26MgEo7Yr8yInfurlPG+qIrIwLn5s24U
         eIan9Hh+x4o+BfC7WLqXhRTeQi4THN7tYBhaaWd8vCrndTM1M5QSmTZ8b6/1qOC8uKQD
         j6NXACyPQWYCPivk3Q4sob1oJVUzMdvJif7TUa12CNSRKNAwlQQC5qIsxvB5YzNnVWtY
         2zk5urOgXw4htGBIjo92/kYF8bVQE7cyrmZYOVF5h8OfK5Dz7k73pYB3zPfSBYkxypsu
         tjZQ==
X-Gm-Message-State: AHQUAubDGJ3SKfs32S6+2NS093BJBjSr8KvZRnYKjyxI6nrv7JG2IVAh
        trbJHNzOygbncqA9+I/mzmkPB4y+u/lunuSzGxi64UTf
X-Google-Smtp-Source: AHgI3IYRiPkwoutzr9Ksxh4cplDPafhNeLWdoDVRnqPA2Ip5WQzdnJ+K2zacw8YhGV3yjSzFsmQFvlHJW8THnN5wQP4=
X-Received: by 2002:ac2:4194:: with SMTP id z20mr14556847lfh.74.1550525469039;
 Mon, 18 Feb 2019 13:31:09 -0800 (PST)
MIME-Version: 1.0
References: <CAAD7_rAwZR6j=SgZOCx3C8dRM=BUZJVHDzSmj5rWB21HyWtqSg@mail.gmail.com>
In-Reply-To: <CAAD7_rAwZR6j=SgZOCx3C8dRM=BUZJVHDzSmj5rWB21HyWtqSg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 14:30:57 -0700
Message-ID: <CAJCQCtQ=1JLtd2BMeZu_=ydi+C=-2ao-ZtJwKWmi4TM=aA1FAA@mail.gmail.com>
Subject: Re: raid 1 filesystem corruption
To:     Rudolf Kastl <che666@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 2:19 PM Rudolf Kastl <che666@gmail.com> wrote:
>
> Any hints on how to recover is greatly appreciated.
>
> uname -a:
> Linux localhost-live 4.18.16-300.fc29.x86_64 #1 SMP Sat Oct 20
> 23:24:08 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs --version:
> btrfs-progs v4.17.1
>
> dmesg:
> [   46.918149] BTRFS info (device sda2): disk space caching is enabled
> [   46.918151] BTRFS info (device sda2): has skinny extents
> [  147.509999] rfkill: input handler enabled
> [  150.657962] BTRFS warning (device sda2): failed to resume balance: -4
> [  151.541975] BTRFS error (device sda2): open_ctree failed
> [  159.209490] rfkill: input handler disabled
> [  290.624978] BTRFS info (device sda2): disk space caching is enabled
> [  290.624981] BTRFS info (device sda2): has skinny extents
> [  294.350986] BTRFS info (device sda2): checking UUID tree
> [  294.350994] BTRFS info (device sda2): balance: resuming
> [  297.425043] BTRFS info (device sda2): relocating block group
> 1075919716352 flags metadata|raid1
> [  342.046679] IPv6: ADDRCONF(NETDEV_UP): wlp3s0: link is not ready
> [  429.588813] WARNING: CPU: 5 PID: 155 at fs/btrfs/extent-tree.c:1680

[snip]


> [  429.589101] BTRFS: error (device sda2) in
> btrfs_run_delayed_refs:3057: errno=-5 IO failure

This suggests an underlying block layer problem, IO error happened
outside of Btrfs I think. Do you have the complete dmesg?

Also useful:

'smartctl -x' for both drives
'smartctl -l sct erc' for both drives
'cat /sys/block/sdX/device/timeout' for both drives


-- 
Chris Murphy
