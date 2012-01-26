From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Trying to mount RAID1 degraded with removed disk -> open_ctree
 failed
Date: Thu, 26 Jan 2012 11:17:33 +0000 (UTC)
Message-ID: <pan.2012.01.26.11.17.33@cox.net>
References: <jfh8ja$pa$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Dirk Lutzebaeck posted on Sun, 22 Jan 2012 16:05:14 +0100 as excerpted:

> I have setup a RAID1 using 3 devices (500G each) on separate disks.
> After removing one disk physically the filesystem cannot be mounted in
> degraded nor in recovery mode.

> - latest kernel 3.2.1 and btrfs-tools on xubuntu 11.10

> What is happening? RAID1 should be mountable degraded with one
> missing/removed device.

Note that I'm only researching btrfs for my own systems at this point and 
am not using it yet.  However, because I *AM* researching it and already 
read thru most of the wiki documentation, it's fresh in mind.

Here's what the wiki says, tho of course it could be outdated:

https://btrfs.wiki.kernel.org/

>From the multiple devices page:

>> By default, metadata will be mirrored across two devices and data will
>> be striped across all of the devices present.

Question:  Did you specify -m raid1 -d raid1 when you did the mkfs.btrfs?

While the -m raid1 would be the default given multiple devices, the -d 
raid1 is not.  If you didn't specify -d raid1, you'll have raid0/striped 
data with only the metadata being raid1/mirrored, thus explaining the 
problem.


At least with all devices present, the following should show the raid 
level actually used (from the use cases page):

>> On a 2.6.37 or later kernel, use
>> 
>> btrfs fi df /mountpoint
>> 
>> The required support was broken accidentally in earlier kernels,
>> but has now been fixed.

Also note since you're running a 3-device btrfs-raid-1, tho it shouldn't 
affect a single device dropout, from the sysadmin guide page (near the 
bottom of the raid and data replication section):

>> With RAID-1 and RAID-10, only two copies of each byte of data are
>> written, regardless of how many block devices are actually in use
>> on the filesystem.

IOW, unlike standard or kernel/md raid-1, that 3-device btrfs-raid-1 will 
**NOT** protect you if two of the three devices go bad before you've had 
a chance to bring in and balance to a replacement for the first bad 
device.

As I said I'm just now researching my own btrfs upgrade, and don't know 
for sure whether that's true or not, but if it is, it's a HUGE negative 
for me, as I'm currently running 4-way kernel/md RAID-1 on an aging set 
of drives, and was hoping to upgrade to btrfs raid-1 for the checksummed 
integrity.  But given the age of the drives I really don't want to drop 
below dual redundancy (3 copies), and this two-copies-only (single 
redundancy) raid-1(-ish) no matter the number of devices, is 
disappointing indeed!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

