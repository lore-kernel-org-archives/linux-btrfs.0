Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:42281
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbaIKJIw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 05:08:52 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 23E0D22635
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 10:08:50 +0100 (BST)
Message-ID: <541166A1.8080704@barrowhillfarm.org.uk>
Date: Thu, 11 Sep 2014 10:08:49 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Is it necessary to balance a btrfs raid1 array?
References: <541043B8.7010601@barrowhillfarm.org.uk> <20140911043007.GB10787@hungrycats.org>
In-Reply-To: <20140911043007.GB10787@hungrycats.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/09/14 05:30, Zygo Blaxell wrote:
> On Wed, Sep 10, 2014 at 01:27:36PM +0100, Bob Williams wrote:
>> I have two 2TB disks formatted as a btrfs raid1 array, mirroring
>> both data and metadata. Last night I started
>> 
>> # btrfs filesystem balance <path>
>> 
[...]
> 
>> As a rough guide, how often should one perform
>> 
>> a) balance
> 
> I have a cron job that runs 'btrfs balance resume' or 'btrfs
> balance start' (depending on whether a balance is already in
> progress) nightly at 1AM.  Another cron job comes along at 6AM to
> run 'btrfs balance pause' on my headless servers.  On my desktops
> and laptops I have a daemon that detects keyboard/mouse input and
> does 'btrfs balance pause' when some is detected (the balance
> remains paused until the next day at 1AM, as it is really heavy and
> takes a long time to come to a stop).
> 
[...]

Many thanks to everyone who has contributed to this thread. I have
learnt a lot, and now have weekly cronjobs to balance and scrub.

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-21-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.0
Uptime:  06:00am up 6 days 15:04, 4 users, load average: 0.02, 0.02, 0.05
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQRZp4ACgkQ0Sr7eZJrmU7YcACgpMcD4w3J8IV8m4MpYSG8jl1/
kLEAoITiw3EcpvnELw2KlRaa3GlYEWUV
=ICmv
-----END PGP SIGNATURE-----
