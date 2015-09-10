Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42939 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbbIJA2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Sep 2015 20:28:36 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZZpj2-00086a-Lf
	for linux-btrfs@vger.kernel.org; Thu, 10 Sep 2015 02:28:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 02:28:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2015 02:28:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid6 + hot spare question
Date: Thu, 10 Sep 2015 00:28:20 +0000 (UTC)
Message-ID: <pan$3fecf$25489cad$6440daf2$1ed2047@cox.net>
References: <55EECD97.7090109@viidea.com>
	<20150908121258.GM23944@carfax.org.uk>
	<55F054BB.8090109@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Wed, 09 Sep 2015 17:48:11 +0200 as excerpted:

> Things can be a little more nuanced.
> 
> First off, I'm not even sure btrfs supports a hot spare currently. I
> haven't seen anything along those lines recently in the list - and don't
> recall anything along those lines before either. The current mention of
> it in the Project Ideas page on the wiki implies it hasn't been looked
> at yet.

Btrfs doesn't support hot spares... yet.  As mentioned it's in ideas and 
given the practicality, is likely to be implemented at some point, but 
given the reality of btrfs development speed, that's likely to be some 
years away.

The best that can be done is "warm spare", connected up but (presumably) 
spun down and not part of the raid, so it can (remotely if necessary) be 
brought online and added to the raid as needed.  That's certainly 
possible, but not as a btrfs specific feature, rather, as a general part 
of the Linux infrastructure.

> Also, depending on your experience with btrfs, some of the tasks
> involved in fixing up a missing/dead disk might be daunting.

Yes...

> On 2015-09-08 14:12, Hugo Mills wrote:
>> On Tue, Sep 08, 2015 at 01:59:19PM +0200, Peter Keše wrote:
>>> <snip>
>>> My assumption is that if one hard drive fails before the volume is
>>> more than 8TB full, I can just rebalance and resize the volume from 12
>>> TB back to 8 TB essentially going from 5-drive raid6 to 4-drive
>>> raid6).
>>>
>>> Can anyone confirm my assumption? Can I indeed rebalance from 5-drive
>>> raid6 to 4-drive raid6 if the volume is not too big?
>> 
>> Yes, you can, provided, as you say, the data is small enough to fit
>> into the reduced filesystem.
>>
> This is true - however, I'd be hesitant to build this up due to the
> current process not being very "smooth" depending on how unlucky you
> are.  [W]ill the filesystem still be read/write or read-only post-
> reboot? Will it "just work" with the only requirement being free space
> on the four working disks?

As long as there's four working devices and chunk-unallocated[1] space on 
them, yes, reducing to a 4-device raid6 should be fine.  What happens is 
that raid6 normally requires writing in at least fours[2], two-way data 
stripe and two parities.  If devices drop out and existing chunks with 
free space are no longer are available in fours, btrfs will leave them be 
and try to allocate additional chunks across remaining devices down to 
four[2].  If it can do so, writing can continue in the now reduced-stripe-
width raid6.  If not, there's a chance of going read-only, as it can no 
longer satisfy the raid6 requirements.[3]
 
> RAID6 is intended to be tolerant of two disk failures. In the case of
> there being a double failure and only 5 disks, the ease with which the
> user can balance/convert to a 3-disk raid5 is also important.

Again, see footnote [2] and [3] below.

---
[1] Btrfs allocates space in two stages, first in largish chunks to 
either data or metadata (chunk nominal size 1 GiB data, 256 MiB 
metadata), then actually using space from the chunk until it's gone and a 
new one needs allocated.  It's quite possible to have normal df, etc, 
report space left, but have it all locked up in pre-allocated chunks, 
typically data, and not have unallocated space left from which to 
allocate new chunks, typically metadata, when needed.  That used to be a 
big issue as btrfs could automatically allocate chunks but it took a 
balance to deallocate them, but now btrfs deallocates entirely empty 
chunks on its own, so the problem can still occur especially over time as 
existing chunks get fragmented and more chunks are only partially used, 
but it's not the /huge/ problem it once was, because at least entirely 
empty chunks are automatically deallocated and their space returned to 
the unallocated space pool to be chunk-allocated as necessary.

[2] While traditional raid6 requires minimum four devices, two-way-data-
stripe and two parity, and raid5 requires minimum three devices, two-way-
data-stripe with single parity, btrfs raid5, at least, degrades to single 
data, single parity, which ends up being in effect raid1, thus allowing a 
two-device "raid5".  I am not actually sure whether btrfs raid6 similarly 
allows degrading to single data, double parity, thus three devices, or 
not.  Of course, to do the full filesystem this way would require that 
the data and metadata fit on a single device, since the others are 
parity, but as a temporary fallback where existing chunks are simply left 
as is with data/metadata reconstructed from parity where necessary, only 
writing new data in the single-data/metadata mode, it can keep the 
filesystem writable.

[3] In actuality, given a device dropout situation, as long as the 
filesystem isn't unmounted, btrfs will continue to try to write to the 
failed/dropped device, writing to the other devices and buffering writes 
for the failed device in case it reappears, until memory is exhausted, at 
which point it presumably crashes.

I'm unsure about raid56 behavior on reboot/remount, but at least with 
raid1, dropping below the minimum required devices (2) to maintain the 
raid1 still allows mounting rw degraded... for one mount.  In that case 
the formerly raidN writes force allocation of new single chunks (or for 
the single device non-ssd case for metadata only, dup) and writing 
continues to them, allowing device delete/add/replace and rebalance as 
the admin considers appropriate.

The problem appears on the /second/ attempt to mount degraded writable, 
after there are existing single mode chunks on the filesystem, since 
btrfs sees the single chunks and thinks that there are single chunks on 
the missing device as well, and blocks writes in ordered to prevent 
further damage.  It's not smart enough to know that the only single 
chunks written are on still available devices.

Awareness of (the cause of) this problem is fairly recent, and there are 
patches that I think made it into 4.2 to allow writable degraded mount 
even with single chunks, but I'm not sure of the 4.2 status, and in any 
event, being new, the patches may not catch all corner cases.  
Additionally, while I /think/ the same situation and thus patches apply 
to raid56, I'm not entirely sure of that, so some testing (or 
verification from others who have tested in raid56 mode) would be needed 
if you want to be sure.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

