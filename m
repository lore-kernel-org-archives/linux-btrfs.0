From: Oliver <oli1417@hallo.ms>
Subject: Re: Soft lockup by using 256K sizes
Date: Sun, 12 Jul 2009 11:26:00 +0200
Message-ID: <200907121126.01550.oli1417@hallo.ms>
References: <901705186@web.de> <56419.75.80.183.92.1247274694.squirrel@www.whisperpc.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <56419.75.80.183.92.1247274694.squirrel@www.whisperpc.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

Thanks a lot the explanations. In the v0.18 version used I indeed hit patch #1. The other patches don't seem to (may be in v0.19 ?).

Cheers, Oliver

On Saturday 11 July 2009 03:11:34 ashford@whisperpc.com wrote:
> Oliver,
> 
> > I just tried btrfs with a big blocksize (-n,-l,-s) of 256K. Creating the fs
> > worked Ok. I had to put all three -n,-l,-s options to 256K, otherwise
> > mkfs.btrfs complained. But mounting results in a soft lockup (reproducible).
> > It's not the latest btrfs version however. The details are shown below.
> 
> The problem is that the block size is being set to a value that's larger than
> the memory page size.  This is not supported.  I sent in some validation
> patches for the MKFS command in January, but they may not have been tested &
> integrated yet.
> 
> Good luck.
> 
> Peter Ashford
> 
> 

