From: Michael Andreen <harv@ruin.nu>
Subject: Re: Filesystem not mountable after reset, bad tree block
Date: Sun, 8 Jan 2012 23:34:09 +0100
Message-ID: <201201082334.09563.harv@ruin.nu>
References: <201201052359.47932.harv@ruin.nu> <k0plt8-ljc.ln1@hurikhan.ath.cx> <20120107160140.GD12629@carfax.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120107160140.GD12629@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 07 January 2012 17:01:40 Hugo Mills wrote:
> On Sat, Jan 07, 2012 at 01:05:08PM +0100, Kai Krakow wrote:
> > 
> > You could try the recovery programs from Josefs btrfs-progs tree[1].
> 
>    You'll find what little documentation we have on the restore
> program here:
> 
>    http://btrfs.ipv5.de/index.php?title=Restore
> 
>    With luck, you'll just need to run restore, but there's also a
> little bit on how to read and use the output of find-root.

Thanks, it worked very well. Almost disappointed that it managed to recover 
all the junk accumulated through the years ;)

It had some problems on certain parts, crashing or just exiting with message 
about "extent buffer leak", but rerunning it without -o made it continue past 
that point. Not sure if that's normal or known, I'll keep the image around and 
see if I have time to debug it.

/Michael
