Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:47566
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbcCRSQx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 14:16:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2IIGo2x011568
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 18:16:51 GMT
Subject: Re: Snapshots slowing system
To: linux-btrfs@vger.kernel.org
References: <201603142303.u2EN3qo3011695@phoenix.vfire>
 <pan$a0d0a$9f23433a$f19e4b84$b275dc3f@cox.net>
 <56E88CB2.6020300@petezilla.co.uk> <56E945E9.1050005@gmail.com>
 <56EB1CC7.2000602@petezilla.co.uk>
 <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
From: Pete <pete@petezilla.co.uk>
Message-ID: <56EC4612.4030206@petezilla.co.uk>
Date: Fri, 18 Mar 2016 18:16:50 +0000
MIME-Version: 1.0
In-Reply-To: <pan$24d34$c6dcbaed$b9940b06$c8b4f058@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/18/2016 09:17 AM, Duncan wrote:

> So bottom line regarding that smartctl output, yeah, a new device is 
> probably a very good idea at this point.  Those smart attributes indicate 
> either head slop or spin wobble, and some errors and command timeouts and 
> retries, which could well account for your huge slowdowns.  Fortunately, 
> it's mostly backup, so you have your working copy, but if I'm not mixing 
> up my threads, you have some media files, etc, on a different partition 
> on it as well, and if you don't have backups elsewhere, getting them onto 
> something else ASAP is a very good idea, because this drive does look to 
> be struggling, and tho it could continue working in a low usage scenario 
> for some time yet, it could also fail rather quickly, as well.
> 

This disk is one of a pair or raid1 disks which hold the data on my
system.  As you summised the machine is generally on 24x7 as it can just
get on with backups and some data grabbing and crunching on its own.

This is a set up of 2 x 3TB disks completely dedicated to btrfs.  I'm
wondering if the failing one is the older one wrenched out of a USB
enclosure as it was cheaper than a desktop one or whether it was the
desktop drive?  Still academic.  I have 1.37TB unallocated, 720GB free
estimated.  I'm therefore wondering whether I opt for the cheapest
reasonable desktop drive, a NAS drive advertised for 24x7 or whether I
pick a wallet frightening 'enterprise drive' as it might be twice as
much as the standard desktop but will give me less grief in the long
term.  Probably one for comp.os.linux.hardware.


>> Confused.  I'm getting one SSD which I intend to use raid0.  Seems to me
>> to make no sense to split it in two and put both sides of raid1 on one
>> disk and I reasonably think that you are not suggesting that.  Or are
>> you assuming that I'm getting two disks?  Or are you saying that buying
>> a second SSD disk is strongly advised?  (bearing in mind that it looks
>> like I might need another hdd if the smart field above is worth worrying
>> about).
> 
> Well, raid0 normally requires two devices.  So either you mean single 
> mode on a single device, or you're combining it with another device (or 
> more than one more) to do raid0.

Sorry, I confused raid0 with single.  The _lone_ system disk contains
the root partition, it is btrfs in single mode.



> So btrfs raid1 has data integrity and repair features that aren't 
> available on normal raid1, and thus is highly recommended.
> 
> But, raid1 /does/ mean two copies of both data and metadata (assuming of 
> course you make them both raid1, as I did), and if you simply don't have 
> room to do it that way, you don't have room, highly recommended tho it 
> may be.

This looks like a strong recommendation to get a second SSD for the root
partition and go raid1.  Are SSDs more flakey that hdd or are you just a
strong believer in the integrity of raid1?


> 
> Tho raid1 shouldn't be considered the same as a backup, because it's 
> not.  In particular, while you do have reasonable protection against 

<snip>

Backup nightly to an external usb hdd with ext4 via rsync.  Permanently
connected.  Also periodically (when I remember) backup via rsync to
another hdd formatted btrfs, single mode, with snapshots.


Given the discussions here maybe a couple of extra copies of the very
important stuff would not go amiss.

