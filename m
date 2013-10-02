Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:28746 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752562Ab3JBDua convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 23:50:30 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131002031355.GA11675@pyropus.ca>
Date: Tue, 1 Oct 2013 21:50:25 -0600
Cc: btrfs list <linux-btrfs@vger.kernel.org>
Message-Id: <DFC049CD-209E-49CB-91A3-05BB2F766BC8@colorremedies.com>
References: <20131001211255.GA5946@pyropus.ca> <13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com> <20131001234655.GA7937@pyropus.ca> <441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com> <20131002031355.GA11675@pyropus.ca>
To: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 1, 2013, at 9:13 PM, Charles Cazabon <charlesc-lists-btrfs@pyropus.ca> wrote:
> 
> Ah, I'm not looking to repair the files -- I can recopy the files easily
> enough, and rsync will pick up any files whose contents have been corrupted.
> I'd like to get the filesystem fixed, though.  i.e., even deleting the
> affected files would be fine.

If you run a scrub, dmesg should contain the path for affected files which you can then delete. If it's just a checksum problem with files, the file system doesn't need fixing. I'd wait until the raid is finished syncing.

>  This is a new filesystem to replace my existing
> (full) backups filesystem.  The existing backups one is ext4 but this new one
> is too big for mkfs.ext4 to handle, so btrfs it is.  I wasn't expecting
> problems as I've been running btrfs for other purposes for years.

It's still experimental. I'd expect almost anything.


> 
> Am I misunderstanding something here?  It seems to me like btrfsck is telling
> me there's problems with the filesystem itself when it continues to report
> these checksum errors even after a `btrfsck --repair`.

Well I haven't seen the entire btrfsck or the entire dmesg so like I said I'm sorta guessing it's just a file problem, but maybe you've stumbled on something else.

> 
> It's a brand new array.  The initial sync is actually still going on (about
> half complete; it'll take several days to initialize an array this size on
> this hardware).

OK maybe someone else can comment if this is expected to work, maybe on linux-raid even. But now you tell us this? You didn't think it might be important to mention that you've got a raid initially syncing, that you've formatted btrfs, copied files over, and at some point you got a kerne lock up, and then once restarted you ran a btrfsck?

I would expect problems with any file system, with a system that locks up while the raid is still syncing.

> So in short, the underlying array is clean.

Well except you've got either file system corruption, or corrupt files.

> 
>> What is the 'smartctl -l scterc /dev/sdX' result for one of the drives?
> 
>  Warning: device does not support SCT Error Recovery Control command

These drives aren't well suited for RAID of any kind. Hopefully, at least, you will change the scsi layer time out for each drive using 
echo 121 >/sys/block/sdX/device/timeout

That may not even be long enough, but without more information about what the ERC timeout of the drive is, which the manufacturer might have in the exhaustive version of their spec book, it's a guess. Consumer drives try to recover for up to a couple minutes. If the scsi layer resets in 30 seconds (the default) then sector problems are never fixed because the drive never reports the read error back to the kernel. And md won't write over the bad sector with reconstructed data. So you get an accumulation of bad sectors, rather than them being taken care of normally.

Your application layer might get frustrated, or worse, with up to 2 minute delays in the storage stack.

> 
>> This sounds to me like it could be a bit flip, and btrfs is catching it but
>> doesn't have a 2nd copy of the data. Just a guess.
> 
> If one of the disks flipped a bit, it would be caught at the md RAID-6 level,
> no?

No. In normal operation the parity is never consulted, so it would have no idea if there's a flipped bit. The hardware ought to catch it, but we know that isn't always true.



Chris Murphy