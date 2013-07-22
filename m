Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51263 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3GVFWP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 01:22:15 -0400
To: linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net, linuxhippy@gmail.com
Subject: Re: abysmal rm =?UTF-8?Q?performance=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 22 Jul 2013 12:22:11 +0700
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <827cf884b1a6e12db95beea6912d946b@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> You /really/ need to read up on the btrfs wiki.
> 
> The short answer is yes, btrfs does a LOT more metadata processing
> due to the checksumming it does by default.

According to the wiki, checksumming has barely any influence, so I
guess the above advice is not really helpful?

https://btrfs.wiki.kernel.org/index.php/Mount_options

	nodatasum
	(...)
	On most modern CPUs this option does not result in any
	reasonable performance improvement.


> Then there's the whole problem that you didn't provide nearly enough
> information about your test to tell what it was actually comparing.
> What sort of raid1, btrfs/md/dm/hardware/what, and if btrfs raid1, was
> that for both data and metadata or just one of the two and what was
> the other one if they weren't both raid1?  And if you were testing
> btrfs raid1, what did you do with the ext4 test to try to make it
> comparable since ext4 doesn't have a native raid1 mode, or was it on
> a single device?

ext4: using md RAID


btrfs:

Data, RAID1: total=1.73TB, used=1.36TB
System, RAID1: total=32.00MB, used=264.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=79.00GB, used=70.23GB


Quite high metadata usage here.


The filesystems on ext4 and btrfs are copies; there are >30 milion 
inodes on ext4; most of the files have multiple hardlinks.


So paraphrasing my question: is there anything to improve "rm"
performance with btrfs?

"nodatacow" might help a bit, but then, it disabled the compression,
which is a major drawback.


-- 
Tomasz Chmielewski
http://wpkg.org

