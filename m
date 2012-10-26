Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:34546
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165Ab2JZFYo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 01:24:44 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Naming of subvolumes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1351168220.1923.6.camel@hughsie-work.lan>
Date: Thu, 25 Oct 2012 23:24:39 -0600
Message-Id: <64967FA4-4DC1-478E-A920-1E5237905DAE@colorremedies.com>
References: <1351168220.1923.6.camel@hughsie-work.lan>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2012, at 6:30 AM, Richard Hughes <hughsient@gmail.com> wrote:

> I'm planning to use "btrfs subvolume snapshot -r <name>" in the system
> upgrade functionality[1] if the user is using btrfs for their root file
> system. We've got most of the bits in place already for Fedora 18.

What's the read-only snapshot of and used for?

> One think that confuses me is the convention for the naming of
> snapshots. Is there any conventions or prior art there? Can I add
> metadata to the snapshot so that I don't have encode everything in the
> snapshot name itself?

> If we do one upgrade a week, that's 52 subvolumes cluttering things up.
> Should the subvolumes be placed somewhere upgrade specific? Any best
> practice ideas on naming? e.g. @system-upgrade-20121025?


I'm curious what is being snapshotted, and what the snapshot organization will be, before getting to the naming convention. And if you're going to apply the upgrade to the snapshot, or to the top level file system?

Anaconda-18.19 in Fedora 18 TC6 presently creates subvolumes: boot, root, home, at the top level of the volume, if the user specifies Device Type BTRFS for those mountpoints.

Top Level
|---
|   |--root
|   |--boot
|   |--home

So I'm going to guess that you will actually create a subvolume named something like @system-upgrade-20121025, and then snapshot root, boot, and home into that subvol?

Top Level
|---
|   |--root
|   |--boot
|   |--home
|   |--@system-upgrade-20121025
|       |--root
|       |--boot
|       |--home

If the upgrade to the original top level is successful, you keep the default subvolume ID as 0. If the upgrade is not successful, you change the default subvolume ID to that of @system-upgrade-20121025. (Or you're upgrading the snapshot, if successful change the default subvol ID to that snapshot, if it fails leave it as is, which is probably the fail safe.)

The organization does kinda matter for grub2, because core.img has a prefix baked into it, so it's looking for boot/grub2. And the grub.cfg uses rootflags=subvol=root, so it's looking for the contents of root to boot. And /etc/fstab is likewise using relative references with the subvol= not subvolid=. So current boot root home can't be renamed without changing things elsewhere (like using subvolid instead).

While grub-mkconfig can figure this out for grub.cfg, grubby doesn't. And grubby right now is having a (small?) problem negotiating subvolumes, so it's currently not correctly updating grub.cfg when there are new kernels installed on btrfs.

Anyway, there are a lot of ways to do this, with different consequences. So I'm just wondering what's being snapshotted and what the organization is.

Also, about 52 snapshots? Small issue for the installer team who are looking for existing installations of other OS's, so that instead of getting a bunch of meaningless partitions, those partitions are grouped together by OS. Well, if there are 52 snapshots of Fedora 18, there are effectively 53 copies of /etc/fedora-release to be found. So how is this going to show up?

And I'm also curious then about gnome-disk-utility and how they will show subvolumes, if at all, and if there are 52 or 5000 subvolumes, what's this UI going to look like?

Maybe in the short term you do something just like with kernels and keep the most recent three and start deleting the older ones?


Chris Murphy

