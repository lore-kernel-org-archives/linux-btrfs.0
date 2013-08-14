Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44053 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab3HNLru (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 07:47:50 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so2695577bkb.21
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 04:47:48 -0700 (PDT)
From: Florian Lindner <mailinglists@xgm.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Florian Lindner <mailinglists@centershock.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: (un)mounting takes a long time
Date: Wed, 14 Aug 2013 13:47:46 +0200
Message-ID: <1882848.qKhuHT46UX@horus>
In-Reply-To: <20130812135016.GB2150@localhost.localdomain>
References: <2929473.GGcWYBHif4@horus> <20130812135016.GB2150@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 12. August 2013, 09:50:16 schrieb Josef Bacik:
> On Sun, Aug 11, 2013 at 03:44:10PM +0200, Florian Lindner wrote:
> > Hello!
> > 
> > I'm using ArchLinux with kernel Linux horus 3.10.5-1-ARCH #1 SMP PREEMPT.
> > Mounting and unmounting takes a long time:
> > 
> > # time mount -v /mnt/Archiv
> > mount: /dev/sde1 mounted on /mnt/Archiv.
> > mount -v /mnt/Archiv  0,00s user 0,16s system 1% cpu 9,493 total
> > 
> > # sync && time umount -v /mnt/Archiv
> > umount: /mnt/Archiv (/dev/sdd1) unmounted
> > umount -v /mnt/Archiv  0,00s user 0,33s system 1% cpu 23,247 total
> > 
> > fstab:
> > 
> > LABEL=Archiv    /mnt/Archiv             btrfs          
> > defaults,compress=zlib 0 0
> > 
> > Archiv is a RAID 0 comprised of two discs:
> > 
> > Label: 'Archiv'  uuid: b2504193-efeb-4ef3-8797-a8d73536a416
> > 
> >         Total devices 2 FS bytes used 1.99TB
> >         devid    2 size 2.73TB used 1023.01GB path /dev/sde1
> >         devid    1 size 2.73TB used 1023.03GB path /dev/sdd1
> > 
> > Are un(mounting) times like these normal?
> 
> Are you using -o space_cache?  If not can you add that and mount/umount a
> couple of times to get the cache built up and see if that helps.

Yes, I'm using space_cache (not explicitly, seems to be the default). I reboot 
my machine regularly, so there is frequent mount/unmount acitivity,

> If you
> are using space cache then sysrq+w while its taking forever to unmount and
> create a bugzilla at bugzilla.kernel.org (make sure the component is set to
> btrfs) so I can take a look at it.  Thanks,

https://bugzilla.kernel.org/show_bug.cgi?id=60743

Thanks!
Florian
