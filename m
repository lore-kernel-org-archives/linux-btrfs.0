Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:39517
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754166AbaJNTiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 15:38:55 -0400
Message-ID: <543D7BCD.70709@barrowhillfarm.org.uk>
Date: Tue, 14 Oct 2014 20:38:53 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Scrub already running
References: <543D3EAA.4000706@barrowhillfarm.org.uk> <1413303927.1289.6.camel@kepstin.ca>
In-Reply-To: <1413303927.1289.6.camel@kepstin.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 14/10/14 17:25, Calvin Walton wrote:
> On Tue, 2014-10-14 at 16:18 +0100, Bob Williams wrote:
>> When I run scrub on the root (system) partition now, I get
>> 
>> ERROR: scrub is already running. To cancel use 'btrfs scrub
>> cancel /'. To see the status use 'btrfs scrub status [-d] /'.
>> 
>> but
>> 
>> # btrfs scrub cancel / ERROR: scrub cancel failed on /: not
>> running
>> 
>> This situation (scrub running persistently) survives reboots.
>> 
>> On the /home partition, everything is OK:
>> 
>> scrub status for 56884b1d-93ab-4db9-bc93-eff3833e91e1 scrub
>> started at Tue Oct 14 02:00:01 2014 and finished after 9972
>> seconds total bytes scrubbed: 2.47TiB with 0 errors
>> 
>> Should I worry about this (apart from the fact that I cannot
>> scrub /)? What can I do about it?
> 
> This usually just means that the local state file used to track
> scrub history has gotten desynchronized. It's easy enough to fix:
> 
> Edit the file /var/lib/btrfs/scrub.status.56884b1d-93ab-4db9-bc93- 
> eff3833e91e1 (the last bit of the filename is the filesystem uuid)
> 
> Look for a line that ends with "finished:0" and change it to say 
> "finished:1"
> 
> This should allow you to start a new scrub.
> 
Thank you. That worked.

> I'm not sure if this has been improved in newer versions of the
> btrfs- progs.
> 
> 

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-21-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.14.1
Uptime:  06:00am up 6 days 11:04, 5 users, load average: 0.01, 0.03, 0.05
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlQ9e8oACgkQ0Sr7eZJrmU4kjACeLQgFSatRBHXyAS0liY6LgxHT
YM8AniR8v3S77aTM9UZy5wFuxPSgn6id
=vANt
-----END PGP SIGNATURE-----
