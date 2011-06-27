From: David Sterba <dave@jikos.cz>
Subject: Re: Integration branch updated
Date: Mon, 27 Jun 2011 14:43:00 +0200
Message-ID: <20110627124300.GR12709@twin.jikos.cz>
References: <20110626211022.GA24675@carfax.org.uk>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: philipp.andreas@gmail.com
To: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110626211022.GA24675@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2011 at 10:10:22PM +0100, Hugo Mills wrote:
>    I've just updated the btrfs-progs integration branch I've been
> keeping. Not a huge amount new since last time:
> 
> Andreas Philipp (1):
>       print parent ID in btrfs subvolume list

dunno if this has been mentioned already, but this change breaks
xfstests/254 and needs a patch once merged.

david

> 
> Goffredo Baroncelli (1):
>       Scan the devices listed in /proc/partitions
> 
> Hugo Mills (1):
>       mkfs.btrfs: Fix compilation errors with gcc 4.6
> 
> Zhong, Xin (1):
>       btrfs-progs: Improvement for making btrfs image from source directory.
> 
> cwillu (1):
>       Btrfs-progs: Correct path munging in bcp
> 
>    I've also re-worked my balance-management patches to deal with a
> few oddities in the ordering of the help output, and the parameter
> counts for the various balance commands.
> 
>    You can get the latest version from:
> 
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration-20110626
> 
>    Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>      --- "I am the author. You are the audience. I outrank you!" ---     


