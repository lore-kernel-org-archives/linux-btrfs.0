Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50191 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751602AbdIJWEx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 18:04:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1drALC-0005qU-5a
        for linux-btrfs@vger.kernel.org; Mon, 11 Sep 2017 00:04:34 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Help me understand what is going on with my RAID1 FS
Date: Mon, 11 Sep 2017 00:04:24 +0200
Message-ID: <20170911000424.50b3a04d@jupiter.sol.kaishome.de>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
        <20170910174750.544a4146@jupiter.sol.kaishome.de>
        <CAOsOv4k3LoCUFt0kAg2mvT9hF6NzEE45FrsYghmk1TD=6kLn2g@mail.gmail.com>
        <20170910201917.480261ad@demfloro.ru>
        <CAOsOv4kGu-O2qJCa0mtpHcy5uEwaJATqYYowkFOxOgHHO3930g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 10 Sep 2017 20:15:52 +0200
schrieb Ferenc-Levente Juhos <feci1024@gmail.com>:

> >Problem is that each raid1 block group contains two chunks on two
> >separate devices, it can't utilize fully three devices no matter
> >what. If that doesn't suit you then you need to add 4th disk. After
> >that FS will be able to use all unallocated space on all disks in
> >raid1 profile. But even then you'll be able to safely lose only one
> >disk since BTRFS still will be storing only 2 copies of data.  
> 
> I hope I didn't say that I want to utilize all three devices fully. It
> was clear to me that there will be 2 TB of wasted space.
> Also I'm not questioning the chunk allocator for RAID1 at all. It's
> clear and it always has been clear that for RAID1 the chunks need to
> be allocated on different physical devices.
> If I understood Kai's point of view, he even suggested that I might
> need to do balancing to make sure that the free space on the three
> devices is being used smartly. Hence the questions about balancing.

It will allocate chunks from the device with the most space available.
So while you fill your disks space usage will evenly distribute.

The problem comes when you start deleting stuff, some chunks may even
be freed, and everything becomes messed up. In an aging file system you
may notice that the chunks are no longer evenly distributed. A balance
is a way to fix that because it will reallocate chunks and coalesce
data back into single chunks, making free space for new allocations. In
this process it will actually evenly distribute your data again.

You may want to use this rebalance script:
https://www.spinics.net/lists/linux-btrfs/msg52076.html

> I mean in worst case it could happen like this:
> 
> Again I have disks of sizes 3, 3, 8:
> Fig.1
> Drive1(8) Drive2(3) Drive3(3)
>  -               X1            X1
>  -               X2            X2
>  -               X3            X3
> Here the new drive is completely unused. Even if one X1 chunk would be
> on Drive1 it would be still a sub-optimal allocation.

This won't happen while filling a fresh btrfs. Chunks are always
allocated from a device with most free space (within the raid1
constraints). This it will allocate space alternating between disk1+2
and disk1+3.

> This is the optimal allocation. Will btrfs allocate like this?
> Considering that Drive1 has the most free space.
> Fig. 2
> Drive1(8) Drive2(3) Drive3(3)
> X1            X1            -
> X2            -               X2
> X3            X3            -
> X4            -               X4

Yes.

> From my point of view Fig.2 shows the optimal allocation, by the time
> the disks Drive2 and Drive3 are full (3TB) Drive1 must have 6TB
> (because it is exclusively holding the mirrors for both Drive2 and 3).
> For sure now btrfs can say, since two of the drives are completely
> full he can't allocate any more chunks and the remaining 2 TB of space
> from Drive1 is wasted. This is clear it's even pointed out by the
> btrfs size calculator.

Yes.


> But again if the above statements are true, then df might as well tell
> the "truth" and report that I have 3.5 TB space free and not 1.5TB (as
> it is reported now). Again here I fully understand Kai's explanation.
> Because coming back to my first e-mail, my "problem" was that df is
> reporting 1.5 TB free, whereas the whole FS holds 2.5 TB of data.

The size calculator has undergone some revisions. I think it currently
estimates the free space from net data to raw data ratio across all
devices, taking the current raid constraints into account.

Calculating free space in btrfs is difficult because in the future
btrfs may even support different raid levels for different sub volumes.
It's probably best to calculate for the worst case scenario then.

Even today it's already difficult if you use different raid levels for
meta data and content data: The filesystem cannot predict the future of
allocations. It can only give an educated guess. And the calculation
was revised a few times to not "overshoot".


> So the question still remains, is it just that df is intentionally not
> smart enough to give a more accurate estimation,

The df utility doesn't now anything about btrfs allocations. The value
is estimated by btrfs itself. To get more detailed info for capacity
planning, you should use "btrfs fi df" and its various siblings.

> or is the assumption
> that the allocator picks the drive with most free space mistaken?
> If I continue along the lines of what Kai said, and I need to do
> re-balance, because the allocation is not like shown above (Fig.2),
> then my question is still legitimate. Are there any filters that one
> might use to speed up or to selectively balance in my case? or will I
> need to do full balance?

Your assumption is misguided. The total free space estimation is a
totally different thing than what the allocator bases its decision on.
See "btrfs dev usage". The allocator uses space from the biggest
unallocated space within the raid constraints.

Plus, the raid constraints are what forces you to 1.5 TB free space
(df) as you already pointed out above.


> On Sun, Sep 10, 2017 at 7:19 PM, Dmitrii Tcvetkov
> <demfloro@demfloro.ru> wrote:
> >> @Kai and Dmitrii
> >> thank you for your explanations if I understand you correctly,
> >> you're saying that btrfs makes no attempt to "optimally" use the
> >> physical devices it has in the FS, once a new RAID1 block group
> >> needs to be allocated it will semi-randomly pick two devices with
> >> enough space and allocate two equal sized chunks, one on each.
> >> This new chunk may or may not fall onto my newly added 8 TB drive.
> >> Am I understanding this correctly?  
> > If I remember correctly chunk allocator allocates new chunks on
> > device which has the most unallocated space.
> >  
> >> Is there some sort of balance filter that would speed up this sort
> >> of balancing? Will balance be smart enough to make the "right"
> >> decision? As far as I read the chunk allocator used during balance
> >> is the same that is used during normal operation. If the allocator
> >> is already sub-optimal during normal operations, what's the
> >> guarantee that it will make a "better" decision during balancing?  
> >
> > I don't really see any way that being possible in raid1 profile. How
> > can you fill all three devices if you can split data only twice?
> > There will be moment when two of three disks are full and BTRFS
> > can't allocate new raid1 block group because it has only one drive
> > with unallocated space.
> >  
> >>
> >> When I say "right" and "better" I mean this:
> >> Drive1(8) Drive2(3) Drive3(3)
> >> X1            X1
> >> X2                            X2
> >> X3            X3
> >> X4                            X4
> >> I was convinced until now that the chunk allocator at least tries a
> >> best possible allocation. I'm sure it's complicated to develop a
> >> generic algorithm to fit all setups, but it should be possible.  
> >
> >
> > Problem is that each raid1 block group contains two chunks on two
> > separate devices, it can't utilize fully three devices no matter
> > what. If that doesn't suit you then you need to add 4th disk. After
> > that FS will be able to use all unallocated space on all disks in
> > raid1 profile. But even then you'll be able to safely lose only one
> > disk since BTRFS still will be storing only 2 copies of data.
> >
> > This behavior is not relevant for single or raid0 profiles of
> > multidevice BTRFS filesystems.  
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Regards,
Kai

Replies to list-only preferred.

