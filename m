Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36586 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbbJNVPC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 17:15:02 -0400
Received: by ioii196 with SMTP id i196so69473461ioi.3
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 14:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
References: <2402569.dCkKzGyGNU@hoefnix>
	<CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
	<561EBC3D.8060004@bouton.name>
	<CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
Date: Wed, 14 Oct 2015 17:15:01 -0400
Message-ID: <CAGfcS_nid0dz2V+H=gAb-diRxwfj4sdYgCp6hR+5wucCwQHAWw@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Donald Pearson <donaldwhpearson@gmail.com>
Cc: Lionel Bouton <lionel-subscription@bouton.name>, Sjoerd <sjoerd@sjomar.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 4:53 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
>
> Personally I would still recommend zfs on illumos in production,
> because it's nearly unshakeable and the creative things you can do to
> deal with problems are pretty remarkable.  The unfortunate reality is
> though that over time your system will probably grow and expand and
> zfs is very locked in to the original configuration.  Adding vdevs is
> a poor solution IMO.
>

This is the main thing that has kept me away from zfs - you can't
modify a vdev, like you can with an md array or btrfs.  I don't think
zfs makes use of all your space if you have mixed disk sizes in a
raid-z either - it works like mdadm.  I'm not sure whether btrfs will
be any better in that regard (if I have 2x3TB and 3x1TB drives in a
RAID5 I should get 6TB of usable space, not 4TB, without messing with
partitioning).

So, I am running raid1 btrfs in the hope that I'll be able to move to
something more efficient in the future.

However, I would not personally be using raid5/6 for anything but pure
experimentation on btrfs anytime soon.  I don't even trust the 4.1
kernel series for btrfs at all just yet, and you're not going to be
running older than that for raid5/6.

--
Rich
