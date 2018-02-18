Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:52720 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751238AbeBRJ2D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Feb 2018 04:28:03 -0500
Date: Sun, 18 Feb 2018 10:28:02 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Tomasz =?iso-8859-2?Q?K=B3oczko?= <kloczko.tomasz@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: your mail
Message-ID: <20180218092802.GA25085@polanet.pl>
References: <CABB28Cw2+jYynXk1e+Lbx+4otsj5BLXucVV6W3+kvm3RDbH_AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <CABB28Cw2+jYynXk1e+Lbx+4otsj5BLXucVV6W3+kvm3RDbH_AQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 18, 2018 at 08:14:25 +0000, Tomasz K³oczko wrote:

> For some reasons btrfs pool each volume is not displayed in mount and
> df output, and I cannot find how to display volumes/snapshots usage
> using btrfs command.

In general: not possible without enabling quotas, which in turn impact
snapshot performance significally.

btrfs quota enable /
btrfs quota rescan /
btrfs qgroup sh --sort=excl /

> So now I have many volumes and snapshots in my home directory, but to
> maintain all this I must use root permission. As non-root working in
> my own home which is separated btrfs volume it would be nice to have
> the possibility to delegate permission to create, destroy,
> send/receive, mount/umount etc. snapshots, volumes like it os possible
> on zfs.

I've already noticed this problem on February 10th:
[btrfs-progs] coreutils-like -i parameter, splitting permissions for various tasks

In short: not possible. Regular user can only create subvolumes.

> BTW: someone maybe started working on something like .zfs hidden
> directory functions which is in each zfs volume mountpoint?

In btrfs world this is done differently - don't put main (working) volume in the
root, but mount some branch by default, keeping all the subvolumes next
to it. I.e. don't:

@working_subvolume
@working_subvolume/snapshots

but:

@root_of_the_fs
@root_of_the_fs/working_subvolume
@root_of_the_fs/snapshots

In fact this is manual workaroud for the problem you've mentioned.

> Have few or few tenths snapshots is not so big deal but the same on
> scale few hundreds, thousands or more snapshots I think that would be
> really hard without something like hidden .btrfs/snapshots directory.

With few hundreds of subvolumes btrfs would fail miserably.

> After few years not using btrfs (because previously was quite
> unstable) It is really good to see that now I'm not able to crash it.

It's not crashing with LTS 4.4 and 4.9 kernels, many reports of various
crashes in 4.12, 4.14 and 4.15 were posted here. It is really hard to say,
which of the post-4.9 kernels have reliable btrfs.

-- 
Tomasz Pala <gotar@pld-linux.org>
