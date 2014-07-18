Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:59684
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbaGRHgg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 03:36:36 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id 1B36E22FAB
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 08:36:32 +0100 (BST)
Message-ID: <53C8CE7F.3090609@barrowhillfarm.org.uk>
Date: Fri, 18 Jul 2014 08:36:31 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Questions on incremental backups
References: <1405627978.2630.39.camel@s-Air> <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
In-Reply-To: <e1b3b459-ea44-4272-9320-4cb5218b3966@email.android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 18/07/14 05:35, Russell Coker wrote:
> Daily snapshots work welk with kernel 3.14 and above (I had
> problems with 3.13 and previous). I have snapshots every 15 mins on
> some subvols.
> 
> Very large numbers of snapshots can cause performance problems. I
> suggest keeping below 1000 snapshots at this time.
> 
> You can use send/recv functionality for remote backups. So far I've
> used rsync, it works well and send/recv has some limitations about
> filesystem structure etc. Rsync can transfer to a ext4 or ZFS
> filesystem if you wish.
> 
> Ignoring directories in send/recv is done by subvol. Even if you
> use rsync it's a good idea to have different subvols for directory
> trees with different backup requirements.
> 
> Displaying backups is an issue of backup software. It is above the
> level that BTRFS development touches. While people here can
> probably offer generic advice on backup software it's not the topic
> of the list.
> 
> I use date based snapshots on my backup BTRFS filesystems and I can
> easily delete snapshots in the middle of the list.
> 
I also backup to an external attached drive using rsync followed by a
snapshot. I have written a small python script that does this,
followed by deleting snapshots older than 90 days.

Restoring backed up data is done using a file manager.

I'm happy to share my script.

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-17-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.13.3
Uptime:  06:00am up 1 day 22:01, 4 users, load average: 0.87, 0.50, 0.24
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlPIznwACgkQ0Sr7eZJrmU5hZwCglxUmkd+oX3ktsFBQ2gD4Twth
5ucAn38QDkNJflmRZwH/G662DBGRd38J
=kN69
-----END PGP SIGNATURE-----
