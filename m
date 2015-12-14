Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29830 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751827AbbLNCI6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 21:08:58 -0500
Subject: Re: Still not production ready
To: Martin Steigerwald <martin@lichtvoll.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <8336788.myI8ELqtIK@merkaba>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566E2490.8080905@cn.fujitsu.com>
Date: Mon, 14 Dec 2015 10:08:16 +0800
MIME-Version: 1.0
In-Reply-To: <8336788.myI8ELqtIK@merkaba>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Martin Steigerwald wrote on 2015/12/13 23:35 +0100:
> Hi!
>
> For me it is still not production ready.

Yes, this is the *FACT* and not everyone has a good reason to deny it.

> Again I ran into:
>
> btrfs kworker thread uses up 100% of a Sandybridge core for minutes on random
> write into big file
> https://bugzilla.kernel.org/show_bug.cgi?id=90401

Not sure about guideline for other fs, but it will attract more dev's 
attention if it can be posted to maillist.

>
>
> No matter whether SLES 12 uses it as default for root, no matter whether
> Fujitsu and Facebook use it: I will not let this onto any customer machine
> without lots and lots of underprovisioning and rigorous free space monitoring.
> Actually I will renew my recommendations in my trainings to be careful with
> BTRFS.
>
>  From my experience the monitoring would check for:
>
> merkaba:~> btrfs fi show /home
> Label: 'home'  uuid: […]
>          Total devices 2 FS bytes used 156.31GiB
>          devid    1 size 170.00GiB used 164.13GiB path /dev/mapper/msata-home
>          devid    2 size 170.00GiB used 164.13GiB path /dev/mapper/sata-home
>
> If "used" is same as "size" then make big fat alarm. It is not sufficient for
> it to happen. It can run for quite some time just fine without any issues, but
> I never have seen a kworker thread using 100% of one core for extended period
> of time blocking everything else on the fs without this condition being met.
>

And specially advice on the device size from myself:
Don't use devices over 100G but less than 500G.
Over 100G will leads btrfs to use big chunks, where data chunks can be 
at most 10G and metadata to be 1G.

I have seen a lot of users with about 100~200G device, and hit 
unbalanced chunk allocation (10G data chunk easily takes the last 
available space and makes later metadata no where to store)

And unfortunately, your fs is already in the dangerous zone.
(And you are using RAID1, which means it's the same as one 170G btrfs 
with SINGLE data/meta)

>
> In addition to that last time I tried it aborts scrub any of my BTRFS
> filesstems. Reported in another thread here that got completely ignored so
> far. I think I could go back to 4.2 kernel to make this work.

Unfortunately, this happens a lot of times, even you posted it to mail list.
Devs here are always busy locating bugs or adding new features or 
enhancing current behavior.

So *PLEASE* be patient about such slow response.

BTW, you may not want to revert to 4.2 until some bug fix is backported 
to 4.2.
As qgroup rework in 4.2 has broken delayed ref and caused some scrub 
bugs. (My fault)

>
>
> I am not going to bother to go into more detail on any on this, as I get the
> impression that my bug reports and feedback get ignored. So I spare myself the
> time to do this work for now.
>
>
> Only thing I wonder now whether this all could be cause my /home is already
> more than one and a half year old. Maybe newly created filesystems are created
> in a way that prevents these issues? But it already has a nice global reserve:
>
> merkaba:~> btrfs fi df /
> Data, RAID1: total=27.98GiB, used=24.07GiB
> System, RAID1: total=19.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=536.80MiB
> GlobalReserve, single: total=192.00MiB, used=0.00B
>
>
> Actually when I see that this free space thing is still not fixed for good I
> wonder whether it is fixable at all. Is this an inherent issue of BTRFS or
> more generally COW filesystem design?

GlobalReserve is just a reserved space *INSIDE* metadata for some corner 
case. So its profile is always single.

The real problem is, how we represent it in btrfs-progs.

If it output like below, I think you won't complain about it more:
 > merkaba:~> btrfs fi df /
 > Data, RAID1: total=27.98GiB, used=24.07GiB
 > System, RAID1: total=19.00MiB, used=16.00KiB
 > Metadata, RAID1: total=2.00GiB, used=728.80MiB

Or
 > merkaba:~> btrfs fi df /
 > Data, RAID1: total=27.98GiB, used=24.07GiB
 > System, RAID1: total=19.00MiB, used=16.00KiB
 > Metadata, RAID1: total=2.00GiB, used=(536.80 + 192.00)MiB
 >  \ GlobalReserve: total=192.00MiB, used=0.00B

>
> I think it got somewhat better. It took much longer to come into that state
> again than last time, but still, blocking like this is *no* option for a
> *production ready* filesystem.
>
>
>
> I am seriously consider to switch to XFS for my production laptop again. Cause
> I never saw any of these free space issues with any of the XFS or Ext4
> filesystems I used in the last 10 years.

Yes, xfs and ext4 is very stable for normal use case.

But at least, I won't recommend xfs yet, and considering the nature or 
journal based fs, I'll recommend backup power supply in crash recovery 
for both of them.

Xfs already messed up several test environment of mine, and an 
unfortunate double power loss has destroyed my whole /home ext4 
partition years ago.

[xfs story]
After several crash, xfs makes several corrupted file just to 0 size.
Including my kernel .git directory. Then I won't trust it any longer.
No to mention that grub2 support for xfs v5 is not here yet.

[ext4 story]
For ext4, when recovering my /home partition after a power loss, a new 
power loss happened, and my home partition is doomed.
Only several non-sense files are savaged.

Thanks,
Qu
>
> Thanks,
>


