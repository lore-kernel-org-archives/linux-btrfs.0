Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34321 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbbJLSHt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 14:07:49 -0400
Received: by vkat63 with SMTP id t63so90673436vka.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 11:07:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
	<20151012132136.GE27761@twin.jikos.cz>
	<BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
Date: Tue, 13 Oct 2015 07:07:48 +1300
Message-ID: <CA+wwUFCw8EiAuLKx+5y1sY5km_o5AdN7-k=dLXkUc5PvD9POUA@mail.gmail.com>
Subject: Re: BTRFS with 8TB SMR drives
From: Warren Hughes <wsh@warrenhughes.net>
To: Henk Slager <hslager@hotmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, correct its drive managed SMR.

I have been following this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=93581 for a while

As a test I compiled/installed 4.3.0-rc4 as it looks like they
reverted some kernel patches that (negatively) affect SMR.

I ran a complete balance overnight and not a single error on the 8TB
SMR drive. I have a number of corrected and medium errors on one of my
3TB WD Red drives which appear to be genuine errors. Thankfully my
BTRFS is RAID1.

I'll remove and replace that 3TB drive and run a complete scrub - but
for now it looks like I was a victim of the above bug entry.

On 13 October 2015 at 05:25, Henk Slager <hslager@hotmail.com> wrote:
> Hi Warren,
>
> from your dmesg I see:
> Oct 10 07:42:36 cloud.warrenhughes.net kernel: scsi 0:0:1:0:
> Direct-Access     ATA      ST8000AS0002-1NA AR13 PQ: 0 ANSI: 5
> Oct 10 07:42:36 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
> 15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)
>
> Oct 11 23:57:56 cloud.warrenhughes.net kernel: scsi 0:0:1:0:
> Direct-Access     ATA      ST8000AS0002-1NA AR13 PQ: 0 ANSI: 5
> Oct 11 23:57:56 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdo]
> 15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)
>
> and looking at this spec:
> http://www.seagate.com/files/www-content/product-content/hdd-fam/seagate-archive-hdd/en-us/docs/archive-hdd-dS1834-3-1411us.pdf
>
> it seems that it is a drive-managed SMR disk. I am not sure why David
> assumes it is host-managed, maybe drive firmware/functionality can be
> bypassed.
>
> As far as I can see, the drive should not have a problem with btrfs as
> such, but I read quite worrying stories w.r.t. raid. I think the write
> characteristics of the balance operation, in combination with the
> connection via the LSI controller, are not really compatible with
> 'archive' use case of the drive. 'Simple', 'relaxed' write operation
> should be OK, but beyond that, it might fail. See also:
> http://www.storagereview.com/seagate_archive_hdd_review_8tb
>
> How much data is already on the drive? Is it an option to mount with
> skip_balance and try to remove the device and then do some tests on it
> in single independent mode?
>
> /Henk
>
>
> On Mon, Oct 12, 2015 at 3:21 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Mon, Oct 12, 2015 at 07:43:50AM +1300, Warren Hughes wrote:
>>> Hi guys, just added a new Seagate Archive 8TB drive to my BTRFS volume
>>> and I'm getting a tonne of errors when balancing or scrubbing.
>>>
>>> A short smartctl test reports fine, running a long one now. Will also
>>> run seatools from a bootable DOS USB while at work today.
>>>
>>> Running latest firmware on my 9240-8i which explicitly supports this drive.
>>>
>>> I'm finding it very hard to tell if SMR drives are OK with BTRFS
>>> currently - anyone chime in?
>>
>> I assume you have the host-managed SMR drives. This type needs tweaks to
>> the operating system so the write patterns play well with the SMR
>> constraints. Btrfs does not support that out of the box, but my
>> colleague Hannes Reinecke managed to get it working with some minor
>> changes to the allocator and disabled writing of superblock copies.
>>
>> For full support of SMR we'd have to change more than that, currently
>> nothing prevents to write "backwards" in a given chunk that is allowed
>> to be written only in the append way. So you can get mixed results when
>> trying to use the SMR devices but I'd say it will mostly not work.
>>
>> But, btrfs has all the fundamental features in place, we'd have to make
>> adjustments to follow the SMR constraints:
>>
>> * we can map the blockgroups to the SMR chunks (in some multiples)
>> * remember the write pointers and do only append writes (easy with COW)
>> * if the chunk is getting full, mark it read-only, rebalance the live
>>   data somewhere else and reset the chunk and the pointer
>>
>> I have some notes at
>> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Warren Hughes
+64 21 633324
IM: gtalk + msn: this email address, skype: akawsh
