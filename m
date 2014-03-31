Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51898 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaCaTpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 15:45:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WUi9J-00018U-Tb
	for linux-btrfs@vger.kernel.org; Mon, 31 Mar 2014 21:45:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 21:45:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 21:45:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Help] Errors found in extent allocation tree or chunk
 allocation
Date: Mon, 31 Mar 2014 19:45:27 +0000 (UTC)
Message-ID: <pan$6d267$8b0a867f$c580cca9$4eb55f7b@cox.net>
References: <ac786c9023364c699d8212b42da536f2-mfwitten@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Witten posted on Mon, 31 Mar 2014 17:39:05 +0000 as excerpted:

> Firstly, it should be noted that I can mount and use my Btrfs file
> system with nary an error or warning; however, I'm uncomfortable using
> it while it's in some kind of inconsistent state.
> 
> The `btrfsck' tool is telling me the following:
> 
>   Errors found in extent allocation tree or chunk allocation
> 
> In particular, I'm receiving 69158 messages of the following form:
> 
>   Extent back ref already exists for <a> parent <b> root <c>
> 
> All of those are followed by the same number of messages of the
> following form:
> 
>   ref mismatch on [<d> 4096] extent item <e>, found <f>
>   Incorrect global backref count on <d> found <e> wanted <f>
>   backpointer mismatch on [<d> 4096]

FWIW, while I'm not sure about those particular errors (I'll let someone 
else tackle that end), btrfsck doesn't yet know about some kinds of 
errors and can also misinterpret some structures it doesn't understand as 
errors when they actually aren't.

IOW, it's a useful tool for the devs and for the curious types, but don't 
be too alarmed by what it says, particularly if the filesystem seems to 
be operating fine in other respects.

That goes double if you're running raid5/6 mode, since support for it in 
general is known to be incomplete as yet -- routine operations work but 
there are known holes in its device drop recovery and scrub support, 
among other things, as the code simply isn't all there yet.  Since btrfsck 
is typically one of the later things on the implementation list, I'd 
expect it to not understand and thus report as errors quite a bit of the 
extended raid5/6 structure.

> I've run several commands in an attempt to repair/recover the file
> system, but nothing seems to help.

Hopefully, none of those commands included btrfsck --repair, because that 
is known to actually make things worse in some instances.  That's the 
last thing to try, generally after you've posted here and gotten 
confirmation that the errors it reports are actual errors and that it can 
actually fix them, without making anything else it's reporting worse.  
Alternatively, it's what you run right before you give up hope and do a 
mkfs, since if that's your next step, your risk is essentially zero 
anyway.

> What is the meaning of these errors, and how should I fix them?

I'd actually put more faith in the btrfs balance command (assuming you 
aren't running raid5/6 mode anyway, I'd consider it effectively raid0, 
only put stuff on it that you expect to be able to throw away and do a 
new mkfs over, if there's errors, tho once that's your expectation it 
doesn't hurt to experiment).  Balance won't fix everything either, but it 
shouldn't make things worse, and since it rewrites all chunks both data 
and metadata, if it finishes without complaining about anything and 
you're not seeing any problems elsewhere, you're reasonably safe in 
assuming you can ignore whatever "errors" btrfsck is 
/claiming/ you have.

Btrfs scrub is another alternative (altho as I said not for raid5/6 yet 
as the support there is known to be unfinished and it WILL complain about 
errors that aren't there!), validating checksums on everything, tho while 
it can spot data corruption it only actually fixes the problem on data/
metadata that has a second, checksum-valid copy, around.  On a default 
btrfs that'll be all metadata chunks since they're default-dup mode 
(except on SSD) on a single device btrfs, and default-raid1 (2-way-
mirrored) on a multi-device btrfs, while actual data always defaults to 
single mode, so it's checksummed but without a backup if there's 
corruption.  Of course, if you have both data and metadata in raid1 or 
raid10 mode (or if you're running a mixed-data/metadata chunk filesystem, 
the default for filesystems under a gig, which further defaults to dup 
mode if on a single device), there should be a second copy of data as 
well, and (assuming the checksum verifies on the second copy) scrub can 
restore from that.

FWIW, most of my btrfs are raid1 mode both data/metadata here, for just 
that reason.  And I'm on SSD (tho my media partition and second level 
backups are still on reiserfs on slower spinning rust) too, with the 
already reasonably small 256 GB SSDs partitioned up with all partitions 
50 GiB or under, so both full balances and scrubs only take a few (under 
10, under 1 on the smallest partitions) minutes, not the hours or even 
days they can take on single-partition multi-terabyte spinning rust.

Of course word of warning if it applies, that's why people with whole-
drive TB+ spinning-rust drives tend not to balance or scrub as often -- 
it takes too long.  Luckily the time is short enough here I don't worry 
about that.

Anyway, here's hoping you get a real answer on your specific errors, but 
until then, just know that some of the things btrfsck reports aren't 
actually errors at all, just things it doesn't understand yet.  So don't 
get too worried unless you either have other problems or one of the devs 
or other regulars explains and says you really SHOULD be worried about 
them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

