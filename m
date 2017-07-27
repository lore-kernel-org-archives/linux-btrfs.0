Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47836 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdG0UZw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 16:25:52 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dapLm-00020Z-Ax
        for linux-btrfs@vger.kernel.org; Thu, 27 Jul 2017 22:25:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Raid0 rescue
Date: Thu, 27 Jul 2017 20:25:19 +0000 (UTC)
Message-ID: <pan$2c543$d5ad45a3$4b673920$5f7cee9a@cox.net>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
        <20170727151038.GT7140@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 27 Jul 2017 15:10:38 +0000 as excerpted:

> On Thu, Jul 27, 2017 at 10:49:37AM -0400, Alan Brand wrote:
>> I know I am screwed but hope someone here can point at a possible
>> solution.
>> 
>> I had a pair of btrfs drives in a raid0 configuration.  One of the
>> drives was pulled by mistake, put in a windows box, and a quick NTFS
>> format was done.  Then much screaming occurred.
>> 
>> I know the data is still there. [...]

>> I can't run a normal recovery as only half of each file is there.
> 
>    Welcome to RAID-0...

Hugo, Chris Murphy, or one of the devs should they take an interest, are 
your best bets for current recovery.  This reply only tries to fill in 
some recommendations for an eventual rebuild.

As Hugo implies, RAID-0 mode, not just for btrfs but in general, is well 
known among admins for being "garbage data not worth trying to recover" 
mode.  Not only is there no redundancy, but with raid0 you're 
deliberately increasing the chances of loss because now loss of any one 
device pretty well makes garbage of the entire array, and loss of any 
single device in a group of more than one is more likely than loss of any 
single device by itself.

So first rule of raid0, don't use it unless the data you're putting on it 
is indeed not worth trying to rebuild, either because you keep the 
backups updated and it's easier to just go back to them than to even try 
recovery of the raid0, or because the data really is garbage data, 
internet cache, temp files, etc, that it's really just better to scrap 
and let the cache rebuild, etc, than try to recover.

That's in general.  For btrfs in particular, there's some additional 
considerations altho they don't change the above.  If the data isn't 
quite down to the raid0-garbage, just-give-up-and-start-over, level, with 
btrfs, what you likely want is metadata raid1, data single, mode, which 
is the btrfs multi-device default.

The raid1 metadata mode will mean there's two copies of metadata, one on 
each of two different devices, so it'll tolerate loss of a single device 
and still let you at least know where the files are located and give you 
a chance at recovery.  But since metadata is typically a small fraction 
of the total, you'll not be sacrificing /too/ much space for that 
additional safety.

The single data mode will normally put files (under a gig filesize 
anyway, tho as the size increases toward a gig the chances of it all 
being on a single device go down) all on one device, so with a loss of a 
device, you'll either still have the file or you won't.  The contrast 
with raid0 mode is that its line is 64k instead of a gig, above which the 
file will be striped across multiple devices, so indeed, with a two-
device raid0, half of each file, in alternating 64k pieces, is what you 
have left if one of the devices goes bad, while with single, your chances 
of whole-file recovery, assuming it wasn't /entirely/ on the bad device, 
are pretty good upto a gig or so.

And because btrfs is still in the stabilizing, "get-the-code-correct-
before-you-worry-about-optimizing-it" mode, unlike more mature raid 
implementations such as the kernel's mdraid, btrfs still normally 
accesses only one device at a time, so btrfs raid0 only gets you the 
space advantage, not the usual raid0 speed advantage.  So btrfs single 
mode isn't really much if any slower than raid0, while being much safer 
and offering the same (or even better in the case of differing device 
sizes) size advantage as raid0.

Put differently, there's really very little case for choosing btrfs raid0 
mode at this time.  Maybe some years in the future when raid0 mode is 
speed-optimized that will change, but for now, single mode is safer and 
in the case of unequal device sizes makes better use of space, while 
being generally as fast, as raid0 mode, so single mode is almost 
certainly a better choice.

Meanwhile, back to the general case again:  Admin's first rule of 
backups:  The *true* value you place on your your data is defined not by 
arbitrary claims, but by the number of backups of that data you have.  No 
backups, much like putting the data on raid0, defines that data as of 
garbage value, not worth the trouble to try to recover in the case of 
raid0, not worth the trouble of making the backup in the first place in 
the case of no backup.  Of course really valuable data will have multiple 
backups, generally some of which are off-site in case the entire site is 
lost (flood, fire, earthquake, bomb, etc), while others are on-site in 
ordered to facilitate easy recovery from a less major disaster, should it 
be necessary.

Which means, regardless of whether files are lost or not, what was of 
most value as defined by an admin's actions (or lack of them in the case 
of not having a backup) is always saved, either the time/resources/
trouble to make the backup in the first place if the data wasn't worth 
it, or the data, if the backup was made and is thus available for 
recovery purposes.

So if you lost the data and didn't have a backup, particularly if it was 
on a raid0 which declares at least that instance of the data to be not 
really worth the trouble of an attempt at recovery anyway, at least you 
can be glad you saved what your actions defined as most important, the 
time/resources/trouble to make that backup that you didn't have, because 
the value of the data wasn't worth having a backup. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

