From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: LABEL only 1 device
Date: Thu, 1 Mar 2012 00:54:59 +0000 (UTC)
Message-ID: <pan.2012.03.01.00.54.58@cox.net>
References: <20120226153036.GB18898@carfax.org.uk>
	<C3b12r9i1uB@helmut.hullen.de> <20120226164400.GC18898@carfax.org.uk>
	<pan.2012.02.26.18.07.31@cox.net> <20120228223557.GA4515@x2.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Karel Zak posted on Tue, 28 Feb 2012 23:35:57 +0100 as excerpted:

> On Sun, Feb 26, 2012 at 06:07:31PM +0000, Duncan wrote:
>> Unfortunately, since gpt is reasonably new in terms of filesystem and
>> partitioning tools, there isn't really anything (mount, etc) that makes
>> /use/ of that label yet,
> 
> udev exports GPT labels and uuids by symlinks, see
> 
>   ls /dev/disk/by-partlabel/
>   ls /dev/disk/by-partuuid/

So it does. =:^)  I knew about the /dev/disk/by-*/ dirs in general and 
had no doubt browsed past them before without actually noting the 
significance, but hadn't actually noticed the by-part* until you pointed 
it out specifically.  Either that or exporting these is relatively new to 
udev, tho it's probably been there and I simply didn't see it.

Either way, thanks! =:^)

> you can use these links in your fstab.

Yes.  Now that I know they are there, using them in fstab makes sense, 
since I remember seeing the note in the mount manpage that it uses the 
udev symlinks internally already, so whatever udev does in this regard 
should "just work" with mount, and thus in fstab.

Useful indeed! It seems modern Linux (or more properly, a modern udev and 
mount, along with the kernel of course) has rather more use for partition-
labels than I was aware and thus than I was giving it credit for! =:^)

Thanks!

> And if I good remember kernel
> supports PARTUUID for root= command line option.

That wouldn't surprise me at all.

That leaves grub2 (and other bootloaders).  I already know grub2 prefers 
UUIDs to /dev/* device names.  But I don't know if it handles labels, 
either the gpt-partlabel or the fs-label version.  I'll have to try that 
too.  Fortunately for me my device ordering is quite stable (and I hand-
edit grub.cfg, no mkgrub-config here), so that "just works".  But UUIDs 
are designed for computer use, not human use, while labels work well for 
both, so if grub2 handles labels and I can use either fs or partition/
device labels there too, I'll be a happy camper indeed! =:^)


But just knowing mount/fstab supports partlabels is going to be a boon 
for me!  My current setup (pending multi-way raid1 mirroring, and perhaps 
a bit more stability, in btrfs) has multiple partitions and partitioned 
md/raids, with working and backup copies of nearly all of them.  When I 
update the backup, I often mkfs and start with a clean filesystem, then 
copy all the data over from the working copy.  The mkfs step of course 
changes filesystem UUID and my labeling scheme includes the date the 
filesystem and backup image was made, so it changes too.  So while I've 
been using (filesystem) labels in fstab for some time, I've had to update 
them when I update my backups.

Now I should be able to use the partlabels in fstab instead, and those 
only change if I repartition, a much less frequent occurrence, meaning I 
can update my backups without having to update the fstab for mounting 
them, at the same time. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

