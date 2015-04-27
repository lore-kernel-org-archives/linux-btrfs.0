Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-2.mail.thdo.gradwell.net ([212.11.70.35]:36383
	"EHLO outbound-queue-2.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932852AbbD0SXD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 14:23:03 -0400
Received: from outbound-edge-2.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-2.mail.thdo.gradwell.net (Postfix) with ESMTP id 64F2055332
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2015 19:23:01 +0100 (BST)
Message-ID: <553E7E84.4060702@barrowhillfarm.org.uk>
Date: Mon, 27 Apr 2015 19:23:00 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: help on broken file system
References: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
In-Reply-To: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/04/15 14:39, Ermanno Baschiera wrote:
> Hello, I have a 3 disks file system configured in RAID1, created
> with Ubuntu 13.10 (if I recall correctly). Last friday I upgraded
> my system from Ubuntu 14.10 (kernel 3.16.0) to 15.04 (kernel
> 3.19.0). Then I started to notice some malfunctions (errors on cron
> scripts, my time machine asking to perform a full backup, high
> load, etc.). On saturday I rebooted the system and it booted in
> readonly. I tried to reboot it and it didn't boot anymore, stuck at
> mounting the disks. So I booted with a live Ubuntu 15.05 which
> could not mount my disks, even with "-o recovery,". Then I switched
> to Fedora beta with kernel 4.0.0-0.rc5. I did a "btrfs check" and
> got a lot of "parent transid verify failed on 8328801964032 wanted
> 1568448 found 1561133". Reading on docs and Stack Exchange, I
> decided to try a "btrfs restore" to backup my data. Having not a
> spare disk, and being the file system a RAID1, I decided to use one
> of the 3 disks as target for the restore. I formatted it in EXT4
> and tried the restore. The process stopped after one minute, ending
> with errors. Then I tried to "btrfs-zero-log" the file system, but
> I noticed that running it multiple times, it was giving me the same
> amount of messages, making me think it wasn't fixing anything. So I
> run a "btrfs rescue chunk-recover". After that, I still not being 
> able to mount the system (with parameters -o
> recovery,degraded,ro). I'm not sure about what to do now. Can
> someone give me some advice? My possible steps are (if I understand
> correctly): - try the "btrfs rescue super-recover" - try the "btrfs
> check --repair"
> 
Hi Ermanno,

I'm sorry, I can't help you solve your problem. I've just had a
similar problem (see thread subject "btrfs filesystem for /home has
become readonly").

I tried everything, like you, including btrfs check --repair, but
nothing helped. In the end I reformatted my disks, reinstalled the OS
and restored all my data from backup.

I shall watch this thread to see if any experts have a better solution
for you. I hope so!

Bob
- -- 
Bob Williams
System:  Linux 3.16.7-7-desktop
Distro:  openSUSE 13.2 (x86_64) with KDE Development Platform: 4.14.3
Uptime:  06:00am up 7:55, 3 users, load average: 0.16, 0.05, 0.06
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlU+foIACgkQ0Sr7eZJrmU79DgCgpC5YxMbcFKEXp+5bb8BA23Tz
KZMAn2r5hOzILWF3f1TwBaC0HaSC1A4A
=ej+n
-----END PGP SIGNATURE-----
