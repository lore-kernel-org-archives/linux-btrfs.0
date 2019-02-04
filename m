Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88B5C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 17:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 805BB20818
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 17:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CrMBTVJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbfBDRrR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 12:47:17 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]:43051 "EHLO
        mail-qt1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728589AbfBDRrQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 12:47:16 -0500
Received: by mail-qt1-f176.google.com with SMTP id i7so808194qtj.10
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Feb 2019 09:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b8zDBYmB+PpEqplJUqnw+SqoWq/UK/HrOz/4tRKyTsg=;
        b=CrMBTVJcAh3Ce51k+YqmaUJPYS/lFT2dmB2vwYi7TAgiUMpNsM3728MWYFzuwo+nqY
         RsdzYIZ94CqMnTMC349x4+mytDxc68kPMQOHIoOzyzHMgyPTCcOtRa1TdA1dtD4uRy1M
         iZTXa7uV4t2Y/tWeDl2TDRGrQjqht497K+wE4+oozTdGfW/sMGV5SFlUhzLvxzSHJM8o
         9BwPfDpG1D+rnF1jLTTQGCKfXHc49bSuGQuvA+QomQJQf57F4tibAIOo4T6ste/sNwO/
         tHIVCrcMkN6KvuZGYSBa5jlqMgglP85GbzbdT3I1VAPozPCOUYt9DGBJRYFrhiRC/5I/
         T1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b8zDBYmB+PpEqplJUqnw+SqoWq/UK/HrOz/4tRKyTsg=;
        b=c4Ospmx/ESODL8Tsm33ghjsv+F39PngfXe4lTgrY5Ad3GxGFBtXjF3sOzj4thqclCV
         In3ZOOKICsFgm9a6wA65gw7aX7P7j729PNFejBk+LokR5YNp/1fNvxkp5cxmFy/50Q06
         d+ZIgaYn5QNvnbcPe1bOl9N+wkEihBPC2QAEvQfKvtK1h6hvrFNVPtUjph5RIvoSrjTg
         6D6ScjtknB5Ar6Kar3JNxsdeV2ux8W9283yjfNrSDoMKFoaLQP3O2s359b3sUWmgzLtU
         K9YWDH8cUly2Ko5DWWCyfCD536iOOoVioeed6FzI82mFJ3W2UUVffmfn6f0AyfscpQ7L
         tRfQ==
X-Gm-Message-State: AHQUAuZ6q/iNaVpPh9mh46SHEg2+rJ3kxYcR9aZtJPSyr/xPKtaOVb8+
        mamND8zPcELh5StUTXCM1S4bW/97VE1hI+hsNVE=
X-Google-Smtp-Source: AHgI3IZv1qRPitSGAcILzboQrf9MPvWxh6N88KNDJOAorf1ymYaNjRard94KEuu8c9uXg2kTywT7F2FgFZcVP49ssLQ=
X-Received: by 2002:ac8:8f9:: with SMTP id y54mr450464qth.19.1549302435781;
 Mon, 04 Feb 2019 09:47:15 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
In-Reply-To: <CAJCQCtR=WZGk4eaG63_-uqb0wzGVDDrS1SsxhzxT7k3qbWVtCg@mail.gmail.com>
From:   Patrik Lundquist <patrik.lundquist@gmail.com>
Date:   Mon, 4 Feb 2019 18:47:03 +0100
Message-ID: <CAA7pwKN9B7LZEo7Op0PndTnU6jo3JdtLi0vdphXZakgbKBB-9w@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, 3 Feb 2019 at 01:24, Chris Murphy <lists@colorremedies.com> wrote:
>
> 1. At least with raid1/10, a particular device can only be mounted
> rw,degraded one time and from then on it fails, and can only be ro
> mounted. There are patches for this but I don't think they've been
> merged still.

That should be fixed since Linux 4.14.
