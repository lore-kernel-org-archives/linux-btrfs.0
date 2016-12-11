Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57071 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752726AbcLKBUR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Dec 2016 20:20:17 -0500
MIME-Version: 1.0
Message-ID: <trinity-61e2f0ca-a170-4c28-abb3-770e3fc816b3-1481419213723@3capp-mailcom-bs02>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Markus Binsteiner" <makkus@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-find-root duration?
Content-Type: text/plain; charset=UTF-8
Date: Sun, 11 Dec 2016 02:20:13 +0100
In-Reply-To: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Markus, 

Some file system automatically generates snapshot, and create a hidden folder for recovery,
if the user accidently deletes some files.

It seems btrfs also has a autosnap feature,
so if this option has been enabled before deletion,
or the volume has been mannually generated snapshots, then probably it might be able to perform fast recover.

Regards,
Xin 

Sent: Saturday, December 10, 2016 at 4:12 PM
From: "Markus Binsteiner" <makkus@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-find-root duration?
It seems I've accidentally deleted all files in my home directory,
which sits in its own btrfs partition (lvm on luks). Now I'm trying to
find the roots to be able to use btrfs restore later on.

btrfs-find-root seems to be taking ages though. I've run it like so:

btrfs-find-root /dev/mapper/think--big-home -o 5 > roots.txt

After 16 hours, there is still no output, but it's still running
utilizing 100% of one core. Is there any way to gauge how much longer
it'll take? Should there have been output already while it's running?

When I run it without redirecting stdout, I get:

$ btrfs-find-root /dev/mapper/think--big-home -o 5

Superblock doesn't contain generation info for root 5
Superblock doesn't contain the level info for root 5

When I omit the '-o 5', it says:

$ btrfs-find-root /dev/mapper/think--big-home

Superblock thinks the generation is 593818
Superblock thinks the level is 0

Is the latter the way to run it? Did that initially, but that didn't
return any results in a reasonable timeframe either.

The filesystem was created with Debian Jessie, but I'm using Ubuntu (
btrfs-progs v4.7.3 ) to try to restore the files at the moment.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
