Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f169.google.com ([209.85.208.169]:45123 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeH1Ri7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 13:38:59 -0400
Received: by mail-lj1-f169.google.com with SMTP id u83-v6so1451055lje.12
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 06:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 28 Aug 2018 07:47:12 -0600
Message-ID: <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Menion <menion@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 3:34 AM, Menion <menion@gmail.com> wrote:
> Hi all
> I have run a distro upgrade on my Ubuntu 16.04 that runs ppa kernel
> 4.17.2 with btrfsprogs 4.17.0
> The root filesystem is BTRFS single created by the Ubuntu Xenial
> installer (so on kernel 4.4.0) on an internal mmc, located in
> /dev/mmcblk0p3
> After the upgrade I have cleaned apt cache and checked the free space,
> the results were odd, following some checks (shrinked), followed by
> more comments:

Do you know if you're using Timeshift? I'm not sure if it's enabled by
default on Ubuntu when using Btrfs, but you may have snapshots.

'sudo btrfs sub list -at /'

That should show all subvolumes (includes snapshots).



> [48479.254106] BTRFS info (device mmcblk0p3): 17 enospc errors during balance

Probably soft enospc errors it was able to work around.


-- 
Chris Murphy
