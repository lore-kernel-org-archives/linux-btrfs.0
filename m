From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: Re: Kernel BUG at fs/btrfs/inode.c:2281 & 4665
Date: Tue, 12 Apr 2011 22:26:24 +0200
Message-ID: <1302639984.7214.34.camel@localhost>
References: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
	 <20110412182038.17617.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Peter Stuge <peter@stuge.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110412182038.17617.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

On tis, 2011-04-12 at 20:20 +0200, Peter Stuge wrote:
> Hej Maria!
> 
> maria@ponstudios.se wrote:
> > The computer was idle when the first bug happened
> 
> Ouch.
> 
> 
> > and after the reboot btrfs can't be mounted.
> 
> Can you get some messages out of btrfs tools run against the file
> system when offline, or an image of it? Maybe hook the fs up to
> another machine.
> 
> 
> //Peter
> 

I got the data out after I cleared the log with btrfs-zero-log.

// Maria


