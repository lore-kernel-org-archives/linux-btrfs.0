From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 14:57:45 -0400
Message-ID: <20090806185745.GB17129@think>
References: <4A7A7F9F.1080809@redpill-linpro.com>
 <4A7A9A04.5010006@redpill-linpro.com>
 <20090806135436.GD3655@dhcp231-156.rdu.redhat.com>
 <4A7AE579.1050403@redpill-linpro.com>
 <20090806142750.GE3655@dhcp231-156.rdu.redhat.com>
 <4A7B15DD.2010101@redpill-linpro.com>
 <20090806180432.GG3655@dhcp231-156.rdu.redhat.com>
 <4A7B1D6D.6090402@redpill-linpro.com>
 <20090806183712.GH3655@dhcp231-156.rdu.redhat.com>
 <4A7B25C3.4020206@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo-lkml@carfax.org.uk>
To: Tore Anderson <tore.anderson@redpill-linpro.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7B25C3.4020206@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2009 at 08:49:39PM +0200, Tore Anderson wrote:
> * Josef Bacik
> 
> > Ok good news is, btrfs-vol -b will fix your problem.  Somehow most of
> > your disk has been allocated to use metadata.  So did you have a
> > whole bunch of stuff on this disk and then delete it all?  Because
> > that would put you in that situation.  If you have not then there is
> > likely a bug in the metadata ratio stuff that needs to be fixed.
> 
> As far as I know there hasn't been a lot of stuff on the file system,
> I'm afraid.  The file system was created by the Fedora 11 installer,
> and it has just been used as the system drive (I've got /home on NFS).
> 
> btrfs-vol -b / (from btrfs-progs-0.19) made my system crash and burn.
> I've was able to get output from dmesg before my SSH sessions started
> hanging - maybe you can make anything out of it?  Anyway, right now I
> have no more remote access to the box so any further debugging will
> have to wait until tomorrow morning.
> 
> btrfs relocating chunk 129952120832
> btrfs relocating block group 129952120832 flags 1

Ugh, it hit the data group first, which it can't relocate because there
is nowhere to put the blocks.

-chris

