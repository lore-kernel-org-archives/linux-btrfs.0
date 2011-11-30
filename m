From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: Resize command syntax wrong?
Date: Wed, 30 Nov 2011 20:37:25 +0100
Message-ID: <3915641.RCn2N3DEUb@venice>
References: <4ED67A2E.9080809@cfl.rr.com> <ByrPr1UD1uB@helmut.hullen.de> <20111201011547.66633b20@natsu>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111201011547.66633b20@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, 01 December, 2011 01:15:47 you wrote:
> On 30 Nov 2011 19:59:00 +0100
> 
> "Helmut Hullen" <Hullen@t-online.de> wrote:
> > > Currently the resize command is under filesystem, and takes a path
> > > to
> > > the mounted filesystem.  This seems wrong to me.  Shouldn't it be
> > > under device, and take a path to a device to resize?
> > 
> > No - it's a filesystem operation.
> 
> Are you sure about that?

I confirm that. In fact "btrfs filesystem resize" doesn't change the device(s). 
It only expands or shrinks the filesystem.
Of course if you want to expand the filesystem, you have to expand the 
underling device *before*. Otherwise if you want to shrink the filesystem, you 
have to not shrink the device before shrinking the filesystem.

> 
> > p.e.
> > You start with a system of 2 disks. They get filled nearly
> > simultaneously.
> > Then you add a 3rd disk (which is empty at that time). Now it's a good
> > idea to run "balance" for equalizing the filling.
> 
> What if I need to replace an individual device with a smaller or a larger
> one?

This is a more simpler case

As general rule:
# btrfs device add <new device> <btrfs root>
# btrfs device delete <old device> <btrfs root>

May be that the device removing is blocked in some RAID setup.




-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
