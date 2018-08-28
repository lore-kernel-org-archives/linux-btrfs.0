Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:40720 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1Ssi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 14:48:38 -0400
Received: by mail-io0-f173.google.com with SMTP id l14-v6so1694534iob.7
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 07:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
In-Reply-To: <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
From: Menion <menion@gmail.com>
Date: Tue, 28 Aug 2018 16:56:22 +0200
Message-ID: <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[sudo] password for menion:
ID      gen     top level       path
--      ---     ---------       ----
257     600627  5               <FS_TREE>/@
258     600626  5               <FS_TREE>/@home
296     599489  5
<FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
297     599489  5
<FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
298     599489  5
<FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30

So, there are snapshots, right? The time stamp is when I have launched
do-release-upgrade, but it didn't ask anything about snapshot, neither
I asked for it.
During the do-release-upgrade I got some issues due to the (very) bad
behaviour of the script in remote terminal, then I have fixed
everything manually and now the filesystem is operational in bionic
version
If it is confirmed, how can I remove the unwanted snapshot, keeping
the current "visible" filesystem contents
Sorry, I am still learning BTRFS and I would like to avoid mistakes
Bye
Il giorno mar 28 ago 2018 alle ore 15:47 Chris Murphy
<lists@colorremedies.com> ha scritto:
>
> On Tue, Aug 28, 2018 at 3:34 AM, Menion <menion@gmail.com> wrote:
> > Hi all
> > I have run a distro upgrade on my Ubuntu 16.04 that runs ppa kernel
> > 4.17.2 with btrfsprogs 4.17.0
> > The root filesystem is BTRFS single created by the Ubuntu Xenial
> > installer (so on kernel 4.4.0) on an internal mmc, located in
> > /dev/mmcblk0p3
> > After the upgrade I have cleaned apt cache and checked the free space,
> > the results were odd, following some checks (shrinked), followed by
> > more comments:
>
> Do you know if you're using Timeshift? I'm not sure if it's enabled by
> default on Ubuntu when using Btrfs, but you may have snapshots.
>
> 'sudo btrfs sub list -at /'
>
> That should show all subvolumes (includes snapshots).
>
>
>
> > [48479.254106] BTRFS info (device mmcblk0p3): 17 enospc errors during balance
>
> Probably soft enospc errors it was able to work around.
>
>
> --
> Chris Murphy
