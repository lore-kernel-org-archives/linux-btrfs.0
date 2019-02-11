Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABFCC169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 21:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1D3C214DA
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 21:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="HWLTlCIR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfBKVPu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 16:15:50 -0500
Received: from mail-lf1-f45.google.com ([209.85.167.45]:33141 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfBKVPu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 16:15:50 -0500
Received: by mail-lf1-f45.google.com with SMTP id q12so305607lfm.0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 13:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0no8IhLN5v+PhAD3U2FQx1hprjXiAQU3C6iXUndJ9Vk=;
        b=HWLTlCIRlTbN4WhJKvEFtW1Fl7OCUenV3J7NJsu9CgVR/LR9Tz332UdHZtenzZD1Tp
         Mjck/B28fODKe3mKEJtZr94mTW/OVDkN2pPYOuQPwTfshZlZheOkFz3/2xMHR/ETRcae
         hLRZ2iDP/iYTr6D/8axtnSclP5xeD2X6jneRTeEkxVD/pvoS5zf3U+WSKbeYh7Z9W88b
         yS5Fa0Q7pGBEA6+eOxNDoguopKFEPTY4rGlraleh/Kb/z26LiDN7a99R+GS7Fa9s3x/W
         tjKAKtKG3x7Z3tTCmCBqGNEKjj8TlOQVOovzUyqH+oeJ8qTTgRil1VEqX5Jl8btg8pJ6
         Wr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0no8IhLN5v+PhAD3U2FQx1hprjXiAQU3C6iXUndJ9Vk=;
        b=YMYrQmwOeb2vmISAmTehDwH+khixzo/pmwdkA10WleFgKJzu2qpRucbnIML/fJmhEo
         liMUFVJ4TpeAuUG99FnRFnvDwbd+0+WsK6PI+gb4vpDhJY1oCz9yhtcV0DQX++uxsGWl
         U0Nin29RYdrgi3AGRm3No45DfmPwctt6VDp3Avd48uURL82sujgIgNza0pwAgZ8K0N4C
         b+pzOQIrqoHaGNHMxnaonk30bCc1lUpKPh0MqkyAucEM7EV1QqR74L/q98KvpkuU7L66
         W7fqbY5CDwLPf4GKWwRLWqL512i8uQKbXAukkILHTNu0auY1hvnLFyfutbvIbjHio9rw
         XWwg==
X-Gm-Message-State: AHQUAuaZhoSgxPGnt/RGfJucEfRfRHf3Ypg5qDODDDRSaA5oTI6yOJWN
        HwBFhlWK0hqjRUKoruG/x1Iko+N560aYhN3YWSmf+w==
X-Google-Smtp-Source: AHgI3IagZzDVhtpfArGE74mWHw3qfKGP1Akw8kSOXP2dSSWdn31Fee7Pkz9FVAWhKBMVLJ4yztqfXoNFR4ZcoyKyqSc=
X-Received: by 2002:ac2:4116:: with SMTP id b22mr127410lfi.19.1549919748344;
 Mon, 11 Feb 2019 13:15:48 -0800 (PST)
MIME-Version: 1.0
References: <33679024.u47WPbL97D@t460-skr> <92ae78af-1e43-319d-29ce-f8a04a08f7c5@mendix.com>
 <2159107.RxXdQBBoNF@t460-skr> <b08e9876-3493-1a14-5152-e2fa0a2c24a3@gmail.com>
 <f4f899e3-0d1b-2f82-54cd-3552e186db6a@dirtcellar.net> <c8708ebd-c6c2-6916-6da2-5b415c0585e4@gmail.com>
 <c7ef67c6-a38b-a632-fc5d-b839940c2877@dirtcellar.net> <f41063e8-b9b1-f929-7954-8a96e673bd2e@gmail.com>
 <f67c6a69-4fc8-e33a-543e-9b97adf54438@dirtcellar.net> <CAJCQCtQ-nLkOYE5ARk+rjT4JBxR6Atn1gU-+U8gAT0sb7Mduow@mail.gmail.com>
 <a8e00ae7-9e18-ba74-5521-a2db7b525e51@gmail.com>
In-Reply-To: <a8e00ae7-9e18-ba74-5521-a2db7b525e51@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 11 Feb 2019 14:15:35 -0700
Message-ID: <CAJCQCtT27ONP4W30Q220OEHyXmypMM0oqng6sbRwzm9JJ3k8EA@mail.gmail.com>
Subject: Re: btrfs as / filesystem in RAID1
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        waxhead <waxhead@dirtcellar.net>, Stefan K <shadow_7@gmx.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 5:17 AM Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> Last I knew, it was systemd itself doing the pause, because we provide
> no real device for udev to wait on appearing.

Well there's more than one thing responsible for the net behavior. The
most central thing waiting is the kernel. And that's because 'btrfs
device ready' simply waits until all devices are found (by kernel
code). That's the command that /usr/lib/udev/rules.d/64-btrfs.rules
calls. So it is also udev that doesn't return from that, indefinitely
as far as I know. And therefore systemd won't issue a mount command
for sysroot.


-- 
Chris Murphy
