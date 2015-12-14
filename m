Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36361 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbbLNISy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 03:18:54 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: still kworker at 100% cpu in all of device size allocated with chunks situations with write load (was: Re: Still not production ready)
Date: Mon, 14 Dec 2015 09:18:52 +0100
Message-ID: <5373860.W0QrVGf34G@merkaba>
In-Reply-To: <566E2490.8080905@cn.fujitsu.com>
References: <8336788.myI8ELqtIK@merkaba> <566E2490.8080905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 14. Dezember 2015, 10:08:16 CET schrieb Qu Wenruo:
> Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
> > Hi!
> > 
> > For me it is still not production ready.
> 
> Yes, this is the *FACT* and not everyone has a good reason to deny it.
> 
> > Again I ran into:
> > 
> > btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
> > random write into big file
> > https://bugzilla.kernel.org/show_bug.cgi?id=90401
> 
> Not sure about guideline for other fs, but it will attract more dev's
> attention if it can be posted to maillist.

I did, as mentioned in the bug report:

BTRFS free space handling still needs more work: Hangs again
Martin Steigerwald | 26 Dec 14:37 2014
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/41790

> > No matter whether SLES 12 uses it as default for root, no matter whether
> > Fujitsu and Facebook use it: I will not let this onto any customer machine
> > without lots and lots of underprovisioning and rigorous free space
> > monitoring. Actually I will renew my recommendations in my trainings to
> > be careful with BTRFS.
> > 
> >  From my experience the monitoring would check for:
> > merkaba:~> btrfs fi show /home
> > Label: 'home'  uuid: […]
> > 
> >          Total devices 2 FS bytes used 156.31GiB
> >          devid    1 size 170.00GiB used 164.13GiB path
> >          /dev/mapper/msata-home
> >          devid    2 size 170.00GiB used 164.13GiB path
> >          /dev/mapper/sata-home
> > 
> > If "used" is same as "size" then make big fat alarm. It is not sufficient
> > for it to happen. It can run for quite some time just fine without any
> > issues, but I never have seen a kworker thread using 100% of one core for
> > extended period of time blocking everything else on the fs without this
> > condition being met.
> And specially advice on the device size from myself:
> Don't use devices over 100G but less than 500G.
> Over 100G will leads btrfs to use big chunks, where data chunks can be
> at most 10G and metadata to be 1G.
> 
> I have seen a lot of users with about 100~200G device, and hit
> unbalanced chunk allocation (10G data chunk easily takes the last
> available space and makes later metadata no where to store)

Interesting, but in my case there is still quite some free space in already 
allocated metadata chunks. Anyway, I did had enospc issues on trying to 
balance the chunks.

> And unfortunately, your fs is already in the dangerous zone.
> (And you are using RAID1, which means it's the same as one 170G btrfs
> with SINGLE data/meta)

Well, I know for any FS its not recommended to let it run to full and leave 
about 10-15% free at least, but while it is not 10-15% anymore, its still a 
whopping 11-12 GiB of free space. I would accept a somewhat slower operation 
in this case, but no kworker at 100% for about 10-30 seconds blocking 
everything else on going on on the filesystem. For whatever reason Plasma 
seems to access the fs on almost every action I do with it, so not even panels 
slide out anymore or activity switcher works during that time.

> > In addition to that last time I tried it aborts scrub any of my BTRFS
> > filesstems. Reported in another thread here that got completely ignored so
> > far. I think I could go back to 4.2 kernel to make this work.
> 
> Unfortunately, this happens a lot of times, even you posted it to mail list.
> Devs here are always busy locating bugs or adding new features or
> enhancing current behavior.
> 
> So *PLEASE* be patient about such slow response.

Okay, thanks at least for the acknowledgement of this. I try to be even more 
patient.
 
> BTW, you may not want to revert to 4.2 until some bug fix is backported
> to 4.2.
> As qgroup rework in 4.2 has broken delayed ref and caused some scrub
> bugs. (My fault)

Hm, well scrubbing does not work for me either. But since 4.3/4.4rc2/4. I just 
bumped the thread:

Re: [4.3-rc4] scrubbing aborts before finishing

by replying a well by replying a third time to it (not fourth, miscounted:). 

> > I am not going to bother to go into more detail on any on this, as I get
> > the impression that my bug reports and feedback get ignored. So I spare
> > myself the time to do this work for now.
> > 
> > 
> > Only thing I wonder now whether this all could be cause my /home is
> > already
> > more than one and a half year old. Maybe newly created filesystems are
> > created in a way that prevents these issues? But it already has a nice
> > global reserve:
> > 
> > merkaba:~> btrfs fi df /
> > Data, RAID1: total=27.98GiB, used=24.07GiB
> > System, RAID1: total=19.00MiB, used=16.00KiB
> > Metadata, RAID1: total=2.00GiB, used=536.80MiB
> > GlobalReserve, single: total=192.00MiB, used=0.00B
> > 
> > 
> > Actually when I see that this free space thing is still not fixed for good
> > I wonder whether it is fixable at all. Is this an inherent issue of BTRFS
> > or more generally COW filesystem design?
> 
> GlobalReserve is just a reserved space *INSIDE* metadata for some corner
> case. So its profile is always single.
> 
> The real problem is, how we represent it in btrfs-progs.
> 
> If it output like below, I think you won't complain about it more:
>  > merkaba:~> btrfs fi df /
>  > Data, RAID1: total=27.98GiB, used=24.07GiB
>  > System, RAID1: total=19.00MiB, used=16.00KiB
>  > Metadata, RAID1: total=2.00GiB, used=728.80MiB
> 
> Or
> 
>  > merkaba:~> btrfs fi df /
>  > Data, RAID1: total=27.98GiB, used=24.07GiB
>  > System, RAID1: total=19.00MiB, used=16.00KiB
>  > Metadata, RAID1: total=2.00GiB, used=(536.80 + 192.00)MiB
>  > 
>  >  \ GlobalReserve: total=192.00MiB, used=0.00B

Oh, the global reserve is *inside* the existing metadata chunks? Thats 
interesting. I didn´t know that.

> > I am seriously consider to switch to XFS for my production laptop again.
> > Cause I never saw any of these free space issues with any of the XFS or
> > Ext4 filesystems I used in the last 10 years.
> 
> Yes, xfs and ext4 is very stable for normal use case.
> 
> But at least, I won't recommend xfs yet, and considering the nature or
> journal based fs, I'll recommend backup power supply in crash recovery
> for both of them.
> 
> Xfs already messed up several test environment of mine, and an
> unfortunate double power loss has destroyed my whole /home ext4
> partition years ago.

Wow. I have never seen this. Actual I teach journal filesystems being quite 
safe on power losses as long as cache flushes (former barrier) functionality 
is active and working. With one caveat: It relies on one sector being either 
completely written or not. I never seen any scientific proof for that on usual 
storage devices.

> [xfs story]
> After several crash, xfs makes several corrupted file just to 0 size.
> Including my kernel .git directory. Then I won't trust it any longer.
> No to mention that grub2 support for xfs v5 is not here yet.

That is no filesystem metadata structure crash. It is a known issue with 
delayed allocation. Same with Ext4. I teach this as well in my performance 
analysis & tuning course.

Main cause is the following: Both XFS and Ext4 use delayed allocation, i.e.:

dd if=/dev/zero of=zeros bs=1M count=100 ; rm zeros

will not allocate nor write a single byte of file data. As the file is deleted 
before delayed allocation kicks in.

Now on renaming or truncating a file the journal may record the change already 
before the data is actually allocated.

There is an epic Ubuntu bug report about when Ext4 introduced delayed 
allocation. There has been an epic discussion. Theodore T´so said: Use 
fsync()! Linus said: Don´t break userspace. We know the app is broke, but it 
worked with Ext3, so fix it. Ext4 has a "fix" or workaround for apps not using 
fsync() properly meanwhile, for the rename over old file and truncate case. It 
does not use delayed allocation in these case, basically lowering performance.

XFS has a fix for truncating case, but *not* for rename case.

Also BTRFS in principle has this issue I believe.  As far as I am aware it has 
a fix for the rename case, not using delayed allocation in the case. Due to 
its COW nature it may not be affected at all however, I don´t know.

> [ext4 story]
> For ext4, when recovering my /home partition after a power loss, a new
> power loss happened, and my home partition is doomed.
> Only several non-sense files are savaged.

During a fsck? Well that is quite a special condition I´d say. Of course I 
think aborting an fsck should be safe at all time, but I wouldn´t be surprised 
if it wasn´t.

Thanks,
-- 
Martin
