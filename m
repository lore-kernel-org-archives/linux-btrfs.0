Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:54997 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbeH1T6w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 15:58:52 -0400
Received: by mail-it0-f66.google.com with SMTP id f14-v6so3420048ita.4
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 09:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
 <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
 <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com> <d46b344f-6d03-5425-188d-88e823caa074@gmail.com>
In-Reply-To: <d46b344f-6d03-5425-188d-88e823caa074@gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 28 Aug 2018 12:05:53 -0400
Message-ID: <CADfjVrgUEpuSg_DSUBUL+cXhokx+f_r7XDChr1Pnc1cdsj00uQ@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: menion@gmail.com, Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 11:47 AM Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> On 2018-08-28 11:27, Noah Massey wrote:
> > On Tue, Aug 28, 2018 at 10:59 AM Menion <menion@gmail.com> wrote:
> >>
> >> [sudo] password for menion:
> >> ID      gen     top level       path
> >> --      ---     ---------       ----
> >> 257     600627  5               <FS_TREE>/@
> >> 258     600626  5               <FS_TREE>/@home
> >> 296     599489  5
> >> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
> >> 297     599489  5
> >> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
> >> 298     599489  5
> >> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30
> >>
> >> So, there are snapshots, right? The time stamp is when I have launched
> >> do-release-upgrade, but it didn't ask anything about snapshot, neither
> >> I asked for it.
> >
> > This is an Ubuntu thing
> > `apt show apt-btrfs-snapshot`
> > which "will create a btrfs snapshot of the root filesystem each time
> > that apt installs/removes/upgrades a software package."
> Not Ubuntu, Debian.  It's just that Ubuntu installs and configures the
> package by default, while Debian does not.

Ubuntu also maintains the package, and I did not find it in Debian repositories.
I think it's also worth mentioning that these snapshots were created
by the do-release-upgrade script using the package directly, not as a
result of the apt configuration. Meaning if you do not want a snapshot
taken prior to upgrade, you have to remove the apt-btrfs-snapshot
package prior to running the upgrade script. You cannot just update
/etc/apt/apt.conf.d/80-btrfs-snapshot

>
> This behavior in general is not specific to Debian either, a lot of
> distributions are either working on or already have this type of
> functionality, because it's the only sane and correct way to handle
> updates short of rebuilding the entire system from scratch.

Yup. Everyone in their own way, plus all the home-brews.
