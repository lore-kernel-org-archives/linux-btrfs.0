Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s20.hotmail.com ([65.55.116.31]:53117 "EHLO
	BLU004-OMC1S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbbJLQZ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 12:25:57 -0400
Message-ID: <BLU436-SMTP165112E5F4D118F381D47A4A9310@phx.gbl>
MIME-Version: 1.0
In-Reply-To: <20151012132136.GE27761@twin.jikos.cz>
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
	<20151012132136.GE27761@twin.jikos.cz>
Date: Mon, 12 Oct 2015 18:25:52 +0200
Subject: Re: BTRFS with 8TB SMR drives
From: Henk Slager <hslager@hotmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Warren,

from your dmesg I see:
Oct 10 07:42:36 cloud.warrenhughes.net kernel: scsi 0:0:1:0:
Direct-Access     ATA      ST8000AS0002-1NA AR13 PQ: 0 ANSI: 5
Oct 10 07:42:36 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdb]
15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)

Oct 11 23:57:56 cloud.warrenhughes.net kernel: scsi 0:0:1:0:
Direct-Access     ATA      ST8000AS0002-1NA AR13 PQ: 0 ANSI: 5
Oct 11 23:57:56 cloud.warrenhughes.net kernel: sd 0:0:1:0: [sdo]
15628053168 512-byte logical blocks: (8.00 TB/7.27 TiB)

and looking at this spec:
http://www.seagate.com/files/www-content/product-content/hdd-fam/seagate-archive-hdd/en-us/docs/archive-hdd-dS1834-3-1411us.pdf

it seems that it is a drive-managed SMR disk. I am not sure why David
assumes it is host-managed, maybe drive firmware/functionality can be
bypassed.

As far as I can see, the drive should not have a problem with btrfs as
such, but I read quite worrying stories w.r.t. raid. I think the write
characteristics of the balance operation, in combination with the
connection via the LSI controller, are not really compatible with
'archive' use case of the drive. 'Simple', 'relaxed' write operation
should be OK, but beyond that, it might fail. See also:
http://www.storagereview.com/seagate_archive_hdd_review_8tb

How much data is already on the drive? Is it an option to mount with
skip_balance and try to remove the device and then do some tests on it
in single independent mode?

/Henk


On Mon, Oct 12, 2015 at 3:21 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Oct 12, 2015 at 07:43:50AM +1300, Warren Hughes wrote:
>> Hi guys, just added a new Seagate Archive 8TB drive to my BTRFS volume
>> and I'm getting a tonne of errors when balancing or scrubbing.
>>
>> A short smartctl test reports fine, running a long one now. Will also
>> run seatools from a bootable DOS USB while at work today.
>>
>> Running latest firmware on my 9240-8i which explicitly supports this drive.
>>
>> I'm finding it very hard to tell if SMR drives are OK with BTRFS
>> currently - anyone chime in?
>
> I assume you have the host-managed SMR drives. This type needs tweaks to
> the operating system so the write patterns play well with the SMR
> constraints. Btrfs does not support that out of the box, but my
> colleague Hannes Reinecke managed to get it working with some minor
> changes to the allocator and disabled writing of superblock copies.
>
> For full support of SMR we'd have to change more than that, currently
> nothing prevents to write "backwards" in a given chunk that is allowed
> to be written only in the append way. So you can get mixed results when
> trying to use the SMR devices but I'd say it will mostly not work.
>
> But, btrfs has all the fundamental features in place, we'd have to make
> adjustments to follow the SMR constraints:
>
> * we can map the blockgroups to the SMR chunks (in some multiples)
> * remember the write pointers and do only append writes (easy with COW)
> * if the chunk is getting full, mark it read-only, rebalance the live
>   data somewhere else and reset the chunk and the pointer
>
> I have some notes at
> https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
