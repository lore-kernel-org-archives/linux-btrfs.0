Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:52047 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbeH1TUj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 15:20:39 -0400
Received: by mail-it0-f48.google.com with SMTP id e14-v6so3262341itf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 08:28:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com> <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
In-Reply-To: <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 28 Aug 2018 11:27:51 -0400
Message-ID: <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: menion@gmail.com
Cc: Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 10:59 AM Menion <menion@gmail.com> wrote:
>
> [sudo] password for menion:
> ID      gen     top level       path
> --      ---     ---------       ----
> 257     600627  5               <FS_TREE>/@
> 258     600626  5               <FS_TREE>/@home
> 296     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
> 297     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
> 298     599489  5
> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30
>
> So, there are snapshots, right? The time stamp is when I have launched
> do-release-upgrade, but it didn't ask anything about snapshot, neither
> I asked for it.

This is an Ubuntu thing
`apt show apt-btrfs-snapshot`
which "will create a btrfs snapshot of the root filesystem each time
that apt installs/removes/upgrades a software package."

> During the do-release-upgrade I got some issues due to the (very) bad
> behaviour of the script in remote terminal, then I have fixed
> everything manually and now the filesystem is operational in bionic
> version
> If it is confirmed, how can I remove the unwanted snapshot, keeping
> the current "visible" filesystem contents

By default, the package runs a weekly cron job to cleanup old
snapshots. (Defaults to 90d, but you can configure that in
APT::Snapshots::MaxAge) Alternatively, you can cleanup with the
command yourself. Run `sudo apt-btrfs-snapshot list`, and then `sudo
apt-btrfs-snapshot delete <snapshot to delete>`

~ Noah
