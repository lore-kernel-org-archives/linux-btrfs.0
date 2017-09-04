Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48924 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbdIDKfp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 06:35:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dooj7-000150-Fy
        for linux-btrfs@vger.kernel.org; Mon, 04 Sep 2017 12:35:33 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is autodefrag recommended?
Date: Mon, 4 Sep 2017 10:34:57 +0000 (UTC)
Message-ID: <pan$75cde$b9b6710$ed24172a$22c271cc@cox.net>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marat Khalili posted on Mon, 04 Sep 2017 12:31:54 +0300 as excerpted:

> Hello list,
> good time of the day,
> 
> More than once I see mentioned in this list that autodefrag option 
> solves problems with no apparent drawbacks, but it's not the default. 
> Can you recommend to just switch it on indiscriminately on all 
> installations?
> 
> I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's 
> Ubuntu that gives us this strange choice, no idea why it's not 4.9). 
> Only spinning rust here, no SSDs.

AFAIK autodefrag is recommended in general, but may not be for certain 
specific use-cases.

* Because the mechanism involves watching written files for fragmentation 
and scheduling areas that are too fragmented for later rewrite, if the 
filesystem is operating at near capacity already, adding the extra load 
of the defragmenting rewrites may actually reduce throughput and increase 
latency, at least short term.  (Longer term the additional fragmentation 
from /not/ using it will become a factor and reduce throughput even more.)

* Users just turning autodefrag on after not using it for an extended 
period, thus having an already highly fragmented filesystem, may well see 
a period of higher latencies and lower throughput until the system 
"catches up" and has defragged frequently written-to files.  (This is 
avoided with a policy of always having it on from the first time the 
filesystem is mounted, so it's on at initial filesystem population.)

* As with many issues on a COW-based filesystem such as btrfs, it's the 
frequently written into (aka internal-rewrite-pattern) files that are the 
biggest test case.  At-once written files that are never in-place 
rewritten (for file safety many editors make a temporary copy, fsync it, 
and then atomically replace the original with a rename, thus not being in-
place rewrites) don't tend to be an issue, unless the filesystem is 
already fragmented enough at write time that the file must be fragmented 
as it is initially written.

In general, this internal-rewrite-pattern is most commonly seen for 
database files and virtual machines, with systemd's journal files likely 
being the most common example of the former -- they're NOT the common 
append-only log file format that so-called "legacy" text-based log files 
tend to be.  Also extremely common are the browser database files used by 
both gecko and webkit based browsers (and browser-based apps such as 
thunderbird).

* Autodefrag works very well when these internal-rewrite-pattern files 
are relatively small, say a quarter GiB or less, but, again with near-
capacity throughput, not necessarily so well with larger databases or VM 
images of a GiB or larger.  (The quarter-gig to gig size is intermediate, 
not as often a problem and not a problem for many, but it can be for 
slower devices, while those on fast ssds may not see a problem until 
sizes reach multiple GiB.)

For larger internal-rewrite-pattern files, again, starting at a gig or so 
depending on device speed as well as rewrite activity, where 
fragmentation AND performance are issues, the NOCOW file attribute may be 
useful, tho there are side effects (losing btrfs checksumming and 
compression functionality, interaction with btrfs snapshotting forcing 
COW1, etc).

However, in general COW-based filesystems, including btrfs, are not going 
to perform well with this use-case, and those operating large DBs or VMs 
with performance considerations may find more traditional filesystems (or 
even operation on bare-device, bypassing the filesystem layer entirely) a 
better match for their needs, and I personally consider NOCOW an 
unacceptable compromise, losing many of the advantages that make btrfs so 
nice in general, so IMO it's then better to just use a different 
filesystem better suited to that use-case.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

