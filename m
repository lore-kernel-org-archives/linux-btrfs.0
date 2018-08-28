Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:50235 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbeH1WAV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 18:00:21 -0400
Received: by mail-it0-f50.google.com with SMTP id j81-v6so3992002ite.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Aug 2018 11:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAJVZm6fbXOrXieL-hBnd9fqVRH5GdJMmN2ahyzTKCcrOibGJeg@mail.gmail.com>
 <CAJCQCtTTpXgv-gnZaxL9yR72hysUN-Ng57W1SyzHTCT3_oFtfg@mail.gmail.com>
 <CAJVZm6dyJqBa7PoqRuiByKHxR4UWYCsT=V-sej8z+FZDxD99eA@mail.gmail.com>
 <CADfjVrhcZT1u5uTC4x9XOf2ke+3H+gNH6s-4hufOT1VSkpTGaw@mail.gmail.com>
 <d46b344f-6d03-5425-188d-88e823caa074@gmail.com> <CADfjVrgUEpuSg_DSUBUL+cXhokx+f_r7XDChr1Pnc1cdsj00uQ@mail.gmail.com>
 <a8189a49-856b-9989-5a3a-3867bf5128f9@gmail.com> <CAJVZm6dcsuUZEnFncOmu6C7AVOpi6K4k=8rrOO=82yEqkY5UGA@mail.gmail.com>
In-Reply-To: <CAJVZm6dcsuUZEnFncOmu6C7AVOpi6K4k=8rrOO=82yEqkY5UGA@mail.gmail.com>
From: Noah Massey <noah.massey@gmail.com>
Date: Tue, 28 Aug 2018 14:06:53 -0400
Message-ID: <CADfjVrhAcPE4L2o=m8LmbLQJ6LbRtRsJVZ6WWhRfcUC=AOL4tA@mail.gmail.com>
Subject: Re: 14Gb of space lost after distro upgrade on BTFS root partition
 (long thread with logs)
To: menion@gmail.com
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 28, 2018 at 1:25 PM Menion <menion@gmail.com> wrote:
>
> Ok, I have removed the snapshot and the free expected space is here, thank you!
> As a side note: apt-btrfs-snapshot was not installed, but it is
> present in Ubuntu repository and I have used it (and I like the idea
> of automatic snapshot during upgrade)
> This means that the do-release-upgrade does it's own job on BTRFS,
> silently which I believe is not good from the usability perspective,

You are correct. DistUpgradeController.py from python3-distupgrade
imports 'apt_btrfs_snapshot', which I read as coming from
/usr/lib/python3/dist-packages/apt_btrfs_snapshot.py, supplied by
apt-btrfs-snapshot, but I missed the fact that python3-distupgrade
ships its own /usr/lib/python3/dist-packages/DistUpgrade/apt_btrfs_snapshot.py

So now it looks like that cannot be easily disabled, and without the
apt-btrfs-snapshot package scheduling cleanups it's not ever
automatically removed?

> just google it, there is no mention of this behaviour
> Il giorno mar 28 ago 2018 alle ore 19:07 Austin S. Hemmelgarn
> <ahferroin7@gmail.com> ha scritto:
> >
> > On 2018-08-28 12:05, Noah Massey wrote:
> > > On Tue, Aug 28, 2018 at 11:47 AM Austin S. Hemmelgarn
> > > <ahferroin7@gmail.com> wrote:
> > >>
> > >> On 2018-08-28 11:27, Noah Massey wrote:
> > >>> On Tue, Aug 28, 2018 at 10:59 AM Menion <menion@gmail.com> wrote:
> > >>>>
> > >>>> [sudo] password for menion:
> > >>>> ID      gen     top level       path
> > >>>> --      ---     ---------       ----
> > >>>> 257     600627  5               <FS_TREE>/@
> > >>>> 258     600626  5               <FS_TREE>/@home
> > >>>> 296     599489  5
> > >>>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:29:55
> > >>>> 297     599489  5
> > >>>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:30:08
> > >>>> 298     599489  5
> > >>>> <FS_TREE>/@apt-snapshot-release-upgrade-bionic-2018-08-27_15:33:30
> > >>>>
> > >>>> So, there are snapshots, right? The time stamp is when I have launched
> > >>>> do-release-upgrade, but it didn't ask anything about snapshot, neither
> > >>>> I asked for it.
> > >>>
> > >>> This is an Ubuntu thing
> > >>> `apt show apt-btrfs-snapshot`
> > >>> which "will create a btrfs snapshot of the root filesystem each time
> > >>> that apt installs/removes/upgrades a software package."
> > >> Not Ubuntu, Debian.  It's just that Ubuntu installs and configures the
> > >> package by default, while Debian does not.
> > >
> > > Ubuntu also maintains the package, and I did not find it in Debian repositories.
> > > I think it's also worth mentioning that these snapshots were created
> > > by the do-release-upgrade script using the package directly, not as a
> > > result of the apt configuration. Meaning if you do not want a snapshot
> > > taken prior to upgrade, you have to remove the apt-btrfs-snapshot
> > > package prior to running the upgrade script. You cannot just update
> > > /etc/apt/apt.conf.d/80-btrfs-snapshot
> > Hmm... I could have sworn that it was in the Debian repositories.
> >
> > That said, it's kind of stupid that the snapshot is not trivially
> > optional for a release upgrade.  Yes, that's where it's arguably the
> > most important, but it's still kind of stupid to have to remove a
> > package to get rid of that behavior and then reinstall it again afterwards.
