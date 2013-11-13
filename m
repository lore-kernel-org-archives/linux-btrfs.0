Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab3KMNrA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 08:47:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgamW-0003EC-VA
	for linux-btrfs@vger.kernel.org; Wed, 13 Nov 2013 14:46:56 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 14:46:56 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Nov 2013 14:46:56 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs-progs: allow --init-extent-tree to work when
 extent tree is borked
Date: Wed, 13 Nov 2013 13:46:35 +0000 (UTC)
Message-ID: <pan$30f91$168ddb6$df0fbf$17f72f3f@cox.net>
References: <1382724100-5276-1-git-send-email-jbacik@fusionio.com>
	<l4ed62$8r3$1@ger.gmane.org> <20131025183134.GA4543@localhost.localdomain>
	<l4hifj$ni1$1@ger.gmane.org> <20131028151148.GB4543@localhost.localdomain>
	<l5eq5s$m8l$1@ger.gmane.org> <l5rn2s$m3p$1@ger.gmane.org>
	<l5vq48$2dh$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Wed, 13 Nov 2013 12:08:50 +0000 as excerpted:

>> Which comes to a request:
>> 
>> Can the options "-v" (for verbose) and "-s" (to continuously show
>> status) be added to btrfsck to give some indication of progress and
>> what is happening? The "-s" should report progress by whatever
>> appropriate real-time counts as done by such as "badblocks -s".
> 
> 
> OK... So I'll leave running for a little while longer before trying a
> mount.
> 
> Some sort of progress indicator would be rather useful... Is this going
> to run for a few hours more or might this need to run for weeks to
> complete? Any clues to look for?

Apropos to that request, I noticed when I updated btrfs-progs yesterday 
(reports Btrfs v0.20-rc1-591-gc652e4e), that there's a -v "verbose" flag 
for btrfs balance, now.  Here's a sample:

btrfs bal stat -v /home

Balance on '/home' is running
5 out of about 17 chunks balanced (6 considered),  71% left
Dumping filters: flags 0x7, state 0x1, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing

So with -v balance has progress indication at the chunk level now, and 
indicates which chunk classes, data/metadata/system are being balanced, 
as well.  Chunk level isn't terribly granular, but it's better than not 
having /any/ idea.

And btrfs scrub has a new -R "raw" flag.  With the new flag, and without:

btrfs scrub stat -R /home

scrub status for d3ae4dbd-874e-42ec-996b-47995fd0c45a
        scrub started at Wed Nov 13 06:16:57 2013, running for 13 seconds
        data_extents_scrubbed: 302779
        tree_extents_scrubbed: 202692
        data_bytes_scrubbed: 8803897344
        tree_bytes_scrubbed: 830226432
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 286620
        csum_discards: 481041
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 11743133696

btrfs scrub stat /home

scrub status for d3ae4dbd-874e-42ec-996b-47995fd0c45a
        scrub started at Wed Nov 13 06:16:57 2013, running for 22 seconds
        total bytes scrubbed: 15.13GiB with 0 errors

So scrub status now indicates byte-level (well, I suppose incremented per 
file or per node or some such) level.

(FWIW I'm on SSD, thus the 15+ gigs in 22 seconds.  I guess it'd be far 
slower on spinning rust.  I keep multiple relatively small independent 
btrfs partitions too; 100 gigs would be a rather big partition for me, so 
combined with the speed of ssd, checks/balances/scrubs finish in a couple 
minutes or less, not the days people often report on-list for multi-
tebibyte spinning rust, and I can conveniently run them on-demand for 
posting examples as I'm doing here, without tying up the system for days 
as a result! =:^)

As for btrfsck, it's actually available under the btrfs primary command 
as btrfs check, now.  But there's no btrfs check status comparable to 
btrfs balance status and btrfs scrub status, and no -v flag or similar.  
No real status updates either, beyond the fsck "stage" (checking ...) 
it's at:

btrfs check /dev/sda10

Checking filesystem on /dev/sda10
UUID: 7cb58c4f-ebd0-4c13-831b-ad0a964c51c6
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 2446191674 bytes used err is 0
total csum bytes: 11257148
total tree bytes: 524185600
total fs tree bytes: 481792000
total extent tree bytes: 27873280
btree space waste bytes: 152482568
file data blocks allocated: 11530465280
 referenced 12528828416
Btrfs v0.20-rc1-591-gc652e4e


So btrfs check needs updated with a status command and -v flag or similar 
too, but there's visible progress as balance and scrub have better status 
updating now, and btrfsck is at least available (as check) under the main 
btrfs command now. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

