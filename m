Return-Path: <SRS0=C9fc=QR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA1FC282C2
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 18:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A783120873
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 18:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="DmMTOqBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfBJSoV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 13:44:21 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:42550 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfBJSoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 13:44:21 -0500
Received: by mail-lf1-f53.google.com with SMTP id l10so6046546lfh.9
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2019 10:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jg+b11VZWmTS+c1FMnav1EQDtjFH4G5zq4RNLdjjigI=;
        b=DmMTOqBypi6JMwZXpEtiAUvdc5dcjb76gH66HkF1Do/ALmzqq+Bcx9LzzhRNgXZ3jR
         UbNaSGFdP4ROsqdZE/uannXPB9r6yibNgkbNPCJwhw22Tqtwt8IsAD3HOvT0cRwzSQ1A
         eFbZc1AZmJJfPeEbhbFmnzyiQtlONbNlkTKpuOx+IN4XuXPprGVROLPMJaLrTtmAtYX7
         VMX7nAViWRehfh+RTC0zXuNztQxOyZmgSFCkEk9pHN9aBs4QkzTWsBvUhGkZJqqeUge8
         qWpd61ZyEGxVXgatUafTlABJ1jsqXJQmshelRSgEJNtOHft27wXVoJ1XC7mYXFz90hxq
         kdLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jg+b11VZWmTS+c1FMnav1EQDtjFH4G5zq4RNLdjjigI=;
        b=iPpL8T3kxolrFoKPG7Z644BObOcdRROL+wnTQbll0szR4l7FuU0rykVO9uA3JTrkoI
         UBr7AdSYR1MVRbznfvUR9//peolLZc2LdZBSaCMklD2KjZG3az81rXJ7F3HUbAHmA7cj
         irnR6ncAein15JSdCn/RNA+E7SgfFiaOOUXw91IbYezs7qkwxxG5cqzB7iR3193KADmG
         PpwQftI2p+GT8y1aNpT670mCyXFbUlZvDL7ZKWRPR+DNsErNNh9sbkU/Ur223Ek0ggkn
         lzgEPmFyyTuvM8k5uU3mstBlC0JbChKbOL0QUzER6YyOeonQEBqh3uFI/oLkffRQlNjI
         iT1g==
X-Gm-Message-State: AHQUAuYvFOJ4zfp5RivAjk2MLjqPNZ4pnRHOqIq0y2Uc8o0P//cPYIHG
        gPB7tTSr9lanGmOc9+nI2F9b8GZ000c+gvAdS/Tu8MLf
X-Google-Smtp-Source: AHgI3Iabx1cEBMzgRNOFbN5OttY0KNNtTJ6Yl2kffH7GMWGehQL1tUJCDcXbkuPAxccXNl1Z6+d74yBuMt5b9on1QaU=
X-Received: by 2002:a19:cfd5:: with SMTP id f204mr19997651lfg.65.1549824258859;
 Sun, 10 Feb 2019 10:44:18 -0800 (PST)
MIME-Version: 1.0
References: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
In-Reply-To: <2efee604-e44c-b00b-2ea8-d13ebc8c6355@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 10 Feb 2019 11:44:08 -0700
Message-ID: <CAJCQCtSY8JR4G5JKLaKn-uT=CV+SMDom0j3Nt98wEOE9k=F-uQ@mail.gmail.com>
Subject: Re: Cannot 'mount -o degraded /dev/replacement' after a replace
To:     =?UTF-8?Q?Jakob_Sch=C3=B6ttl?= <jschoett@gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 9, 2019 at 3:36 AM Jakob Sch=C3=B6ttl <jschoett@gmail.com> wrot=
e:
>
> Replace device 2 with device 3:
>
>    mount -o degraded /dev/loop1 /mnt
>    btrfs filesystem show   # to get devid of device 2
>    btrfs replace start -Br 2 /dev/loop3 /mnt
>    btrfs replace status /mnt   # check success
>    umount /mnt

The first command causes the creation of metadata and system chunk
using single profile, on loop1, and even after a replace, both devices
know that there is a single and required chunk on loop1. So subsequent
degraded mount fails because the volume was not fully redundant.

The missing step is between 'btrfs replaced start' completing, and
umount. There needed to be at least a 'btrfs fi us' to check if there
are any single chunks and to convert them with 'btrfs balance start
-dconvert=3Draid1,soft -mconvert=3Draid1,soft' where soft is only possible
if there were no data writes while degraded; if there were degraded
writes, a scrub is also necessary to make sure any single mirror raid1
chunk writes to the degraded device are replicated to the replacement.

Yep - kinda ugly. And not intuitive. But that's the present status.


--=20
Chris Murphy
