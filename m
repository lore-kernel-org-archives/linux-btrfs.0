Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:57893
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab2JZCdy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 22:33:54 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [RFC] New attempt to a better "btrfs fi df"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com>
Date: Thu, 25 Oct 2012 20:33:52 -0600
Message-Id: <1D6DC5A8-27E2-4470-B5D0-D1A7CC639825@colorremedies.com>
References: <50899151.1070503@inwind.it> <3BC0780A-C657-4195-BBAB-FFBDDBD989FB@colorremedies.com> <CAE5mzvi=czHnRcBUkyTn7NxzCRiZ-5GcZtZt8KGEX0tUiUz73g@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 25, 2012, at 2:11 PM, cwillu <cwillu@cwillu.com> wrote:
>> 
>> 1. Why is FS bytes used = 3.91GB, yet devid 1 used is 9.13 GB?
> 
> "FS bytes" is what du -sh would show.  "devid 1 used" is space
> allocated to some block group (without that block group itself being
> entirely used)

I agree the word "used" shouldn't be used twice when it can have two different values like this; or drop one of the values entirely. Which more correctly reflects the amount of data+metadata?

>> 2. Why before a rebalance does 'fi df' show extra lines, and then after rebalance there are fewer lines? Another case with raid10, 'fi df' shows six lines of data, but then after rebalance is shows three lines?
> 
> A bug in mkfs causes some tiny blockgroups with the wrong profile to
> be created; as they're unused, they get cleaned up by the balance.

OK. I'd have to try to reproduce. I'm virtually certain right after mkfs.btrfs and subsequent OS installation, but before reboot from the installer that 'fi df' did not indicate 72GB of allocated or used space.


> Plain old "/bin/df" is adequate for that though, and in the mean time
> one _does_ need _all_ of that information to work with the filesystem.
> However, the detailed breakdown is vital to answer many questions:

If we're going to borrow an old term like df, which equates to "display free (space)" then it kinda needs to do that, or try to, as it's point of emphasis. And right now that's a significant missing piece to 'btrfs fi df' is the free part. Inferring it from a LOT of other information I'd characterize as quite less than ideal. If


> "Why can't I write to my filesystem with 80gb free?  <btrfs fi df>
> Oh, because metadata is raid1 and the one disk is 80gb smaller than
> the other."
> 
> "How much data is on this disk that started giving SMART errors?"
> 
> "How many GB of vm image files (or other large files) can I probably
> fit on this fs?"
> 
> "How many GB of mail (or other tiny files) can I probably fit on this fs?"
> 
> "Is there enough space to remove this disk from the fs, and how much
> free space will I have then?"
> 
> And the all-important "Could you please run btrfs fi df and pastebin
> the output so we can tell what the hell is going on?" :)

So what's the intended distinction between 'fi df' and 'fi show'? Because for months using btrfs I'd constantly be confused which command was going to show me what information I wanted, and that tells me there should be some better distinction between the commands.


Chris Murphy