Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44690 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab3FCF06 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Jun 2013 01:26:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UjNID-0005XE-R2
	for linux-btrfs@vger.kernel.org; Mon, 03 Jun 2013 07:26:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 07:26:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 07:26:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID10 total capacity incorrect
Date: Mon, 3 Jun 2013 05:26:33 +0000 (UTC)
Message-ID: <pan$ac513$8629998c$786e3c74$d6f66ecd@cox.net>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
	<099CD4A1-A70D-4446-8C55-843D21BE4E7F@colorremedies.com>
	<20130602174359.GI20133@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 02 Jun 2013 18:43:59 +0100 as excerpted:

> On Sun, Jun 02, 2013 at 12:52:40PM -0400, Chris Murphy wrote:
>> 
>> [I]t's confusing. btrfs fi df doesn't show free space. The first
>> value is what space the fs has allocated for the data usage type,
>> and the 2nd value is how much of that allocation is actually being
>> used. I personally think the allocated value is useless for mortal
>> users. I'd rather have some idea of what free space I have left, and
>> the regular df command presents this in an annoying way also because it
>> shows the total volume size, not accounting for the double consumption
>> of raid1. So no matter how you slice it, it's confusing.
> 
> It's the nature of the beast, unfortunately. So far, nobody's
> managed to come up with a simple method of showing free space and space
> usage that isn't going to be misleading somehow.

btrfs.wiki.kernel.org covers this topic as well as I guess it's possible 
to be covered at this point, in the FAQ.  I definitely recommend reading 
the user documentation section there, to any btrfs or potential btrfs 
user who hasn't done so already, as it really does cover a lot of 
questions, tho certainly not all (as my posting history here, after 
reading it, demonstrates).

Home page (easiest to remember):

https://btrfs.wiki.kernel.org

Direct link to the documentation section on that page (perhaps more 
useful as a bookmark):

https://btrfs.wiki.kernel.org/index.php/Main_Page#Documentation

The FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ

Direct link to FAQ section 4.4, which starts the questions that deal with 
space (4.4-4.9):

https://btrfs.wiki.kernel.org/index.php/
FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

In addition, people using multiple devices should read the sysadmin guide 
and multiple devices pages (which can be found under the docs link 
above), tho they don't really cover space questions.  (But the raid-10 
diagram in the sysadmin guide may be helpful in visualizing what's going 
on.)

In particular, see the "Whis is free space so complicated?" question/
answer, which explains the "why" of Hugo's answer -- I don't believe it's 
yet implemented, but the plan is to allow different subvolumes, which can 
be created at any time, to have different raid levels.  Between differing 
data and metadata levels and differing subvolume levels, in the general 
case there's simply no reasonable way to reliably report on the 
unallocated space, since there's no way to know which raid level it'll be 
allocated as, until it actually happens.

Of course the answer in limited specific cases can be known.  Here, I'm 
just deploying multiple btrfs filesystems across two SSD devices, 
generally raid1[1] for both data/metadata, with no intention of having 
differing level subvolumes, so I can simply run regular df and divide the 
results in half in my head.  btrfs filesystem df gives me different, much 
more technical information, so it's useful, but not as simply useful as 
regular df, halving the numbers in my head.

Tim (the OP)'s case is similarly knowable since he's raid10 both data/
metadata across originally four, now eight, similarly sized 2TB devices 
(unlike me, he's apparently using the same btrfs across the entire 
physical device, all now eight devices), assuming he never chooses 
anything other than raid10 data/metadata for subvolumes, and sticks with 
two-mirror-copy raid10 once N-way mirroring becomes possible.

btrfs raid10, like its raid1, is limited to two mirror-copies, so with 
eight similarly-sized devices and the caveat that he has already 
rebalanced across all eight devices since doubled from four, he's raid10 
4-way striping, two-way-mirroring.

I'd guess normal df (not btrfs filesystem df) and doing the math in his 
head will be the simplest for him, as it is for me.

But it's worth noting that normal df with math in your head isn't 
/always/ going to be the answer, as things start getting rather more 
complex as soon as different sized devices get thrown into the mix, or 
raid1/10 on an /odd/ number of devices (tho there the math simply gets a 
bit more complex since it's no longer integers), let alone the case of 
differing data/metadata allocation mode, without even considering the 
case of subvolumes having different modes, since I don't think that's 
implemented yet.

But in the simple cases of data/metadata of the same raid level on either 
just one or an even number of devices, regular df, doing the math in your 
head, should be the simplest and most direct answer.  As I said, btrfs 
filesystem df and btrfs filesystem show are useful, but for more 
technical purposes or in the complex cases where there's no easy way to 
just do the math on normal df.

---
[1] My single exception is a separate tiny /boot, one to each device, --
mixed data/metadata DUP mode, as they're a quarter gig each.  I went 
separate here and separately installed grub2 to each device as well, so I 
can independently boot from either device.  My legacy/backup "spinning 
rust" device, all reiserfs, is bootable as well, thus giving me three 
separate boot devices using two different technologies, ssd vs 
traditional spinning rust and long stable reiserfs vs still under heavy 
development btrfs, in case of failure of either a physical device or the 
filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

