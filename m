Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50284 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbcHTGax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 02:30:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1baznN-0006n7-Bl
        for linux-btrfs@vger.kernel.org; Sat, 20 Aug 2016 08:30:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Balancing subvolume on a specific device
Date: Sat, 20 Aug 2016 06:30:11 +0000 (UTC)
Message-ID: <pan$dbf6f$52e9f6f3$42f8cce4$2ebbbbc6@cox.net>
References: <df03a71c-8558-520c-af1b-ffb152f65a7d@davideddu.org>
        <20160819171734.GJ20440@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 19 Aug 2016 17:17:34 +0000 as excerpted:

> On Fri, Aug 19, 2016 at 07:09:48PM +0200, Davide Depau wrote:
>> Hello,
>> 
>> I have a btrfs filesystem spanning over two drives: an SSD and HDD.
>> 
>> Label: 'Android Dev'  uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx
>>     Total devices 3 FS bytes used 32.08GiB devid    1 size 21.95GiB
>>     used 12.00GiB path /dev/sda2 devid    2 size 33.22GiB used 12.01GiB
>>     path /dev/sda3 devid    3 size 53.10GiB used 13.01GiB path
>>     /dev/sdb2
>> 
>> (sda is the SSD, sdb is the HDD)
>> 
>> I've got these subvolumes in the filesystem:
>> 
>> ID 258 gen 708 top level 5 path cm13.0 ID 259 gen 708 top level 5 path
>> ccache ID 269 gen 708 top level 5 path omni
>> 
>> I would like the ccache subvol to always be stored on the SSD, unless
>> no disk space is available. Is that possible?
> 
>    No, it isn't, sorry.

As Hugo says, no, not currently.  Balancing certain content to specific 
devices is on the possible projects list (on the wiki), but there's a lot 
of stuff on that list compared to the number of developers working on 
btrfs, so unless a particular requested feature takes the fancy of either 
a developer or someone paying a developer, it's likely to remain on the 
list, undone, for quite some time (five years out at least, which is 
pretty much as far as software development predictions make sense, since 
technology change happens so quickly and sometimes unpredictably).

There's at least three other options to try to get what you mention, 
however.  FWIW, I'm a gentooer and thus build everything from sources 
here, and use ccache myself.  What I do is put all my build stuff, the 
gentoo git and assorted overlay git trees, ccache, kernel sources, the 
binpkg cache, etc, all on a separate "build" btrfs on normal partitions, /
not/ a subvolume.  That way it can go wherever I want, and it, along with 
the main system (/) and /home, but /not/ my media partition (all of which 
are fully independent filesystems on their own partitions, most of them 
btrfs raid1 on a parallel set of partitions on a pair of ssds), on ssd.  
Works great. =:^)

Another option is btrfs on bcache or dmcache, with the cache on ssd of 
course.  Depending how you configure it, that should eventually end up 
with the hot data on the ssd and the colder data on the spinning rust, 
regardless of whether that hot data is ccache or something else.

Finally, it's not an option for me so I've not looked into the details, 
but zfs is more mature than btrfs and offers similar features, plus some 
btrfs doesn't have yet, minus a few others as it's an earlier 
implementation and some of the stuff learned from it was used when 
designing btrfs.  So you might look into it and see if it meets your 
needs.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

