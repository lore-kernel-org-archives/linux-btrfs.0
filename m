Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:36486 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbbCRXdi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 19:33:38 -0400
Received: by yhjf44 with SMTP id f44so20771926yhj.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 16:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550A03B3.8020005@graphitesystems.com>
References: <5509E34F.6010504@graphitesystems.com>
	<CAJCQCtSmV63H4OnEgv2ZXSFq4s8npEGmDxUBDO5dHb7pmoC0zw@mail.gmail.com>
	<5509F08E.6070702@graphitesystems.com>
	<20150318215512.GC31762@carfax.org.uk>
	<550A03B3.8020005@graphitesystems.com>
Date: Wed, 18 Mar 2015 17:33:37 -0600
Message-ID: <CAJCQCtRvbiKAQ3iwA6y0QXNaYPnXUh7nf7AGF89Xj48q3GWUpw@mail.gmail.com>
Subject: Re: syntax for deleting subvolumes?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 18, 2015 at 5:01 PM, K Richard Pixley
<rpixley@graphitesystems.com> wrote:

> My complaint is a) about multiple subvols and b) about an unnecessary and
> redundant subvol for the top level file system.

The current granularity supplied by root and home subvolumes is minor.
Eventually there'd also be a boot subvolume too, but that's not
supported yet due to a very old grubby bug that's like a booger that
can't be flicked off.

openSUSE uses ~13 subvolumes by default, for an idea of much finer
granularity (which I don't like, personally, it's too much and really
is unnecessary).

There's rarely a use case where you want to rollback root and home at
the same time anyway, therefore making them separate subvolumes makes
sense. There could be an argument that /boot can be a directory rather
than a subvolume since it probably shouldn't get separated from its
root anyway due to kernel+kernel-module pairing and bootloader stuff.

A separate home subvolume is consistent with the RHEL/CentOS/Fedora
installer (Anaconda) default of putting home on a separate volume. It
makes home easier to backup, restore, migrate, and upgrade systems.
Btrfs support is uniquely handled by Anaconda too, in that it doesn't
require Btrfs volumes be reformat to do a clean install like for other
file systems. It does require a new subvolume, however, for the
"rootxx" subvolume.


> The redundancy should be obvious.  And the problem with multiple subvols is
> that they aren't needed and make snapshotting an entire system more
> difficult than it needs to be.  I want to be able to snapshot and chroot.
> The traditional reason for partitioning a disk was to isolate errors and to
> firewall "out of space" usage.  Neither of those really apply to btrfs as
> far as I can see.

It's the same on Btrfs in that regard as any other. Some people prefer
partitions, others prefer quotas.


> I would much rather the installer simply create a single file system and
> mount the partition directly rather than through a superfluous subvol.  I've
> never seen it done any other way as you might guess from my confusion above.

The confusion is understandable. But there's an express intent behind
the layout. Maybe the installer should include a brief explanatory
readme.txt somewhere? Or maybe integrate it as comments in /etc/fstab?

-- 
Chris Murphy
