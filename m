From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: heterogeneous raid1
Date: Sat, 24 Mar 2012 07:15:28 +0000 (UTC)
Message-ID: <pan.2012.03.24.07.15.28@cox.net>
References: <20120323061159.GA11099@mcelrath.org>
	<20120323102007.GA14080@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 23 Mar 2012 10:20:07 +0000 as excerpted:

> On Fri, Mar 23, 2012 at 06:11:59AM +0000, Bob McElrath wrote:
>> Greetings butter-heads,
>> 
>> I would like to implement a redundant (raid1) disk array on
>> heterogeneous disks using btrfs.  A more detailed description of what I
>> want to do can be found here:
>> 
>> http://superuser.com/questions/387851/a-zfs-or-lvm-or-md-redundant-
heterogeneous-storage-proposal/388536
>> 
>> In a nutshell: organize your heterogenous disks into two "halves", the
>> sum of which are of roughly equal size, and create a raid1 array across
>> those two halves.
>> 
>> For various reasons I decided to go with btrfs over zfs.  What I have
>> done is to create two lvm Logical Volumes, one using a single large
>> disk, and another as a linear concatenation of several smaller disks. 
>> It works, so far, and I could automate it with some scripts.
> 
>    btrfs doesn't quite do things this way. As well as the FAQ
> suggested by Carey, you might want to look at the (rather misnamed)
> SysadminGuide on the wiki at http://btrfs.ipv5.de/ .

[ This post is targeted at the OP, but replied to Hugo as I'm building on 
what he stated. ]

Let me agree with the others here, but add a bit more.  You REALLY want 
to read the wiki, not just the FAQ and the sysadmin guide, but most of 
it, including the multi-device page and the use-cases page.

Additionally, let me stress that btrfs isn't stable yet.  The btrfs 
option in the kernel config not only says it's still experimental, but 
says that it's only appropriate for testing with non-critical data.  The 
wiki also makes the point on multiple pages that btrfs is still under 
heavy development.  Here's a bit of what it says on the source-code 
repositories page, for instance:

>>>>>

Since 2.6.29-rc1, Btrfs has been included in the mainline kernel.

Warning, Btrfs evolves very quickly do not test it unless:

    You have good backups and you have tested the restore capability
    You have a backup installation that you can switch to when something 
breaks
    You are willing to report any issues you find
    You can apply patches and compile the latest btrfs code against your 
kernel (quite easy with git and dkms, see below)
    You acknowledge that btrfs may eat your data
    Backups! Backups! Backups! 

<<<<<

Believe it!  While a lot of people are already using btrfs for their data 
without the level of backups and reliability skepticism displayed above 
and some may indeed never have problems, this list seems to get about two 
posts a week from folks who have lost data and are trying to recover it, 
not so they can better help with testing, but because they did NOT have 
reliable and tested current backups of the data on their btrfs 
filesystems!

With mature filesystems, you make backups in case of failure, but don't 
necessarily expect to have to use them.  With filesystems in development 
as is btrfs, the data on the filesystem should be considered test data, 
only copied to the filesystem for testing purposes, with what you 
consider your primary copy safely stored... as well as backed up... 
elsewhere.

Don't be one of those couple posts a week!

If that hasn't scared you off until such time as btrfs is a bit more 
mature, and yes, you have that sort of reliable primary storage and 
backup system in use, and btrfs will indeed only be used for data that 
you're willing to lose at any time... then there's a reasonable chance 
btrfs at this stage is ready for your testing. =:^)


It should now go without saying, but I'll repeat again another point the 
wiki makes repeatedly.  Given the rate at which btrfs is developing, if 
you're running it, you REALLY want to be running at LEAST the latest 
Linus tree stable release, now 3.3. (FWIW, btrfs updates don't hit the 
stable tree as btrfs isn't stable, so while you might do stable updates 
for security or other reasons, don't expect them to contain btrfs 
updates.  Use the -rcs or Chris's tree for that.)  Running the current 
development kernel, at least after rc1, is better, and for the latest, 
use the for-linus branch of Chris's tree or even keep up with the patches 
on the list.

That's why cwillu said 3.0 is "seriously out of date" -- for the purposes 
of those that *SHOULD* be testing/running btrfs at this point, it *IS* 
seriously out of date!  People should be on 3.2 at the very oldest, and 
preferably be updating to 3.3 by now, if they're testing/running btrfs at 
the stage it is now.  If they're not prepared for that sort of kernel 
update cycle, they shouldn't be on btrfs at this point.


You'll also want to read up on the userspace tools on the wiki, as the 
latest release, 0.19, is wayyy old and you'll probably want to do live-
git updates.  However, the userspace tools aren't quite as critical as 
the kernel since updates there are mostly to take advantage of new stuff 
in the kernel; the old stuff generally still works about as it did, so as 
long as you're /reasonably/ current there, you're probably fine.


Meanwhile, btrfs' so-called raid1 is really mis-named as it isn't in fact 
raid1 in the traditional sense at all.  Instead, it's two-way-mirroring 
only.  True raid1 on three or more devices would have as many copies as 
there are devices, while (current mainline) btrfs only does two-way 
mirroring, regardless of the number of devices.  There's patches around 
to add multi-way-mirroring (at least three-way, I'm not sure whether it's 
true-N-way, or only adding specifically three-way to the existing two-
way), but the feature is only available as patches, at this point.  It's 
planned for merge after the raid5/6 code is merged, which may be this 
cycle (3.4), so multi-way-mirroring might be kernel 3.5.

As it happens, the current two-way-mirroring suits your needs just fine, 
tho, so that bit is not a problem.  Again, that's why cwillu stated that 
btrfs already should work as you need, and why all three of us have 
pointed you at the wiki.  In particular, as Hugo mentions, the sysadmin 
page describes how btrfs arranges chunks, etc, across multiple drives to 
get the two-way-mirroring in its so-called raid1 and raid10 modes.

>> In the long term, I would like this to be something that btrfs could do
>> by itself, without LVM.

I can't fault you there!  FWIW I'm using md/raid here (my critical btrfs 
feature is N-way mirroring, which isn't there yet, as explained above, so 
I'm not even testing it yet, just keeping up with developments), but 
after initially trying LVM on md/raid, I decided the stacking was WAYYY 
too complex to have the necessary level of confidence in my ability to 
rebuild, especially under an already heavily stressful recovery scenario 
where I had limited access to documentation, etc.

So here, I'm using (gpt) partitioned md/raid on (gpt) partitioned 
hardware devices -- no lvm, no initrd, assemble the md containing the 
rootfs from the kernel commandline (via grub) and boot directly to it, 
multiple md/raid devices configured such that I have working and backup 
instances of most filesystems (including the rootfs, so I can switch to 
the backup directly from grub) on separate mds, and everything split up 
such that recovering individual mds goes quite fast as they're each only 
a few gigs to a hundred gigs or so each.

With LVM, not only did I have the additional complexity of the additional 
layer and separate administrative command set to master, but since lvm 
requires userspace configuration, I had to keep at least the rootfs and 
its backup on mds not handled by lvm, which substantially reduced the 
benefit of LVM in the first place.  It simply wasn't worth it!

So I'm with you all the way on wishing to be rid of the LVM layer, for 
sure!  Being rid of md as well would be nice, but as I said, btrfs 
doesn't have the three-way-plus mirroring I'm looking for yet, and even 
if it did, it's not mature enough to kill at least my backup mds, tho I'm 
leading edge enough that I'd consider it to replace my primary mds if I 
could.

>>  Having absolutely no knowledge of the btrfs
>> code, this seems easy, I'm sure you'll tell me otherwise.  ;)  But one
>> needs:
>> 
>> 1) The ability to "group" a heterogeneous set of disks into the
>> "halves" of a raid1.  I don't understand what btrfs is doing if you
>> give it more than 2 devices and ask for raid1.

Again, see that sysadmin page on the wiki.  Basically, it distributes two 
copies of each block, making sure each copy is on a different device, 
among all the devices.  But the diagram on that page explains it better 
than I can, here.

The difference against your description, however, is that while any 
single device can fail without loss, the distribution is such that you 
don't have two "sides", thus allowing multiple devices on the same side 
to fail as long as the other side is fine.  However, you state that 
single device failure is all you're looking to cover, so you should be 
fine.

>> 2) Intellegently rebalance when a new device is added or removed (e.g.
>> rearrange the halves, and rebalance as necessary)
> 
>    A balance operation is incredibly expensive. It would be much
> better to have a complex policy on when to rebalance. Think of trying to
> add two new disks to a nearly-full 20TB array: you really don't want to
> have to wait for 20TB of data to be rewritten before you add the second
> drive. Such a complex policy doesn't belong in the kernel (and probably
> doesn't belong in code, unless you've got some mind-reading software, or
> a webcam and enough image-processing to identify the stack of disks on
> the admin's desk).
> 
>    I'm not trying to argue that you shouldn't automatically rebalance
> after a new device is added, but more that the feature probably
> shouldn't be in the kernel.

Agreed.  There will likely be scripts available with that sort of 
intelligence if there aren't already, but they'd need customized to a 
degree that's definitely not kernelspace appropriate, and probably isn't 
btrfs-tools userspace appropriate either, except possibly as part of a 
collection of optional scripts, which would likely include the snapshot 
scheduler scripts already available as discussed on other recent list 
threads, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

