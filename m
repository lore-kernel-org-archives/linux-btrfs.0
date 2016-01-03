Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63772 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbcACBhS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Jan 2016 20:37:18 -0500
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
To: Sanidhya Solanki <jpage.lkml@gmail.com>, David Sterba <dsterba@suse.cz>,
        clm@fb.com, jbacik@fb.com
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <1451341195.7094.0.camel@scientia.net> <20151228153801.6561feff@gmail.com>
 <1451352069.7094.3.camel@scientia.net> <20151228164333.2b8d8336@gmail.com>
 <1451360528.7094.7.camel@scientia.net> <20151228190336.59a3f440@gmail.com>
 <1451363188.7094.23.camel@scientia.net> <20151229180643.GD4227@twin.jikos.cz>
 <20160102065207.4eec760a@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56887B40.10105@gmx.com>
Date: Sun, 3 Jan 2016 09:37:04 +0800
MIME-Version: 1.0
In-Reply-To: <20160102065207.4eec760a@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/02/2016 07:52 PM, Sanidhya Solanki wrote:
> On Tue, 29 Dec 2015 19:06:44 +0100
> David Sterba <dsterba@suse.cz> wrote:
>
>> In theory this is possible with current on-disk data structures. The
>> stripe length is property of btrfs_chunk and changing it should be
>> possible the same way we do other raid transformations. The
>> implementation might be tricky at some places, but basically boils
>> down to the "read-" and "write-" stripe size. Reading chunks would
>> always respect the stored size, writing new data would use eg. the
>> superblock->stripesize or other value provided by the user.
>
> I was having misgivings about the conversion project, but after
> re-reading this part, I will try and get a patch in by Wednesday.
>
> I still have my reservations about the following two parts:
> - Checksumming: I have no experience with how the CRC implementation
>    would deal with the changed blocksizes. Would the checksum be
>    different just because the superblock size has been changed? This
>    would make confirming if the transformation was successful much more
>    difficult. Another way to deal with this would be ti read the data
>    instead and compare it directly, instead of using checksums.

Btrfs checksum are calculated in 3 different method:
1) Metadata: Per nodesize, stored in tree blocker header. (struct 
btrfs_header->csum)
2) Data: Per sectorsize, stored in csum tree.
3) Superblock: Per 4K (fixed), stored in its header (struct 
btrfs_super->csum)

I didn't the need to change any of them, as you are not changing any of 
the csum behavior.

Stripe size only affect how btrfs does IO, not the csum size.

>
> - Performance: Should it have a higher throughput by using larger data
>    sizes (which may reduce performance in scenarios such as databases and
>    video editing) or by having multiple transformations in parallel on
>    smaller data blocks. I am not sure if you can implement things such
>    as OpenMP in kernel space. Or spawn multiple kworkers in parallel to
>    deal with multiple streams of data.

IIRC, btrfs only need to pass bio to devices, and the 
parallel/merge/schedule are all done by kernel bio level.
So you don't really need to bother that much.

And since you are making the stripe size configurable, then user is 
responsible for any too large or too small stripe size setting.

Your only concern would be the default value, but IMHO current 64K 
stripe size is good enough as a default value.

Thanks,
Qu

>
> I am not too worried about dealing with crashes, as we can just
> implement something like a table that contains the addresses currently
> undergoing changes (which may further reduce throughput, but make it
> more space) or do it by using a serial transformation, which ensures a
> block was committed to storage before proceeding to the next
> transformation.
>
> Essentially a time vs. CPU usage vs. Memory usage trade-off.
> Please chime in with your thoughts, developers and administrators.
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
