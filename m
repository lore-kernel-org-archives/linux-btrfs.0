Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:46601 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdJVPIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 22 Oct 2017 11:08:18 -0400
Received: by mail-wm0-f48.google.com with SMTP id m72so5282879wmc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Oct 2017 08:08:18 -0700 (PDT)
From: Vladimir Panteleev <thecybershadow@gmail.com>
Subject: Re: 4.13: "error in btrfs_run_delayed_refs:3009: errno=-28 No space
 left" with 1.3TB unallocated / 737G free?
To: Martin Raiber <martin@urbackup.org>, 1i5t5.duncan@cox.net,
        linux-btrfs@vger.kernel.org
References: <pan$7012a$2aa3b3f4$9c2bb50d$e909647e@cox.net>
 <0caa6041-8ba6-52f6-950e-f07ee0470b63@gmail.com>
 <0102015f348e9867-37a2530c-b78e-4efb-9528-d13136194eae-000000@eu-west-1.amazonses.com>
Message-ID: <7ab8dd62-aaaa-b112-6643-6311290db03e@gmail.com>
Date: Sun, 22 Oct 2017 15:08:14 +0000
MIME-Version: 1.0
In-Reply-To: <0102015f348e9867-37a2530c-b78e-4efb-9528-d13136194eae-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-19 12:14, Martin Raiber wrote:
> You could also mount with
> "enospc_debug" to give the devs more infos about this issue.
> I am having more ENOSPC issues with 4.9.x than with the latest 4.14.

Here is the dmesg output with -o enospc_debug, hopefully it will be 
useful for someone:
https://dump.thecybershadow.net/266ad878bed7921ccca3a7f624df0cc7/scratch.txt

> for me a work-around for something like this has been to reduce the
> amount of dirty memory

In the end I deleted some snapshots, that seemed to free up enough 
metadata for the balance to continue. After 25 hours, a balance with 
-dusage=10 finished and freed up 344GB of "Device unallocated" space.

-- 
Best regards,
  Vladimir
