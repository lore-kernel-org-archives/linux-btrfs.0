Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53043 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdITB61 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 21:58:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1duUHH-0000vm-Py
        for linux-btrfs@vger.kernel.org; Wed, 20 Sep 2017 03:58:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: SSD caching an existing btrfs raid1
Date: Wed, 20 Sep 2017 01:58:08 +0000 (UTC)
Message-ID: <pan$4e8bf$4c967ec4$cc9cf5d3$412f118d@cox.net>
References: <4ed24e33-09e1-c03a-912c-9d1b2bbdc835@gmail.com>
        <2a208f7c-a140-3ac6-12c6-2e953f3f96ec@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 19 Sep 2017 11:47:24 -0400 as
excerpted:

> A better option if you can afford to remove a single device from that
> array temporarily is to use bcache.  Bcache has one specific advantage
> in this case, multiple backend devices can share the same cache device.
> This means you don't have to carve out dedicated cache space for each
> disk on the SSD and leave some unused space so that you can add new
> devices if needed.  The downside is that you can't convert each device
> in-place, but because you're using BTRFS, you can still convert the
> volume as a whole in-place.  The procedure for doing so looks like this:
> 
> 1. Format the SSD as a bcache cache.
> 2. Use `btrfs device delete` to remove a single hard drive from the
> array.
> 3. Set up the drive you just removed as a bcache backing device bound to
> the cache you created in step 1.
> 4. Add the new bcache device to the array.
> 5. Repeat from step 2 until the whole array is converted.
> 
> A similar procedure can actually be used to do almost any underlying
> storage conversion (for example, switching to whole disk encryption, or
> adding LVM underneath BTRFS) provided all your data can fit on one less
> disk than you have.

... And you're not already at the minimum operational for that btrfs 
array type.

For instance, I have lots of btrfs raid1s, two devices each.  I'd have 
trouble with the above, because I can't simply remove a device, despite 
all the data and metadata fitting on a single device.

I'd have three options that /would/ work, however.

1) If I was willing to risk having only a single checksummed copy of 
everything for the time it would take to process, I could do a btrfs 
balance convert from raid1 to single mode, then do a btrfs device remove, 
and go from there, converting back to raid1 after I was done.  Of course 
if anything goes wrong with that single copy and something fails 
checksum, I've potentially lost whatever failed the checksum unless I 
have it on backup, so converting to single mode is risky.

2) If the data and metadata will fit on /half/ of a single device, then I 
could convert to dup mode (since btrfs now allows dup data chunks) taking 
double the space on that single device, but keeping two checksummed 
copies of everything due to the dup mode, thus avoiding the risk of #1.

3) If #2 won't work due to size and I was unwilling to risk #1, I'd have 
to add a device (making it the first one converted to bcache before the 
add) before I could remove one of the others, in ordered to allow me to 
keep the checksummed redundancy of raid1 for the entire procedure.  After 
the bcache conversion and addition of the new device, and the removal, 
conversion, and readdition of one of the two existing devices, I could 
simply remove the third, giving me back my spare device, but I'd have to 
have and use it for the process.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

