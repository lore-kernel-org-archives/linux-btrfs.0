Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E163FC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1702206C2
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Srppplfu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfAQAMq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 19:12:46 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43358 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfAQAMq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 19:12:46 -0500
Received: by mail-lj1-f196.google.com with SMTP id q2-v6so7000947lji.10
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 16:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VBjUp0WTwzxJ2rX4EQGhAfRFsjmWHRnDjxzlFqg9BSA=;
        b=SrppplfuCJkNSSnb/b+TeGbiUQOh3oYwH0A68e1v6FCzyQw+tPtu3RdH5CPrIglM2+
         X9r95gy6D7DcjJ1aCUf6AhrS23A5yDCvT5O/i+qrF9RhQ8ZmbYNldQ9FQewwYtt9Xluv
         L8Z4SZt+Ik1faVxi34LgkDNyDqNV0gSbhibfhOsROtGkLOLt1ph3eFh1yxN8V5/kBKWP
         VvhrwQphwopooPV1CPylBeK14D3739D2/8CI/g8gkAg7ybYdznGZzL9zZUlvg+Qnz1ye
         pdz67UP1tKbjtV/+GOZxuydZZpBLf/wcHylNHnQmMppxX5ix2ZbbdyVOXMbeXXwY8N4b
         emcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VBjUp0WTwzxJ2rX4EQGhAfRFsjmWHRnDjxzlFqg9BSA=;
        b=f79D38N/cnDNjo63Kxhh3a7ihep6ap8WnKUF1Obs3ufsgnwrW9eG+VKGMU85S/FK+r
         UGa88iLhmzDRlHCTMKo9O7GLNLITBFOdkzQhUBaZx+8Ko1PnZfX8vYzktAWUH63p8zH8
         Xyw+GplqyNIdj/NzVgMV/yMQeJU4xPkDh/yBblNnUk5bTy+4HcME7Cf7OL2CloSgIY6p
         ltkcAnTH6tZxbatD7zcfBIkLv9pB65yPkD2iPOIMf8A7cEWmCDNTlVQDVy1nGkH/nE4C
         wwCVR3ro77zHO6xCBUbtGXQ/j7luYiGf8a81KyGp909vaGsTtSzSXiHxc+g/Vm6oQftZ
         6Mlg==
X-Gm-Message-State: AJcUukdSiyhgRAKOU1Yzj5TgIkCcmqs+HmCft4J4ZvqNQXwc7sP5qMyi
        pccU0cu1/9VFXlAb1RD0wt3XFO+5+HapCSgVGU8RTw==
X-Google-Smtp-Source: ALg8bN7vASqw8VVO1LXZoXQ87P/5JdlXtB6jGQMLnGWUkaSf7ubesWOWnJwQUwbfpPYwBn1YxXXSBKYEHfMP+oGfcpo=
X-Received: by 2002:a2e:880a:: with SMTP id x10-v6mr8854732ljh.174.1547683963835;
 Wed, 16 Jan 2019 16:12:43 -0800 (PST)
MIME-Version: 1.0
References: <6760df5e-a757-56a0-d8c9-3f172458fc65@ch-sc.de>
 <CAJCQCtS9KC_Vrc0qFsvJRFq5cWgxPi5xx7NMVtGAjn2iqokK+w@mail.gmail.com> <9cb26e7c-e763-0186-40cf-4d8a9c6e6cd9@ch-sc.de>
In-Reply-To: <9cb26e7c-e763-0186-40cf-4d8a9c6e6cd9@ch-sc.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 16 Jan 2019 17:12:32 -0700
Message-ID: <CAJCQCtRMZDS7UFiEE+2irjyZcAWqz711vPWuj2Na59zbJCSgBg@mail.gmail.com>
Subject: Re: issue mounting volume
To:     Christian Schneider <christian@ch-sc.de>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 11:22 AM Christian Schneider <christian@ch-sc.de> wrote:
>
> THx for your hints!
>
>  > Your problem could be due to a block layer bug that's been discovered.
>  > It should be fixed in 4.19.8+
>  > https://lwn.net/Articles/774440/
> I looked into the article, and it mentiones, that the bug occurs, when
> no IO scheduler is used, which is not the case for me. So, I would rule
> this out.
>
>  > 'btrfs insp dump-t -b 448888832 <dev>'
>  >
>  > and remove file names before posting it; this might help a dev sort
>  > out what the problem is.
> Have done this, though no file names appear there. this is the output:
>
>
> btrfs inspect-internal dump-tree -b 448888832 /dev/md42
> btrfs-progs v4.19.1
> leaf 448888832 items 29 free space 1298 generation 68768 owner CSUM_TREE
> leaf 448888832 flags 0x1(WRITTEN) backref revision 1

OK so for some reason that leaf is considered stale. I can't tell if
it really is stale, or if the complaint is bogus. The generation for
this leaf is 68768 but the current good tree expects it to be 68773,
which isn't that far off. Some decent chance it can be repaired
depending on what was happening at the time of the power failure.

What do you get for:

btrfs rescue super -v <dev>
btrfs insp dump-s -fa <dev>

These are readonly commands and do not change anything on disk; just
to reiterate I don't recommend 'btrfs check --repair' yet. If the
first command reports that all supers are good, no bad supers, then
you can try

btrfs check -b <dev> which will use the previous backup roots and see
if there's anything that can be done, or if it falls over with the
same complaint. It is possible to use your btrfs-find-tree results to
plug in specific root addresses using btrfs check -b <address> <dev>
working from the top of the list (the highest generation number) and
work down. But for starters just the first two commands above might
reveal a clue.


-- 
Chris Murphy
