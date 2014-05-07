Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38480 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaEGKz5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 06:55:57 -0400
Date: Wed, 7 May 2014 03:55:51 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using mount -o bind vs mount -o subvol=vol
Message-ID: <20140507105551.GS10159@merlins.org>
References: <20140504004732.GE9061@merlins.org>
 <pan$422b5$795bfbf0$455b3e56$2333506b@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$422b5$795bfbf0$455b3e56$2333506b@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 05, 2014 at 02:12:30AM +0000, Duncan wrote:
> Marc MERLIN posted on Sat, 03 May 2014 17:47:32 -0700 as excerpted:

Just as an FYI, like (likely) most subscribers, I do prefer Cc on
replies. Without that, I'm much less likely to see your message timely,
or at all if I'm behind on Email.
 
> TL;DR: Put simply, with certain sometimes major exceptions, IMO subvolumes 
> are /mostly/ a solution looking for a problem.  In the /general/ case, I 
> don't see the point and personally STRONGLY prefer multiple independent 
> partitions for their much stronger data safety and mounting/backup 
> flexibility.  That's why I use independent partitions, here.
 
I'm a partitions guy, but now that I have subvolumes which can be
snapshotted/backed up independently, I'm much happier with a single
shared pool.
Look at a btrfs pool like an LVM pool, except more flexible.

To each their own I guess.

> 1) Multiple subvolumes on a common filesystem share the filesystem tree- 
> and super-structure.  If something happens to that filesystem, you had 
> all your data eggs in that one basket and the bottom just dropped out of 
> it!  If you can't recover, kiss **ALL** those data "eggs" goodbye!

Backups :)
(and having your booting filesystem on a different pool from you data
pool).
 
> 3) Filesystem size and time to complete whole-filesystem operations such 
> as balance, scrub and check are directly related; the larger the 
> filesystem, the longer such operations take.  There are reports here of 
> balances taking days on multi-terabyte filesystems, and double-digit 
> hours isn't unusual at all.

True, but if I have a 10TB array, I'm not going to cut it into 10 1TB
arrays just for that.
 
> Now ask yourself, how likely are you to routinely run a scrub or balance 
> as preventive maintenance if you know it's going to take the entire day 
> to finish?  Here, the times are literally so trivial can and do run a 
> full filesystem rebalance to time it and make this point and maintenance 
> such as scrub or balance simply ceases to be an issue.

It runs nightly from cron on my laptop. 1TB filesystem on SSD, no sweat.
 
> 4) Many distros are using btrfs subvolumes on a single btrfs "storage 
> pool" the way they formerly used LVM volume groups, as a common storage 
> pool allowing them the flexibility to (re)allocate space to whatever lvm 
> volume or btrfs subvolume needs it.

Yep.
 
> OTOH, for users and distros with a pretty good idea of what their 
> allocations are going to look like, generally due to the experience 
> they've gained over the years, that extra flexibility isn't a big benefit 

You and me yes, most other people no.
And to be honest, I've been doing this for 20 years, and my guesses are
not always right 10 years later on a machine that's still running :)
(of which I have several)

> 6) Subvolumes be used to control snapshotting since snapshots stop at 
> subvolume boundaries.  In the presence of point #5 "storage pools", and 
> given the reality of btrfs NOCOW attribute behavior when mixed with 
> snapshots, subvolumes become an important tool for limiting snapshot 
> coverage area, in particular, for demarcing areas that should NOT be 
> snapshotted when the filesystem or parent subvolume is snapshotted, due 
> for instance to the horrible interaction between large heavy-internal-
> rewrite files and COW, which means they should be set NOCOW, coupled with 
> the horrible interaction between NOCOW on such files and snapshotting.

Yep.
 
> Similarly, subvolumes and their boundaries can be used to set borders for 
> frequency or timing of snapshotting, say snapshotting the general
> root/system tree before updates, while snapshotting /home hourly.

Yep.

> Point #6 is, I'd argue, one of the few "legitimate" use-cases for 
> subvolumes as opposed to independent filesystems, and it actually loses 
> relevancy if #4 is subsumed to point #1 and #3, already.  However, given 
> the reality of popular distro btrfs layouts and usage, #4 is in practice 
> overruling all the others in many distro-default btrfs deployments today, 
> and #6 then becomes relevant.

subvolumes are also used as units of backup for btrfs send.
 
> So my vote would be, for example (modified slightly for posting from my 
> own mounts):
> 
> mount /dev/sda5 /
> mount /dev/sda4 /var/log
> mount /dev/sda6 /home

On my laptop:
/dev/mapper/cryptroot on / type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/cryptroot on /usr type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/cryptroot on /var type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/cryptroot on /home type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/cryptroot on /tmp type btrfs (rw,noexec,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/cryptroot on /var/local/nobckd2 type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/disk2 on /var/local/space type btrfs (rw,noatime,compress=lzo,discard,space_cache)

/dev/mapper/cryptroot on /mnt/btrfs_pool1 type btrfs (rw,noatime,compress=lzo,ssd,discard,space_cache)
/dev/mapper/disk2 on /mnt/btrfs_pool2 type btrfs (rw,noatime,compress=lzo,discard,space_cache)

But to each their own :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
