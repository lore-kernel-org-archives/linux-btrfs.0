Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF580C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D704218A3
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 13:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAUYx4wp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfC3NPC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 09:15:02 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:39320 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730813AbfC3NPB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 09:15:01 -0400
Received: by mail-ed1-f44.google.com with SMTP id p20so4327522eds.6;
        Sat, 30 Mar 2019 06:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U9wsTFQwq75miCcVWpBj/F/BMRslW1+abyHXCYtcnH4=;
        b=CAUYx4wpiF5IKSbHSPZxMxySvtGOvPqGZ3wDvi3xyHNXtHNejkq75wQt5CRV3gvWi4
         LLr6vQrang4UoaUlGeJKHMO/Z/Hgukk49nngJSSSR5tjxYQCdlRBdNvEEog2zWEc8qmz
         rbaN/qrOrPxY4BrMVgWW3E3GAdkhjBv6hb3nWv4wXapm4ThSnkPzS9Lxx8c/OKYNFIvU
         AvT6SJ9x2KCmxQF2DZHxZ1uRoT/4MobFxiENhZB9DhB7z17dyCkKlYjX7HFvp3KXAYSp
         mCVI11yq72I2NVbJmt2ZDYrxjMAqM+Ef6k5nmCekORlnwgsfRBiyOeNuHPf/N9POsSgn
         cBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U9wsTFQwq75miCcVWpBj/F/BMRslW1+abyHXCYtcnH4=;
        b=MTrzav4lMy1JmeZpF0Ee2a4AE+ClG/u3TUvgqLVdmwuObqoh4ga2/PrDNjuGXmtytj
         sh4xwl8Yu55YEZyPVnzaO/2Sbta1USos0KvVXhOlx9ISq0TVaClRIxrCoQnf7uh34wON
         oknsCPVmk/XsHvI7nOZ4hwTJRpbPf4CQMfgKsTnDHsQ2jVP/K5yJp1IrwRMesYwPbgTR
         8LvzBkQXJ9pnBFZuHIHD9npg4Hd3qZmmv3viIgVHipKRizyVLDQSJGMxMX7zcwTihJXZ
         dGH4BfWXxBLcyERM2bMnHK8IPTM3i8PpuxOxIKeJ7v4QtjyP1MMEMe9E2OMsmZnjOxax
         6m/Q==
X-Gm-Message-State: APjAAAXMp/X3jGwLnu9WceYNcOd4t1NQUlvCih78e9Qfis1P4d5/f1NW
        ki6kuJtzBAxuvkVmGDBL2waO+5G4WiA4yAvYBws=
X-Google-Smtp-Source: APXvYqzBISVe9Z0djTFCnbZBkeBxveqprXoeCPuFLCQmb0PQr28TdvmzYiCaj+kpQ8U92I9NdvGG1/ICqO6/ZOnLa8A=
X-Received: by 2002:a50:94d6:: with SMTP id t22mr36826606eda.32.1553951699865;
 Sat, 30 Mar 2019 06:14:59 -0700 (PDT)
MIME-Version: 1.0
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com> <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com> <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
 <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
In-Reply-To: <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
From:   Supercilious Dude <supercilious.dude@gmail.com>
Date:   Sat, 30 Mar 2019 13:14:48 +0000
Message-ID: <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush correctly?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 30 Mar 2019 at 13:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> If controller is doing so, it must have its own power or at least finish
> flush when controller writes to its fast cache.
>

The controller has its own battery backup to power the DRAM cache, as
well as flash storage to dump it onto in the exceedingly unlikely
event that the battery gets depleted.

> For cache case, if we have enough data, we could still find some clue on
> the flush execution time.
>
> Despite that, for that enterprise level usage, it's OK.
>
> But for consumer level storage, I'm not sure, especially for HDDs, and
> maybe NVMe devices.
>

How do you distinguish who is a who? Am I an enterprise or a consumer?

Regards
