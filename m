Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:40822
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030378Ab2LIC7L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Dec 2012 21:59:11 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Help with corrupt filesystem: __btrfs_free_extent:5236: IO failure
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20121209003849.GB31750@lintop>
Date: Sat, 8 Dec 2012 19:59:09 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <2DED9190-CF55-4E4E-8646-B411D02C9376@colorremedies.com>
References: <20121208161653.GA31750@lintop> <F0BF473A-0D76-4CCF-9DDC-A7C8EB8DB211@colorremedies.com> <20121209003849.GB31750@lintop>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 8, 2012, at 5:38 PM, Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
> 
> 
> These types of errors continued for a 15+ minutes mostly "btrfs read
> error corrected" and "parent transid verify failed".  After running
> the smartctl checks on the drives I thought the "read error corrected
> messages" were promising so I thought doing a scrub would be safe.
> After starting the scrub I got some different types of messages in
> dmesg which I can post if people are interested but here is the
> summary:
> 
> # btrfs scrub status /
> scrub status for 5517b4f7-f962-4e67-a4a0-df96c6ced151
> scrub started at Wed Dec  5 21:24:18 2012 and was aborted after 6152 seconds
> total bytes scrubbed: 1.88TB with 20483 errors
> error details: verify=19900 csum=583
> corrected errors: 20483, uncorrectable errors: 0, unverified errors: 0

Since the connection is producing bad/unreliable results, btrfs's corrections are questionable and may even become corrupted on the way to the drives in the course of the scrub.

SMART isn't reporting any bad sectors for either drive. Both drives have UDMA errors which are device to/from host errors. And you have a bunch of interface related errors from your original post. I suspect a cable and/or controller problem.

https://bugzilla.redhat.com/show_bug.cgi?format=multiple&id=539637

Both drives seem to be having some seek errors, but within the threshold set by Seagate for pre-fail and seems to be normal for this drive model.



> 
>> sdc and sdd are on the same or different controllers? If it's the
>> same, sounds like bad/loose cable to sdc, or the interface on sdc
>> itself is failing.
> 
> Both drives are connected to the same controller:
> 
> 00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port SATA AHCI Controller (rev 02)
> 
> I can try replacing the cables and checking the connections.

Definitely do that, it's easy and cheap.
> 
>>> 
> 
> The initial errors led me to the following:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625922

1. Not your SATA controller.
2. Kernel not in the realm of recency as yours.
3. Barracuda, but not your model or firmware. So even though it carries the same brand name, I don't know how related it is to the drives in the bug report and other reports.

How old is this setup? You haven't had other file system corruptions? I think everything points to hardware rather than kernel.

>  Is it
> a bad idea to try to rsync some of it to separate drives while the
> filesystem is mounted read only?

No, I think the SMART data you provided indicates low probability there's a problem with the drives themselves (maybe you have a flakey interface but mechanically I don't think either drive looks like it's about to fail). But I can't tell you if the data you're copying off will be valid. You'll soon find out. You could follow the first rsync up with another sync using --checksum to see if you're getting a good transfer. This will be slow.


Chris Murphy