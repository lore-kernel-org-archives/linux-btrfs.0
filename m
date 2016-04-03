Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40623 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbcDCFG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Apr 2016 01:06:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1amaF0-0000R4-7P
	for linux-btrfs@vger.kernel.org; Sun, 03 Apr 2016 07:06:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 07:06:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 07:06:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
Date: Sun, 3 Apr 2016 05:06:19 +0000 (UTC)
Message-ID: <pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Sun, 03 Apr 2016 06:02:02 +0200 as excerpted:

> No, other files are affected, too. And it looks like those files are
> easily affected even when removed and recreated from whatever backup
> source.

I've seen you say that several times now, I think.  But none of those 
times has it apparently occurred to you to double-check whether it's the 
/same/ corruptions every time, or at least, if you checked it, I've not 
seen it actually /reported/.  (Note that I didn't say you didn't report 
it, only that I've not seen it.  A difference there is! =:^)

If I'm getting repeated corruptions of something, that's the first thing 
I'd check, is there some repeating pattern to those corruptions, same 
place in the file, same "wanted" value (expected), same "got" value, (not 
expected if it's reporting corruption), etc.

Then I'd try different variations like renaming the file, putting it in a 
different directory with all of the same other files, putting it in a 
different directory with all different files, putting it in a different 
directory by itself, putting it in the same directory but in a different 
subvolume... you get the point.

Then I'd try different mount options, with and without compression, with 
different kinds of compression, with compress-force and with simple 
compress, with and without autodefrag...

I could try it with nocow enabled for the file (note that the file has to 
be created with nocow before it gets content, for nocow to take effect), 
tho of course that'll turn off btrfs checksumming, but I could still for 
instance md5sum the original source and the nocowed test version and see 
if it tests clean that way.

I could try it with nocow on the file but with a bunch of snapshots 
interwoven with writing changes to the file (obviously this will kill 
comparison against the original, but I could arrange to write the same 
changes to the test file on btrfs, and to a control copy of the file on 
non-btrfs, and then md5sum or whatever compare them).

Then, if I had the devices available to do so, I'd try it in a different 
btrfs of the same layout (same redundancy mode and number of devices), 
both single and dup mode on a single device, etc.

And again if available, I'd try swapping the filesystem to different 
machines...

OK, so trying /all/ the above might be a bit overboard but I think you 
get the point.  Try to find some pattern or common element in the whole 
thing, and report back the results at least for the "simple" experiments 
like whether the corruption appears to be the same (same got at the same 
spot) or different, and whether putting the file in a different subdir or 
using a different name for it matters at all.  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

