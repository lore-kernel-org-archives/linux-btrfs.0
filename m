Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4285C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 04:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A988A20850
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 04:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3rVre1p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A988A20850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbeLDEBC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 23:01:02 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39865 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbeLDEBC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 23:01:02 -0500
Received: by mail-io1-f68.google.com with SMTP id k7so12432760iob.6
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 20:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NMnIfxvC865jdl6yT4880xCFxy6zh/fKNCHXwxmPmyU=;
        b=Q3rVre1pr6614QoOZAU2GdtNEmzLbm59RliU7KVhO2oSQ4a/WVP6PVZuSF1m/iIjuS
         4lf5E1+SIZrxvVjX6QKQVElnTzgsAMm0xcPimLI4YNsPVerlvBVgSDeeEGhwDZERHIym
         S7ygf4+rA9R4eqkpEMp7hTMsanjPhsASxokx4hXXFK0db39xvySbyCoKCpSN3iE8xi0R
         SXKUtZZeJiG9YL9rhwPC5cGsuKIDXXQ45LlRkfbLjfqWNMfyUF+R8YmGWTdNu0MJnFTb
         z5Ae9NwDVl4SJnnrhtblP9IoLpFvN89lqO6NfHtLZlhMAF3vWPQ5W9KPTKtBdvAXkEO0
         uhig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NMnIfxvC865jdl6yT4880xCFxy6zh/fKNCHXwxmPmyU=;
        b=XuWDOP06Pp/Tz7xyaEXX05v7NpzMr+jFw8KARPeyEbZAi0TtfaR4Mt7nJa1dXgrHX2
         TZ2u7LtWP0jDOLIcOddLjT41ZpjH+DctZ4BAxNoK2tkOCbPL7tJ1Nc8aN0rgNnr98gIT
         p3E7r/B+btaHEytMRnCeIjufsCLYHLNeJM13Iq0HD76E/h5M4qYwc+G0dAWrQjJmGt2n
         6WAidmI4IbCpWefkJvMZ4+28EyU/7D9NLdz9AcfIiok6Sp3z9fngsvPTjeA6QZZNYU8T
         WWgWfymZ49Grq2RfWmslnFxmoh2wJX3zsDNcCsSHRGos1XHcTFEAJEIxjj5sD76hcH7e
         c/yA==
X-Gm-Message-State: AA+aEWbvHvX2K4V/AkGJbKvdDfO9TqnuOQzIjNyuJQo/YsH7Raw2kJip
        j5e/+UDJTN1Ef6MqixzmJVbeF7/bZy3Mj08hCsX5Z1veCTY=
X-Google-Smtp-Source: AFSGD/VAyO16Kfn6Li+vOARCYY/M+Elh40K3HOPrE9Q7jhcV+mpZBA6tMe1/C6YL39GX1uuPs+Pp6CNiAsJVpLd0ZiY=
X-Received: by 2002:a6b:8d11:: with SMTP id p17mr16541333iod.74.1543896061004;
 Mon, 03 Dec 2018 20:01:01 -0800 (PST)
MIME-Version: 1.0
References: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
In-Reply-To: <CAOv1SKD46XeF=iqi4At-0YJpK6nHQ+3ErKDN_sW_4fAPMyAgMw@mail.gmail.com>
From:   Mike Javorski <mike.javorski@gmail.com>
Date:   Mon, 3 Dec 2018 20:00:49 -0800
Message-ID: <CAOv1SKCkw4yKTw6McoE6pOU9V7v10RRr5naMdopoVHM-COShzQ@mail.gmail.com>
Subject: Re: Ran into "invalid block group size" bug, unclear how to proceed.
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Apologies for not scouring the mailing list completely (just
subscribed in fact) as It appears that Patrick Dijkgraaf also ran into
this issue. He went ahead with a volume rebuild, whereas I am hoping I
can recover having not run anything more than a "btrfs scan" and
"btrfs device ready" on this machine to this point since the kernel
upgrade and the FS was intact up to that point.

- mike

On Mon, Dec 3, 2018 at 7:32 PM Mike Javorski <mike.javorski@gmail.com> wrote:
>
> Need a bit of advice here ladies / gents. I am running into an issue
> which Qu Wenruo seems to have posted a patch for several weeks ago
> (see https://patchwork.kernel.org/patch/10694997/).
>
> Here is the relevant dmesg output which led me to Qu's patch.
> ----
> [   10.032475] BTRFS critical (device sdb): corrupt leaf: root=2
> block=24655027060736 slot=20 bg_start=13188988928 bg_len=10804527104,
> invalid block group size, have 10804527104 expect (0, 10737418240]
> [   10.032493] BTRFS error (device sdb): failed to read block groups: -5
> [   10.053365] BTRFS error (device sdb): open_ctree failed
> ----
>
> This server has a 16 disk btrfs filesystem (RAID6) which I boot
> periodically to btrfs-send snapshots to. This machine is running
> ArchLinux and I had just updated  to their latest 4.19.4 kernel
> package (from 4.18.10 which was working fine). I've tried updating to
> the 4.19.6 kernel that is in testing, but that doesn't seem to resolve
> the issue. From what I can see on kernel.org, the patch above is not
> pushed to stable or to Linus' tree.
>
> At this point the question is what to do. Is my FS toast? Could I
> revert to the 4.18.10 kernel and boot safely? I don't know if the 4.19
> boot process may have flipped some bits which would make reverting
> problematic.
>
> Thanks much,
>
> - mike
