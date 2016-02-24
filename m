Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51653 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbcBXAUK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 19:20:10 -0500
Date: Tue, 23 Feb 2016 16:19:44 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20160224001944.GX22487@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$84c48$1f5c952c$5c23be23$5799c3a@cox.net>
 <pan$1ce2f$38765775$42544d39$1c9fd0a5@cox.net>
Subject: Re: Documentation for BTRFS error (device dev): bdev /dev/xx errs:
 wr 22, rd 0, flush 0, corrupt 0, gen 0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 11:22:47PM +0000, Duncan wrote:
> Forgot to mention, tho you're probably already considering it, if this is 
> the same raid5-backed btrfs you were complaining about being slow in the 
> other thread, 

No, that's another one :)
This one was remade from scratch after the filesystem on it got
corrupted.
5 x 4TB swraid5      64GB SSD
          bcache
	  dmcrypt
	  btrfs

Smart is 100% for all 5 drives, and they passed an extensive test before
I built the new raid and filesystem on them.

> and considering redoing with bcache to an ssd added, as 
> seems very likely, if it /is/ actually storage device or bus errors, that 
> could be one reason the previous one was getting so slow...  Maybe it 
> wasn't btrfs after all.

Good thinking, although in this case, it's a different filesystem.

This filesystem is however on a Sata port multiplier with a 2 meter
cable to an external disk array. 
As a result, bandwidth to it is going to be slow-ish, and the long cable
could be adding I/O errors.

On Tue, Feb 23, 2016 at 11:17:06PM +0000, Duncan wrote:
> I believe all formal documentation of what the error counters actually 
> mean is developer-level -- "Trust the Source, Luke."
 
Haha, I know that one :)
Although to be fair I was more offering for someone to tell me what
they're supposed to mean, and me updating the wiki to capture that info.

> Yet another point supporting the "btrfs is still stabilizing, not yet 
> fully stable" position, I suppose, as it could definitely be argued that 
> those counters and their visibility, including display in the kernel log 
> at mount time, are definitely intended to be consumed at the admin-user 
> level, and that it follows that they should be documented at the admin-
> user level before the filesystem can properly be defined as fully stable.
 
Yes :) and I'm happy to help make this reality in the wiki at least.
 
> Write error counter increments should be accompanied by kernel log events 
> telling you more -- what level of the device stack is returning the 
> errors that propagate up to the filesystem level, for instance.  Expected 
> would be either bus level timeouts and resets, or storage device errors.  
 
I agree, and I get 0 such errors here, which is why it's weird.

> If it's storage device errors, SMART data should show increasing raw 
> value relocated sectors or the like (smartctl -A).  If it's bus errors, 

Correct, and they are all at 0.

> it could be bad cabling (bad connections or bad shielding, or using 
> SATA-150 certified cables for SATA-600 or some such), or, as I saw on an 

Cabling is indeed a likely culprit, I'm just surprised that if it's the
case, the sata layer is showing me nothing (I'm doing tail -f
/var/log/kern.log and usually I'd see sata or PMP errors there)

> old and failing mobo (when I pulled it there were bulging and some 
> exploded capacitors) a few years ago, failing filter-capacitors on the 
> mobo signalling paths.  Bad power, including the possibility of an 
> overloaded UPS that hit one guy I know, is notorious for both this sort 
> of issue and memory problems, as well.

All true, but wouldn't all of these show up as actual disk errors by the
underlying driver involved too?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
