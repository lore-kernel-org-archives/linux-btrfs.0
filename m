From: Josef Bacik <josef@redhat.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 6 Aug 2009 14:04:32 -0400
Message-ID: <20090806180432.GG3655@dhcp231-156.rdu.redhat.com>
References: <4A7A7F9F.1080809@redpill-linpro.com> <4A7A9A04.5010006@redpill-linpro.com> <20090806135436.GD3655@dhcp231-156.rdu.redhat.com> <4A7AE579.1050403@redpill-linpro.com> <20090806142750.GE3655@dhcp231-156.rdu.redhat.com> <4A7B15DD.2010101@redpill-linpro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	Hugo Mills <hugo-lkml@carfax.org.uk>
To: Tore Anderson <tore.anderson@redpill-linpro.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7B15DD.2010101@redpill-linpro.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 06, 2009 at 07:41:49PM +0200, Tore Anderson wrote:
> * Josef Bacik
> 
> > Ooookay, now that I'm awake lets try this again :).  You are right, I
> > thought it was 212GB used, not 16GB used.  Something has gone
> > horribly wrong, btrfs seems to think thats all the space it can use.
> > The command you need to use is btrfs-vol -b.  Please try that and see
> > if it behaves better.  Before you run that please do a btrfs-show and
> > post the output, I'd like to see how big the fs thinks its supposed
> > to be.
> 
> It doesn't print much of anything, I'm afraid:
> 
> root@echo:~/misc/btrfs-progs-unstable# ./btrfs-show /dev/mapper/vg_echo-lv_root  
> failed to read /dev/sr0
> failed to read /dev/sdf
> failed to read /dev/sde
> failed to read /dev/sdd
> failed to read /dev/sdc
> failed to read /dev/sdb
> Btrfs Btrfs v0.19
> 
> Same output with btrfs-progs-0.19.  The devices it's complaining about
> is a USB memory card reader and my optical drive, if I disconnect
> those from the SCSI layer the output is simply "Btrfs Btrfs v0.19".
> 
> I tried to run btrfsck earlier today, but it only gave me an error
> message.  Perhaps that just made things worse?
> 
> I've got a btrfs-image dump that I took right after the problem showed
> for the first time (before the fsck), by the way.  It's available at
> <http://greed.fud.no/hosed_rootfs.btrfsimage.Z> in case you have any
> use for it.
> 

What kernel are you running?  I need to get a look at what code you are on.
Thanks for the image, I'm having some trouble getting it to work, but I will let
you know what I come up with.

Josef
