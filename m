Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60080 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbcAPOLJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jan 2016 09:11:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aKRZK-00056x-Kq
	for linux-btrfs@vger.kernel.org; Sat, 16 Jan 2016 15:11:06 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 15:11:06 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jan 2016 15:11:06 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)?
 Explain like I'm five pls.
Date: Sat, 16 Jan 2016 14:10:59 +0000 (UTC)
Message-ID: <pan$6d016$7902b96d$a10088a$d023ef02@cox.net>
References: <loom.20160116T132316-196@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Al posted on Sat, 16 Jan 2016 12:27:16 +0000 as excerpted:

> This must be a silly question! Please assume that I know not much more
> than nothing abou*t fs.
> I know dedup is traditionally costs a lot of memory, but I don't really
> understand why it is done like that. Let me explain my question:
> 
> AFAICT dedup matches file level chunks (or whatever you call them) using
> a hash function or something which has limited collision potential. The
> hash is used to match blocks as they are committed to disk, I'm talking
> online dedup*, and reflink/eliminate the duplicated blocks as necessary.
>  This bloody great hash tree is saved in memory for speed of lookup (I
> assume).
> 
> But why?
> 
> Is there any urgency for dedup? What's wrong with storing the hash on
> disk with the block and having a separate process dedup the written data
> over time; dedup'ing data immediately when written to high-write-count
> data is counter productive because no sooner has it been deduped then it
> is rendered obsolete by another COW write.
> 
> There's also the problem of opening a potential problem window before
> the commit to disk, hopefully covered by the journal, whilst we seek the
> relevant duplicate if there is one.
> 
> Help me out peeps? Why is there a such an urgency to have online dedup,
> rather than a triggered/delayed dedup, similar the current autodefrag
> process?
> 
> Thank you. I'm sure the answer is obvious, but not to me!
> 
> * dedup/dedupe/deduplication

There's actually uses for both inline and out-of-line[1] aka delayed 
dedup.  Btrfs already has a number of independent products doing various 
forms of out-of-line dedup, so what's missing and being developed now is 
the inline dedup option, which being directly in the write processing, 
must be handled by btrfs itself -- it can't be primarily done by third 
parties with just a few kernel calls, like out-of-line dedup can.

Meanwhile, the inline dedup implementation being considered for mainline 
is itself built on two previously available implementations, developed 
more or less independently with different goals in mind, with the planned 
mainline implementation sharing what it can between the two but still 
giving the user the choice of which one to actually run.

The one uses the in-memory hash functionality much as you described.  
This one should be faster, but will require more memory to store the 
hashes and will miss some dedup opportunities simply because it doesn't 
have them hashed when the write request comes.

The other one will store its hashes on block-device[2], making it slower, 
but also allowing it to have higher capacity hash storage, which being on-
block-device, will normally survive reboots and simple umount/mount 
cycles, thus deduplicating far more efficiently, if at the expense of 
speed.

But because both of these are inline implementations, they compare 
incoming writes to what they already have hashed, and thus don't take two 
filenames to compare and dedup if possible.  That functionality is thus 
left for out-of-line dedup methods, if desired.  Particularly if one is 
using the inline in-memory variant, they may well want to followup with 
out-of-line dedup runs at a later time, in ordered to catch what the fast 
but not particularly efficient inline-in-memory dedup missed.

Make more sense now? =:^)

---
[1] I prefer the terms inline and out-of-line to online/offline, since 
the filesystem is still online when they run making the term offline 
confusing, since it doesn't mean "offline" as in what offline means for 
fsck, for instance.

[2] On block-device:  I'm trying to get out of the habit of referring to 
disks, as that sounds rather anachronistic when it could just as easily 
be an ssd, having nothing to do with actual spinning disks.  So I'll 
normally use simply device, or storage device, except here that could be 
confused with memory device, which is the other option, so I call it a 
block-device.
-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

