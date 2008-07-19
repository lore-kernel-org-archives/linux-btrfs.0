From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: single disk reed solomon codes
Date: Sat, 19 Jul 2008 16:15:43 -0600
Message-ID: <4882678F.50004@gentoo.org>
References: <3da3b5b40807190521x35477489sc06195bb182a4561@mail.gmail.com> <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Gerald Nowitzky <Nowitzky@igne.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0cb201c8e9b2$a4272b20$0a00a8c0@ALDI2>
List-ID: <linux-btrfs.vger.kernel.org>

Gerald Nowitzky wrote:
> When a HDD drive reads a sector from disk, it does a
> whole bunch of error recognition and correction measures. Usually there are, 
> at least, two layers of error correction with different bit spreads on it. 
> *If* this still isn't enough, it is very likely that the whole sector will 
> come back completely spoiled, or, much more likely, won't come back at all 
> and the drive will report a read error.

With larger and larger disks, it is increasingly likely we will see
undetected/uncorrected errors (the drive bit error rates are not
improving - 1 in 10^17 is typical).  It is clear we cannot rely
completely on the hardware to catch everything.  Also, errors that
happen in the hardware between the drive and the CPU can be caused by
bad cables, interfaces, etc.

For even single disk systems (even without mirroring), it is still valid
to have some means of verifying integrity.  It is far better to know an
error occurred and which files are affected than to have it happen
silently.  If caught, undetected errors will be less likely to migrate
onto backups over time and slowly corrupt data there too, making
eventual recovery impossible.  That's why btrfs's checksums are so cool!

See my blog for my personal experiences with silent hard disk errors:

	http://planet.gentoo.org/developers/lavajoe/

					-Joe
