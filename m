From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: disk space caching generation missmatch
Date: Wed, 1 Dec 2010 20:56:14 +0100
Message-ID: <201012012056.14517.johannes.hirte@fem.tu-ilmenau.de>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de> <20101201174018.GB7021@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101201174018.GB7021@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 01 December 2010 18:40:18 Josef Bacik wrote:
> On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
> > After enabling disk space caching I've observed several log entries like this:
> > 
> > btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
> > 
> > I'm not sure, but it seems this happens on every reboot. Is this something to
> > worry about?
> > 
> 
> So that usually means 1 of a couple of things
> 
> 1) You didn't have space for us to save the free space cache
> 2) When trying to write out the cache we hit one of those cases where we would
> deadlock so we couldn't write the cache out
> 
> It's nothing to worry about, it's doing what it is supposed to.  However I'd
> like to know why we're not able to write out the cache.  Are you running close
> to full?  Thanks,
> 
> Josef
>

I think there should be enough free space:

df -h

Filesystem            Size  Used Avail Use% Mounted on
rootfs                 41G   29G  8.4G  78% /
/dev/root              41G   29G  8.4G  78% /
rc-svcdir             1.0M  112K  912K  11% /lib/rc/init.d
udev                   10M  284K  9.8M   3% /dev
shm                  1008M     0 1008M   0% /dev/shm
/dev/sda3             108G   90G   15G  87% /home

btrfs filesystem df /

Data: total=34.48GB, used=26.13GB
System, DUP: total=8.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=2.75GB, used=1.26GB
Metadata: total=8.00MB, used=0.00

btrfs filesystem df /home

Data: total=88.01GB, used=84.84GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=4.00GB, used=2.43GB
Metadata: total=8.00MB, used=0.00
