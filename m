Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40535 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299AbaLMNxY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Dec 2014 08:53:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 13 Dec 2014 14:53:18 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Robert White <rwhite@pobox.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <548C0942.6020304@pobox.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
 <548B5FD6.5080306@pobox.com>
 <ce7dba343916e4262a92071af863d014@admin.virtall.com>
 <548B6D58.6080804@pobox.com>
 <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com>
 <548B7329.80208@pobox.com>
 <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com>
 <548C0942.6020304@pobox.com>
Message-ID: <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-13 10:39, Robert White wrote:

> Might I ask why you are running balance? After a persistent error I'd
> understand going straight to scrub, but balance is usually for
> transformation or to redistribute things after atypical use.

There were several reasons for running balance on this system:

1) I was getting "no space left", even though there were hundreds of GBs 
left. Not sure if this still applies to the current kernels (3.18 and 
later) though, but it was certainly the problem in the past.

2) The system was regularly freezing, I'd say once a week was a norm. 
Sometimes I was getting btrfs traces logged in syslog.
After a few freezes the fs was getting corrupted to different degree. At 
some point, it was so bad that it was only possible to use it read only. 
So I had to get the data off, reformat, copy back... It would start 
crashing after a few weeks of usage.

My usage case is quite simple:

- skinny extents, extended inode refs
- mount compress-force=zlib
- rsync many remote data sources (-a -H --inplace --partial) + snapshot
- around 500 snapshots in total, from 20 or so subvolumes

Especially rsync's --inplace option combined with many snapshots and 
large fragmentation was deadly for btrfs - I was seeing system freezes 
right when rsyncing a highly fragmented, large file.

Then, running balance on the "corrupted" filesystem was more an exercise 
(if scrub passes fine, I would expect balance to pass as well). Some 
BUGs it was causing was sometimes fixed in newer kernels, sometimes not 
(btrfsck was not really usable a few months back).

3) I had different luck with recovering btrfs after a failed drive (in 
RAID-1). Sometimes it worked as expected, sometimes, the fs was getting 
broken so much I had to rsync data off it and format from scratch (where 
mdraid would kick the drive after getting write errors - it's not the 
case with btrfs, and weird things can happen).
Sometimes, running "btrfs device delete missing" (it's balance in 
principle, I think) would take weeks, during which a second drive could 
easily die.
Again, running balance would be more exercise there, to see if the newer 
kernel still crashes.


> An entire generation of folks have grown used to defraging windows
> boxes and all, but if you've already got an array that is going to
> take "many days" to balance what benefit do you actually expect to
> receive?

For me - it's a good test to see if btrfs is finally getting stable 
(some cases explained above).


> Defrag -- used for "I think I'm getting a lot of unnecessary head seek
> in this application, these files need to be brought into closer
> order".

Fragmentation was an issue for btrfs, at least a few kernels back (as 
explained above, with rsync's --inplace).
However, I'm not running autodefrag anywhere - not sure how it affects 
snapshots.


> Scrub -- used for defensive checking a-la checkdisk. "I suspect that
> after that unexpected power outage something may be a little off", or
> alternately "I think my disks are giving me bitrot, I better check".

For me, it was passing fine, where balance was crashing the kernel.


Again, my main rationale for running balance is to see if btrfs is 
behaving stable. While I have systems with btrfs which are running fine 
for months, I also have ones which will crash after 1-2 weeks (once the 
system grows in size / complexity).

So hopefully, btrfsck had fixed that fs - once it is running stable for 
a week or two, I might be brave to re-enable btrfs quotas (was another 
system freezer, at least a few kernels back).


-- 
Tomasz Chmielewski
http://www.sslrack.com

