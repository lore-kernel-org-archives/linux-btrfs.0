From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 8 Dec 2011 15:05:24 -0500
Message-ID: <20111208200524.GT8971@shiny>
References: <4EE0E8C2.1050202@jan-o-sch.net>
 <216d12e4-94ca-41f9-9574-76f1c8baeb0a@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Phillip Susi <psusi@cfl.rr.com>,
	Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: BJ Quinn <bj@placs.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <216d12e4-94ca-41f9-9574-76f1c8baeb0a@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2011 at 01:56:59PM -0600, BJ Quinn wrote:
> >As soon as there's something that can be tested, you'll find it on this list. 
> 
> Great, I'd love to try it.  I spent a lot of time with ZFS and the zfs send/recv functionality was very convenient.
> 
> Meanwhile, does anyone know how I can change the UUID of a btrfs partition or are there any other suggestions?

You can't change the uuid of an existing btrfs partition.  Well, you
can, but you have to rewrite all the metadata blocks.

The performance problem you're hitting is probably from metadata seeks
all over the place.  Jeff Liu has a new snapshot diffing tool in
development that may make for less IO from rsync.

Care to share you rsync script?

-chris
