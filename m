Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53629 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbbLVMEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:04:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aBLgH-00014z-Ne
	for linux-btrfs@vger.kernel.org; Tue, 22 Dec 2015 13:04:41 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 13:04:41 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 13:04:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: problem after using btrfs-convert
Date: Tue, 22 Dec 2015 12:04:35 +0000 (UTC)
Message-ID: <pan$33fad$b0f18fca$994b863a$40058d96@cox.net>
References: <28288.1450772045@ccs.covici.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

covici posted on Tue, 22 Dec 2015 03:14:05 -0500 as excerpted:

> Hi.  I had a problem after using btrfs-convert.  The file system would
> notmount, it said could not create uuid tree and the reason was no space
> left on device.  I tried mounting with some options, like
> nospace_cache,nodatacow, but those did not work.  I  could not extend
> the file system since it was not mounted, although there should be a way
> to do thisk, so I rolled back, and extended  under ext4 which does allow
> extending an offline file system and tried again, successfully.
> 
> But I wonder is there a better way to solve this and why can't you
> extend an offline system?

Not even a hint as to what kernel or userspace (btrfs-progs) version 
you're using...

Meanwhile, see the wiki page:

https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

In particular, see the warning at the top, that convert isn't generally 
used or well tested ATM and is rather buggy.

The page also explains the way the conversion works in general, fitting 
btrfs metadata and changes in between the existing ext* data and 
metadata, which is contained within a btrfs snapshot to allow rollback, 
until deletion of that snapshot.

While they're actually working on a convert rewrite ATM, and even on 
expanding it to cover reiserfs as well, even when it works as best it 
possibly can, the resulting btrfs will be somewhat less than ideal, or 
than it could have been had you actually used the ext* as your backup, 
created a new btrfs using mkfs.btrfs and your preferred options, mounted 
it, and then copied all your existing data from the ext* backup.

And since the admin's rule of backups says that by definition of 
(in)action, a backup not made defines the data that would be backed up as 
worth less than the time, hassle and resources required for that level of 
backup (thus covering all cases from no backup at all if the data is 
throw-away or trivially redownloadable, say browser cache, to data worth 
keeping 101 backups of, some kept on-line and/or off-site, just in case 
100 levels of backups fail...), and btrfs itself is still stabilizing, 
not yet fully stable and mature, making the chance of actually needing a 
backup higher than it would be on a fully stable and mature filesystem, 
if that data is worth the time and hassle to do the conversion instead of 
just blowing it away with a mkfs.btrfs in the first place, it's almost 
certainly worth at /least/ that one level of backup, that the existing 
ext* copy would provide, if you mkfs.btrfs a new filesystem elsewhere and 
then copy the data over from the existing ext*.

So starting from a new mkfs.btrfs created btrfs is better in two ways; it 
both ensures you have an untouched existing backup, just in case, and 
starts from a new, empty btrfs, allowing btrfs to use more efficient 
native data and metadata from the very beginning as you copy over the 
data.

Which is why tho a filesystem conversion tool is nice to have in theory, 
I'd never use it myself, and could never in good conscience recommend it 
to others, even once it is fully stable and has been demonstrated bug-
free even for years.  If the data is worth converting rather than simply 
blowing away with a mkfs in the first place, then it's worth having the 
old copy as a backup.  Conversely, if it's not worth having a backup, 
it's not worth the trouble of doing the conversion; just blow away the 
existing data with mkfs and start over with a brand new filesystem. =:^)


Meanwhile, if you hadn't read that page on the wiki, it's almost certain 
that there's a whole lot more information there that will prove useful to 
you as you begin your btrfs journey, so I'd recommend you spend some time 
reading it, perhaps along with the last couple weeks of list threads on 
one of the archives, then post back with any further questions you have.

Here's a nice simple link to either bookmark or memorize. =:^)

https://btrfs.wiki.kernel.org

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

