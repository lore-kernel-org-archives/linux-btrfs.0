From: Josef Bacik <josef@redhat.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 15:01:18 -0400
Message-ID: <20090806190118.GI3655@dhcp231-156.rdu.redhat.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com> <20090806180432.GG3655@dhcp231-156.rdu.redhat.com> <4A7B1D6D.6090402@redpill-linpro.com> <20090806183712.GH3655@dhcp231-156.rdu.redhat.com> <4A7B25C3.4020206@redpill-linpro.com>
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

Hrm yeah I was afraid of that.  So you will have to try and free up some data so
the balancer as enough room to move things around.  Also one thing that _may_
help is mounting with nocow for a little bit, so any writing (like logging and
such) just over-writes stuff instead of needing a new extent, until btrfs-vol -b
can finish, and then you can go back to the normal mount options.  I still can't
figure out how this happened, but one thing to do for now would be to mount with
metadata_ratio=100.  This will make you more likely to panic in the event that
you run out of metadata, but its not that likely to happen, especially with as
much disk space as you have.  Sorry about all of this, hopefully a better
solution will be coming down in a few months.  Thanks,

Josef
