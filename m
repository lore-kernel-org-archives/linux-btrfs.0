Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:54212 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3HTOrQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 10:47:16 -0400
Received: from shiva (unknown [88.171.134.228])
	by smtp2-g21.free.fr (Postfix) with ESMTP id 574244B0149
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 16:47:07 +0200 (CEST)
In-Reply-To: <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com>
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Subject: Re: uncorrectable errors after btrfs replace
From: slp644161@pook.it
Date: Tue, 20 Aug 2013 16:46:59 +0200
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <434c716a-7687-4738-bb24-f4752ada1e3f@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Chris Murphy <lists@colorremedies.com> wrote:

>> I ran a badblocks scan on the raw device (not the luks device) and
>didn't get any errors.
>
>badblocks will depend on the drive determining a persistent read
>failure with a sector, and timing out before the SCSI block layer times
>out. Since the linux SCSI driver time out is 30 seconds, and most
>consumer drive ECT is 120 seconds, the bus is reset before the drive
>has a chance to report a bad sector. So I think you're better off using
>smartctl -l long tests to find bad sectors on a disk.

I have no reason to think that I have bad sectors on the disk. I just wanted to see if badblocks would lead to errors due to connection or cable problems. It didn't.

>How does Btrfs know there's been a failure during write if the hardware
>hasn't detected it? Btrfs doesn't re-read everything it just wrote to
>the drive to confirm it was written correctly. It assumes it was unless
>there's a hardware error. It wouldn't know this until a Btrfs scrub is
>done on the written drive. 

I was hoping that btrfs would have checked that the data was correctly copied to the new disk before it removed it from the original. This is what would have saved my filesystem.

>What I can't tell you is how Btrfs behaves and if it behaves correctly,
>when writing data to hardware having transient errors. I don't know
>what it does when the hardware reports the error, but presumably if the
>hardware doesn't report an error Btrfs can't do anything about that
>except on the next read or scrub.

But btrfs did read the data from the WD-blue because it copied it to the WD-black. btrfs copied rubbish onto the WD-black so if it had checked the checksums as it read from the WD-blue it would have seen that things were bad. This would already have been too late for my filesystem but it would have been good to know then rather than just get errors when I tried to read the files on the filesystem.

>> Just to be clear. This is the series of btrfs replace I did:
>> 
>> backups : HD204UI -> WD-Blue
>> /mnt : WD-Black -> HD204UI
>> backups : WD-Blue -> WD-Black
>> 
>> I guess that my backups were corrupted was they were written to or
>read from the WD-Blue. Wouldn't the checksums have detected this
>problem before the data was written to the WD-Black?
>
>When you first encountered the btrfs reported csum errors, what
>operation was occurring?

When I started to read and write my backups after they have been copied to the WD-black

>>> There's only so much software can do to overcome blatant hardware
>problems.
>> 
>> I was hoping to be informed of them
>
>Well you were informed of them in dmesg, by virtue of the controller
>having problems talking to a SATA rev 2 drive at rev 2 speed, with a
>negotiated fallback to rev 1 speed.

I wanted btrfs to reread the new disk before removing the old disk from the filesystem. I also do not understand why the errors, which were going into dmesg, were not received by btrfs so that it could abort the replace.

>> Does "btrfs replace"
>check that the data is correctly written to the new disk before it is
>removed from the old disk?
>
>That's a valid question. Hopefully someone more knowledgable can answer
>what the expected error handling behavior is supposed to be.

It would be good if it did!

>>  Should I have used the 2 disks to make a RAID-1 and then done a
>scrub before removing the old disk?
>
>Good question. Possibly it's best practices to use btrfs replace with
>an existing raid1, rather than using it as a way to move a single copy
>of data from one disk to another. I think you'd have been better off
>using btrfs send and receive for this operation.

But using send and receive would have lead to downtime.

>A full dmesg might also be enlightening even if it is really long. Just
>put it in its own email without comment. 

As soon as I get back home ...

Stuart Pook, http://www.pook.it
