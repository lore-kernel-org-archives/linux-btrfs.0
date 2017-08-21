Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36763 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753383AbdHUKyM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 06:54:12 -0400
Received: by mail-lf0-f54.google.com with SMTP id f123so15803294lfe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 03:54:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <09e13dfc-20cf-57f9-5dff-b22013f5e77b@gmx.com>
References: <CAANLjFoLZ_CtO1XQNRfSCu0p2OSN7HECscAPy5ru6dTt3-qffQ@mail.gmail.com>
 <09e13dfc-20cf-57f9-5dff-b22013f5e77b@gmx.com>
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 21 Aug 2017 12:53:55 +0200
Message-ID: <CANznX5Ek2FgaF5ors5qJ41fhdFSYmGSziE7H2Xx+nPtjgMUx-g@mail.gmail.com>
Subject: Re: Btrfs Raid5 issue.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Robert LeBlanc <robert@leblancnet.us>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I lost enough Btrfs m=d=s=RAID5 filesystems in past experiments (I
didn't try using RAID5 for metadata and system chunks in the last few
years) to faulty SATA cables + hotplug enabled SATA controllers (where
a disk could disappear and reappear "as the wind blew"). Since then, I
made a habit of always disabling hotplug for all SATA disks involved
with Btrfs, even those with m=d=s=single profile (and I never desired
to built multi-devices filesystems from USB attached disks anyway but
this is good reason for me to explicitly avoid that).

I am not sure if other RAID profiles are affected in a similar way or
it's just RAID56. (Well, I mean RAID0 is obviously toast and RAID1/10
will obviously get degraded but I am not sure if it's possible to
re-sync RAID1/10 with a simple balance [possibly even without
remounting and doing manual device delete/add?] or the filesystem has
to be recreated from scratch [like RAID5].)

I think this hotplug problem is an entirely different issue from the
RAID56-scrub race-conditions (which are now considered fixed in linux
4.12) and nobody is currently working on this (if it's RAID56-only
then I don't expect it anytime soon [think years]).
