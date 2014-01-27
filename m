Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57756 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753159AbaA0CZ3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jan 2014 21:25:29 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:55953 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W7btB-000JMg-LC
	for linux-btrfs@vger.kernel.org; Sun, 26 Jan 2014 19:25:29 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: bad block and io errors
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CANjusZfFXaNZcMew+6tWfKVdoKuVv+cSCWefvzCr0nMMJJk2sg@mail.gmail.com>
Date: Sun, 26 Jan 2014 19:25:29 -0700
Message-Id: <F8FFAAD5-4623-400D-B399-2C3FCED7E289@colorremedies.com>
References: <CANjusZfFXaNZcMew+6tWfKVdoKuVv+cSCWefvzCr0nMMJJk2sg@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please report the kernel and btrfs-progs versions, and the result from

# btrfs fi df /mnt/bt_store 

Bad blocks typically cause two error messages: read error, link reset. The first is an error from the drive itself and will include the affected LBAs. The second is the result of linux SCSI layer timeout being reached, it considers the drive unresponsive and then resets it.

For examples: http://lime-technology.com/wiki/index.php/The_Analysis_of_Drive_Issues#Drive_interface_issue_.234

Drive media issue #1
Drive interface issue #4

If you're getting link resets, the problems aren't being repaired by Btrfs because the link is being reset before the drive tells Btrfs exactly what the problem is and with what sector. So the problem simply gets worse as time goes on. 

If you're getting interface resets rather than explicit media errors, change the SCSI layer timeout. This is a kernel timeout, not a drive timeout, but it's set per physical block device. Do it for all drives. This will change the timeout from 30 seconds to 120 seconds:

echo 120 /sys/block/<dev>/device/timeout


> # btrfsck --repair /dev/sda


Please don't do this again until a developer (not me) suggests it. Always use this without --repair and report the results first.


> 1.  How do I repair, or drop block 35435896033280?

If it's a block with a mirror, the problem should be fixed automatically. If it's not being fixed automatically in normal use, and if that doesn't happen it's a bug.

> 
> 2.  How do I identify which drive out of 5 this block is on?

Good question, hopefully someone who knows will answer. I think these blocks are 4096 byte volume addresses, not physical drive LBAs. 

> 
> 3.  How do I detect which drive is causing the errno=-5 IO failure

[  819.115423] BTRFS error (device sdg1) in __btrfs_free_extent:5729:
errno=-5 IO failure

Looks like /dev/sdg, you can get the serial number using smartctl -a /dev/sdg and then match that to the label on the drive.

> 
> 4.  How do I identify what files I'm going to loose by this block problem?

Scrub, even if read only, will show files affected.


> deleting pointer to block 35435896033280
> owner ref check failed [35435896033280 4096]
> repair deleting extent record: key 35435896033280 168 4096
> ref mismatch on [35453976346624 4096] extent item 0, found 1
> btrfsck: extent-tree.c:2717: alloc_reserved_tree_block: Assertion
> `!(ret)' failed.
> Aborted

This looks like the block in question was deleted, line 3. I'm not sure what line 4 is suggesting but possibly the replacement failed.


Chris Murphy