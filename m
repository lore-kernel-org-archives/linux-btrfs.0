Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60475 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcHKEvD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 00:51:03 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXhxM-0005o0-IX
	for linux-btrfs@vger.kernel.org; Thu, 11 Aug 2016 06:51:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Thu, 11 Aug 2016 04:50:53 +0000 (UTC)
Message-ID: <pan$631e4$8ace778e$d2bf1967$d5b4e8cc@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
	<pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
	<CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
	<CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave T posted on Wed, 10 Aug 2016 18:01:44 -0400 as excerpted:

> Does anyone have any thoughts about using dup mode for metadata on a
> Samsung 950 Pro (or any NVMe drive)?

The biggest problem with dup on ssds is that some ssds (particularly the 
ones with the sandforce controllers) do dedup, so you'd be having btrfs 
do dup while the filesystem dedups, to no effect except more cpu and 
device processing!

(The other argument for single on ssd that I've seen is that because the 
FTL ultimately places the data, and because both copies are written at 
the same time, there's a good chance that the FTL will write them into 
the same erase block and area, and a defect in one will likely be a 
defect in the other as well.  That may or may not be, I'm not qualified 
to say, but as explained below, I do choose to take my chances on that 
and thus do run dup on ssd.)

So as long as the SSD doesn't have a deduping FTL, I'd suggest dup for 
metadata on ssd does make sense.  Data... not so sure on, but certainly 
metadata, because one bad block of metadata can be many messed up files.

On my ssds here, which I know don't do dedup, most of my btrfs are raid1 
on the pair of ssds.  However, /boot is different since I can't really 
point grub at two different /boots, so I have my working /boot on one 
device, with the backup /boot on the other, and the grub on each one 
pointed at its respective /boot, so I can select working or backup /boot 
from the BIOS and it'll just work.  Since /boot is so small, it's mixed-
mode chunks, meaning data and metadata are mixed together and the 
redundancy mode applies to both at once instead of each separately.  And 
I chose dup, so it's dup for both data and metadata.

Works fine, dup for both data and metadata on non-deduping ssds, but of 
course that means data takes double the space since there's two copies of 
it, and that gets kind of expensive on ssd, if it's more than the 
fraction of a GiB that's /boot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

