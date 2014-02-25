Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbaBYRpZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:45:25 -0500
Date: Tue, 25 Feb 2014 18:45:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz,
        Anand Jain <Anand.Jain@oracle.com>,
        Goffredo Baroncelli <kreijack@libero.it>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_GET_DEVS
Message-ID: <20140225174523.GA16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390812770-11720-1-git-send-email-anand.jain@oracle.com>
 <1390812770-11720-2-git-send-email-anand.jain@oracle.com>
 <20140127084709.GK3314@carfax.org.uk>
 <20140206194935.GT1364@twin.jikos.cz>
 <52F3EC15.1000508@libero.it>
 <20140206220535.GV1364@suse.cz>
 <52F4B0B8.2080804@oracle.com>
 <20140207102010.GE6490@carfax.org.uk>
 <20140212160123.GP16073@suse.cz>
 <20140212161555.GQ6490@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140212161555.GQ6490@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 12, 2014 at 04:15:55PM +0000, Hugo Mills wrote:
> On Wed, Feb 12, 2014 at 05:01:23PM +0100, David Sterba wrote:
> > On Fri, Feb 07, 2014 at 10:20:10AM +0000, Hugo Mills wrote:
> > > For unmounted, but known filesystems:
> > > /sys/fs/btrfs/devmap/<UUID>/<symlink to device>   (for each device known)
> > > /sys/fs/btrfs/devmap/<UUID>/label
> > > /sys/fs/btrfs/devmap/<UUID>/complete      (0 if missing devices, 1 otherwise)
> > > /sys/fs/btrfs/devmap/<UUID>/<other properties>
> > 
> > I like that, the device map represents the global state maintained by the
> > module, does not interfere with the current sysfs structure.
> > 
> > One minor comment, the symlink to device should have probably a fixed
> > name so it can be easily located.
> 
>    Two ways spring to mind: Number them according to the internal FS's
> device numbers, so you'll have something like:
> 
> $ ls -l /sys/fs/btrfs/devmap/3993e50e-a926-48a4-867f-36b53d924c35
> total 0
> lrwxrwxrwx 1 root root    0 Feb  1 11:22 0 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:0:0/0:0:0:0/block/sda
> lrwxrwxrwx 1 root root    0 Feb  1 11:22 1 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:1:0/0:1:0:0/block/sdb
> lrwxrwxrwx 1 root root    0 Feb  1 11:22 2 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:2:0/0:2:0:0/block/sdc
> lrwxrwxrwx 1 root root    0 Feb  1 11:22 3 -> ../../../../devices/pci0000:00/0000:00:04.0/0000:02:00.0/ata1/host0/target0:3:0/0:3:0:0/block/sdd
> -r--r--r-- 1 root root 4096 Feb  1 11:22 complete
> -r--r--r-- 1 root root 4096 Feb  1 11:22 label
> 
>    Then you can find them easily by enumerating the filenames, and
> anything which is composed entirely of digits [0-9] is a device.
> Alternatively, put them into a subdirectory, and anything at all
> within that subdir is a device symlink.

A separate subdirectory looks more user friendly, a simple subdir/*
would get them all, regardless of the names. This is much simpler than
writing a "[0-9] [0-9][0-9] ..." pattern to match digits-only filenames.

> > > >  IMO no harm to have both sysfs way and ioctl way let user
> > > >  or developer use which were is suitable in their context.
> > > 
> > >    Extra maintenance overhead; divergence of the APIs. "You can find
> > > out the label of the filesystem using sysfs, but not the ioctl. You
> > > can find out the size of the filesystem using the ioctl, but not using
> > > sysfs." That way lies quite a bit of pain for the user of the
> > > interfaces.
> > 
> > I won't mind having several ways how to get the information, sysfs,
> > ioctl or the properties. Each way has it's own pros and cons or is
> > suitable for some type of user (C program, shell scripts).
> 
>    Fair enough. I do worry a little about the API divergence, though.

That's a valid point, given the number of data retrieved by the ioctl,
(I'm looking at v2 of Anand's patch https://patchwork.kernel.org/patch/3708901/)
this would need to make it extensible and backward compatible.
