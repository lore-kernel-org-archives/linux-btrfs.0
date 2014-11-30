Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:43773 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbaK3WLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 17:11:07 -0500
Received: by mail-yk0-f171.google.com with SMTP id 142so4249223ykq.30
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 14:11:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547B5724.1060507@libero.it>
References: <547B5724.1060507@libero.it>
Date: Sun, 30 Nov 2014 22:11:06 +0000
Message-ID: <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
From: Dimitri John Ledkov <xnox@debian.org>
To: kreijack@inwind.it
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On 30 November 2014 at 17:43, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi all,
>
> this patch provides a "mount.btrfs" helper for the mount command.
> A btrfs filesystem could span several disks. This helper scans all the
> partitions to discover all the disks required to mount a filesystem.
> So it would not necessary any-more to "scan" the partitions to mount a filesystem.
>

I would welcome this, as a general idea. At the moment in debian &
ubuntu, btrfs tools package ships udev rules to call "btrfs scan"
whenever device nodes appear.

If scan is built into mount, I would be able to drop that udev rule.
There are also some reports (not yet re-verified) that such udev rule
is not effective, that is btrfs mount fails when attempted before udev
has attempted to be run - e.g. from initrdless boot trying to mount
btrfs systems before udev-trigger has been run (to process "cold-plug"
events).

-- 
Regards,

Dimitri.
