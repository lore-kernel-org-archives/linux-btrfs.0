Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31FB0C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 00:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCDE20858
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 00:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="s5RuQulZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCCDE20858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730378AbeKQKdh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 17 Nov 2018 05:33:37 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:37261 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbeKQKdh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Nov 2018 05:33:37 -0500
Received: by mail-lf1-f42.google.com with SMTP id p17so17686018lfh.4
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Nov 2018 16:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ka/68b+YhDv80BuEkU+OiTYkyeCeJADd+SmNIgWVV0s=;
        b=s5RuQulZgKOdJdHgXEzuDDAmN6UFmCVdPySmtWu/2EMNSnDUK2K6N+1MSM3DqeqWNe
         O6Yh/NHyALf6a/a3UobEQZ7i72nIQZrZj9oY+5EWhNGOdyjlZ0m/69icSX8t2eSgCuVQ
         rdFIQU69P4Q5rVeECJ5s2VwBusIGk6OaAyYuWCZkbAI5+4lOFB2Wp8HhROfachfNgijz
         2TxOCsGRJolEz2O9kegoECPU+B//8lFLKZRtIMzeKST6F+JqvDrz5OGJaOlgae8w4aME
         +DWLOtsl6y+jv7eLs3tST3fkGRc/rc6EKgDHHUpGdZtUqz1W+oZ9iBLtADeK/bK+6pL/
         V/Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ka/68b+YhDv80BuEkU+OiTYkyeCeJADd+SmNIgWVV0s=;
        b=ogyrJd8TAv+lh9UHko+Zg4Yue2WD/uq6oGRl7hMCtRJpmdJ9JT86xNFbfhCn1lPmTq
         Df68M3w6dXfcj5MkLMOmlTBZGMBS+3nOEQjcEZ0a6IR/h/5h7vX7i7fiDAaT/hO606n6
         jA+PsqQxFczqrX3YpRScvWqhiChaer0mCuPytQKxCGhtxJwz0mWmD3hSfnVnakQ3Cnr8
         u7+drHKpYhF3rVhTpd/ooxKOKQ3bDMS8YpnUuP2kqqFUGOFjl1DEiZz5/JG96xzGplrU
         oIs/IBf6Odp6WMR3+Jst8a53seVu8sAphMJiNnJbgo2olP/f1fefI0bEFXgRZC5Bk29g
         AxKQ==
X-Gm-Message-State: AGRZ1gJkbJJ2s6cjOlLtdoKgwAEYnYhsVKlBeoz+pT4w+/1UvNJYK0Fo
        2ZnSFnBc5dfKFgsXpYjtOhJkLv8Y1EcL8X4oHSA4BAbrqVE=
X-Google-Smtp-Source: AJdET5fvZu1xKNt6dBJnNJ48Wp92ZnwJ3HzolFCWIXu9ElsVIOSr9Uec/HK77jeDFqqodVByOQB7jqjs19I0nDcE5dI=
X-Received: by 2002:a19:4e59:: with SMTP id c86mr6949167lfb.132.1542413943220;
 Fri, 16 Nov 2018 16:19:03 -0800 (PST)
MIME-Version: 1.0
References: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
In-Reply-To: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 16 Nov 2018 16:18:46 -0800
Message-ID: <CAJCQCtQwqKYqO1h1SxsVZubUKGHjJnOd_3Atwe-bkzU_O__-Ng@mail.gmail.com>
Subject: Re: BTRFS on production: NVR 16+ IP Cameras
To:     Juan Alberto Cirez <jacirez@rdcsafety.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 10:39 AM Juan Alberto Cirez
<jacirez@rdcsafety.com> wrote:
>
> Is BTRFS mature enough to be deployed on a production system to underpin
> the storage layer of a 16+ ipcameras-based NVR (or VMS if you prefer)?
>
> Based on our limited experience with BTRFS (1+ year) under the above
> scenario the answer seems to be no; but I wanted you ask the community
> at large for their experience before making a final decision to hold off
> on deploying BTRFS on production systems.
>
> Let us be clear: We think BTRFS has great potential, and as it matures
> we will continue to watch its progress, so that at some future point we
> can return to using it.
>
> The issue has been the myriad of problems we have encountered when
> deploying BTRFS as the storage fs for the NVR/VMS in cases were the
> camera count exceeds 10: Corrupted file systems, sudden read-only file
> system, re-balance kernel panics, broken partitions, etc.

Performance problems are separate from reliability problems. No matter
what, there shouldn't be corruptions or failures when your process is
writing through the Btrfs kernel driver. Period. So you've either got
significant hardware/firmware problems as the root cause, or your use
case is exposing Btrfs bugs.

But you're burdened with providing sufficient details about the
hardware and storage stack configuration including kernel, btrfs-progs
versions and mkfs options and mount options being used. Without a way
for a developer to reproduce your problem it's unlikely the source of
the problem can be discovered and fixed.


> So, again, the question is: is BTRFS mature enough to be used in such
> use case and if so, what approach can be used to mitigate such issues.

What format are the cameras writing out in? It matters if this is a
continuous appending format, or if it's writing them out as individual
JPEG files, one per frame, or whatever. What rate, what size, and any
other concurrent operations, etc.

-- 
Chris Murphy
