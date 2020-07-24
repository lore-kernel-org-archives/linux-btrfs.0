Return-Path: <SRS0=zwEw=BD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B59C433E1
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 04:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10AAF206E3
	for <linux-btrfs@archiver.kernel.org>; Fri, 24 Jul 2020 04:41:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="n3BY9HLf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgGXEkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 24 Jul 2020 00:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGXEkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Jul 2020 00:40:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1847AC0619D3
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2020 21:40:20 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 3so119043wmi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2020 21:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6vb5xVlMf/vkwQt4Uiq7KsGFv95JjcOw9cqf76c2Zo=;
        b=n3BY9HLfMgXRVfxuqJO4dJXotVPp1FtbmZw1J8j+V1F/ODHviL6diE5tgyhVOhS8EY
         JnrbCsQJg7crp8Pc6ZxTwbP4xOejIxnAmadq3tnyUILKfnLiubojwdFEeJlU0nbSw9GU
         7a7qUvxMotyMEP1A7CqROODpPKwaTRJn/nvDRSY0JfQerXnM6uXkd8Sp0MNDqv4dJA/u
         xUtxtEhBsiI3Fc9ivjh1AcvRqSuICNWOROTzFq98E0wvK4spcqg7ly/M+vrJAhKU9BOZ
         F1kqbG6wURCJPaq2IuPIX1ho9TXnVBa8f3SZBQNRIuclFYR3yDKpRte8qe0wjpNOHcpu
         LdlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6vb5xVlMf/vkwQt4Uiq7KsGFv95JjcOw9cqf76c2Zo=;
        b=NHDGF7sT7BfJPKylkC9+YUSJ3QjgNJ6NUK9BZrrUHvOXCWbZvV20NN4pAlf+pbZJpr
         PYjcDn8RB6lCbET2Ak8tixj8bExKdIjTLcBBsPNuXxet3o5qhHYTw8j0gt0YsJWpD/a2
         8JtXNYMCim/ir9NDZwvrJThKI9tzMqbh9nZTll7Td9MCPFkgidlKcmLJd5NGflME9+WQ
         ThhuEJu4lPhD6TIQO9qqT2ek0LPU0546Rh+PHZOmnn0uYU8rPYT6LYbLw1hOiXgSHhRt
         N4koVWRv/WoK1Ex+6FfnXG7X2pgSYroAkGeeWN3QE4xvWu81RcIs8moWfJ1NsU7F/ZE2
         Q0NA==
X-Gm-Message-State: AOAM530krnhQz5TdQtSbygg4M+/ZkSuyaYkF0L+wus6F5xsnQCVTIL5s
        PP64yFry5WmB+wet8BrF9S+KDS6c/iX25DDu500mOBSp7sE=
X-Google-Smtp-Source: ABdhPJzijEpbbZziDbC4c2DZk23Tj2sa6hgxQnZm6HhzJAVMpjfCipjjXIItXvXjT89rFw1cBmXFVQxGEUrb6y34mug=
X-Received: by 2002:a1c:a756:: with SMTP id q83mr6675505wme.168.1595565618323;
 Thu, 23 Jul 2020 21:40:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAHzMYBTU=JuEsRX7YXzMJMELy63TXrm3J6onKnhGSOOzTnnMBg@mail.gmail.com>
In-Reply-To: <CAHzMYBTU=JuEsRX7YXzMJMELy63TXrm3J6onKnhGSOOzTnnMBg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 23 Jul 2020 22:40:02 -0600
Message-ID: <CAJCQCtS6eS7a+wHR__A_aDujANWNJEmUMApjChVMk1WNuZ0BKg@mail.gmail.com>
Subject: Re: df free space not correct with raid1 pools with an odd number of devices
To:     Jorge Bastos <jorge.mrbastos@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jul 23, 2020 at 4:24 AM Jorge Bastos <jorge.mrbastos@gmail.com> wrote:

> 3 x 500GB (not correct)
>
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdd1       699G  3.4M  466G   1% /mnt/cache

>
> btrfs fi usage -T /mnt/cache
> Overall:
>     Device size:                   1.36TiB
>     Device allocated:              4.06GiB
>     Device unallocated:            1.36TiB
>     Device missing:                  0.00B
>     Used:                        288.00KiB
>     Free (estimated):            697.61GiB      (min: 697.61GiB)


Looks about correct? 1.36TiB*1024/2=696.32GiB

The discrepancy with Btrfs free showing ~1.3GiB more than device/2,
might be cleared up by using --raw and computing from bytes. But Free
rounded up becomes 698GiB which is 1GiB less than df's reported
699GiB. Again, it might be useful to look at bytes to see what's going
on because they're each using different rounding up.




> Same for 5 devices and I assume any other odd number of devices:
>
> 5 x 500GB
>
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdd1       1.2T  3.4M  931G   1% /mnt/cache
>
> btrfs fi usage -T /mnt/cache
> Overall:
>     Device size:                   2.27TiB
>     Device allocated:              4.06GiB
>     Device unallocated:            2.27TiB
>     Device missing:                  0.00B
>     Used:                        288.00KiB
>     Free (estimated):              1.14TiB      (min: 1.14TiB)

2.27/2=1.135 So that's pretty spot on for Free. And yes, df will round
this up yet again to 1.2TiB because it always rounds up.



-- 
Chris Murphy
