Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51445 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbcIYFoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 01:44:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bo2F1-0002eD-TS
        for linux-btrfs@vger.kernel.org; Sun, 25 Sep 2016 07:44:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Date: Sun, 25 Sep 2016 05:44:30 +0000 (UTC)
Message-ID: <pan$9d4de$8d8969eb$2fd5352c$14a0ea2c@cox.net>
References: <767591474719974@web21o.yandex.ru>
        <20160924123749.GR7138@carfax.org.uk> <1498471474759532@web22g.yandex.ru>
        <20160924235014.GA2247@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Sun, 25 Sep 2016 01:50:14 +0200 as excerpted:

> On Sun, Sep 25, 2016 at 02:25:32AM +0300, Alexander Tomokhov wrote:
>> Ok, so data checksumming does not remain for newly created empty files
>> with No_COW attribute.  I think it's an important trait of Btrfs
>> behavior and should be added to wiki.  So that users are informed that
>> disabling CoW on a per-file basis also loses checksum correctness of
>> such file.
> 
> Actually, it disables pretty much all btrfs features except for... CoW.
> 
> You lose:
> * checksums
> * compression
> * safety against power loss (torn writes, etc)
> * transactions (not that anyone uses them...)
> * etc

> But, CoW is still there.

> Try it: make a subvolume, create a
> FS_NO_COW file (preferably one big enough), snapshot the subvolume,
> filefrag -v both copies.  Write to one of them, changing only a part of
> file.  Wait for writeout, filefrag -v them again.

That's because snapshots depend on COW.  If you don't snapshot the file 
(or otherwise create additional reflinks to it, using cp --reflink=always, 
for instance), it'll be NOCOW.  But because snapshots (and other forms of 
multiple reflink) depend on COW, taking a snapshot (or otherwise multi-
reflinking) and then writing to one copy forces what has been referred to 
on this list as COW1, a single COW to break the multi-reflink.

However, COW1 doesn't change the NOCOW attribute, and further writes to 
the same block of the NOCOW file will overwrite the now-current block, 
instead of COWING it... until the next snapshot (or another multi-reflink 
operation) locks it too in place, of course, after which another COW1 
will be required.

Which means otherwise NOCOW files that are both repeatedly overwritten 
and repeatedly snapshotted, with both happening at about the same rate or 
snapshots happening more frequently than rewrites, will tend to fragment 
almost as fast as if they hadn't been set NOCOW in the first place.

So NOCOW still has an effect -- as long as rewrites are coming in more 
frequently than snapshots.  However, if the file is repeatedly snapshotted 
at the same or faster rate than it is rewritten, all those COW1s due to 
the repeated snapshotting will pretty effectively nullify the NOCOW 
setting, even if it otherwise remains valid.

The other alternative, of course, is to avoid snapshotting your NOCOW 
files (which of course means losing send/receive, since send requires a 
read-only snapshot).  You can choose one or the other, but can't have 
both without one, NOCOW, yielding to the other.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

