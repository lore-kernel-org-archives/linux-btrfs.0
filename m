Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob12.myregisteredsite.com ([209.17.115.50]:46248 "EHLO
	atl4mhob12.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010Ab3HSBVy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Aug 2013 21:21:54 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob12.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r7J1LqRa023442
	for <linux-btrfs@vger.kernel.org>; Sun, 18 Aug 2013 21:21:52 -0400
Message-ID: <52117334.4010306@chinilu.com>
Date: Sun, 18 Aug 2013 18:21:56 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: uncorrectable errors after btrfs replace
References: <S1753593Ab3HRQvp/20130818165145Z+301@vger.kernel.org> <52111C9D.3090704@pook.it> <73B6CA35-5279-44D6-A427-46985C3F554C@colorremedies.com> <52114C4A.6000003@pook.it> <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com>
In-Reply-To: <4DD5A25C-8210-4E5B-9BD3-49AAAB7CAAAC@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is just a comment from someone following all of this from the 
sidelines.

And that is that I see so much going on here with this procedure that is 
scares me.  Once a single operation reaches a certain degree of 
complexity I get really scared because all it takes is a single misstep 
and my data is gone.  And that happens so easily as complexity increases 
and confusion tends to set in.  In this particular situation, my 
solution would probably have been to create a new btrfs partition from 
scratch on the new drive and simply mount the source partition/drive ro 
and rsync the data across to the target partition/drive rather than 
trying to do the btrfs replace operation.  That way I could have 
verified the target drive before erasing the source drive and I would 
not have had to worry about partition sizes, encryption, etc.

That said, I am certainly thankful that this was backup data and not 
working data.  But I think it serves as a cautionary tale as to not 
assuming that something should be done just because it theoretically can 
be done.  I am not really familiar with btrfs replace but would imagine 
that it is intended for use more in a raid situation than in simply 
moving data from one drive to another.



On 08/18/2013 05:42 PM, Chris Murphy wrote:
> On Aug 18, 2013, at 4:35 PM, Stuart Pook <slp644161@pook.it> wrote:
>>> You first shrank a 2TB btrfs file system on dmcrypt device to 590GB.
>>> But then you didn't resize the dm device or the partition?
>> no, I had no need to resize the dm device or partition.
> OK well it's unusual to resize a file system and then not resize the containing block device. I don't know if Btrfs cares about this or not.
>
>> I ran a badblocks scan on the raw device (not the luks device) and didn't get any errors.
> badblocks will depend on the drive determining a persistent read failure with a sector, and timing out before the SCSI block layer times out. Since the linux SCSI driver time out is 30 seconds, and most consumer drive ECT is 120 seconds, the bus is reset before the drive has a chance to report a bad sector. So I think you're better off using smartctl -l long tests to find bad sectors on a disk.
>
> Further a smartctl -x may show SATA Phy Event Counters, which should have 0's or very low numbers and if not then that's also an indicator of hardware problems.
>
>
>> The data was written to the WD-Blue (640Gb) disk and then copied off it.  The only errors I saw concerned the WB-Blue.  If the errors were data corruption on writing or reading the WD-Blue then I would have thought that the checksums would have told me that there was something wrong.  btrfs didn't give me an IO error until I started to read the files when the data was on a final disk.
> How does Btrfs know there's been a failure during write if the hardware hasn't detected it? Btrfs doesn't re-read everything it just wrote to the drive to confirm it was written correctly. It assumes it was unless there's a hardware error. It wouldn't know this until a Btrfs scrub is done on the written drive.
>
> What I can't tell you is how Btrfs behaves and if it behaves correctly, when writing data to hardware having transient errors. I don't know what it does when the hardware reports the error, but presumably if the hardware doesn't report an error Btrfs can't do anything about that except on the next read or scrub.
>
>
>
>
>> Just to be clear. This is the series of btrfs replace I did:
>>
>> backups : HD204UI -> WD-Blue
>> /mnt : WD-Black -> HD204UI
>> backups : WD-Blue -> WD-Black
>>
>> I guess that my backups were corrupted was they were written to or read from the WD-Blue. Wouldn't the checksums have detected this problem before the data was written to the WD-Black?
> When you first encountered the btrfs reported csum errors, what operation was occurring?
>
>>> There's only so much software can do to overcome blatant hardware problems.
>> I was hoping to be informed of them
> Well you were informed of them in dmesg, by virtue of the controller having problems talking to a SATA rev 2 drive at rev 2 speed, with a negotiated fallback to rev 1 speed.
>>> But, it seems unlikely such a high percent of errors would go
>>> undetected to result in so many uncorrectable errors, so there may be
>>> user error here along with a bug.
>> I'm not sure how I could have done it better. Does "btrfs replace" check that the data is correctly written to the new disk before it is removed from the old disk?
> That's a valid question. Hopefully someone more knowledgable can answer what the expected error handling behavior is supposed to be.
>
>>   Should I have used the 2 disks to make a RAID-1 and then done a scrub before removing the old disk?
> Good question. Possibly it's best practices to use btrfs replace with an existing raid1, rather than using it as a way to move a single copy of data from one disk to another. I think you'd have been better off using btrfs send and receive for this operation.
>
> A full dmesg might also be enlightening even if it is really long. Just put it in its own email without comment. I think pasting it out of forum is less preferred.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

