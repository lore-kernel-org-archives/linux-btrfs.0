Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60919 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751038AbdFUIp0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 04:45:26 -0400
Subject: Re: Exactly what is wrong with RAID5/6
To: <waxhead@dirtcellar.net>, <linux-btrfs@vger.kernel.org>
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
Date: Wed, 21 Jun 2017 16:45:09 +0800
MIME-Version: 1.0
In-Reply-To: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/21/2017 06:57 AM, waxhead wrote:
> I am trying to piece together the actual status of the RAID5/6 bit of 
> BTRFS.
> The wiki refer to kernel 3.19 which was released in February 2015 so I 
> assume that the information there is a tad outdated (the last update on 
> the wiki page was July 2016)
> https://btrfs.wiki.kernel.org/index.php/RAID56
> 
> Now there are four problems listed
> 
> 1. Parity may be inconsistent after a crash (the "write hole")
> Is this still true, if yes - would not this apply for RAID1 / RAID10 as 
> well? How was it solved there , and why can't that be done for RAID5/6

Unlike pure stripe method, one fully functional RAID5/6 should be 
written in full stripe behavior, which is made up by N data stripes and 
correct P/Q.

Given one example to show how write sequence affects the usability of 
RAID5/6.

Existing full stripe:
X = Used space (Extent allocated)
O = Unused space
Data 1   |XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|

When some new extent is allocated to data 1 stripe, if we write
data directly into that region, and crashed.
The result will be:

Data 1   |XXXXXX|XXXXXX|OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
Data 2   |OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO|
Parity   |WWWWWW|ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ|

Parity stripe is not updated, although it's fine since data is still 
correct, this reduces the usability, as in this case, if we lost device 
containing data 2 stripe, we can't recover correct data of data 2.

Although personally I don't think it's a big problem yet.

Someone has idea to modify extent allocator to handle it, but anyway I 
don't consider it's worthy.

> 
> 2. Parity data is not checksummed
> Why is this a problem? Does it have to do with the design of BTRFS somehow?
> Parity is after all just data, BTRFS does checksum data so what is the 
> reason this is a problem?

Because that's one solution to solve above problem.

And no, parity is not data.

Parity/mirror/stripe is done in btrfs chunk level, and represents a 
nice, easy to understand linear logical space for higher level.

For example:
If in the btrfs logical space, 0~1G is mapped to a RAID5 chunk with 3 
devices, higher level only needs to tell btrfs chunk layer how many 
bytes it wants to read and where the read starts.

If one devices is missing, then try to rebuild the data using parity so 
that higher layer don't need to care what the profile is or if there is 
parity or not.

So parity can't be addressed from btrfs logical space, that's to say no 
possible position to record csum for it in current btrfs design.



> 
> 3. No support for discard? (possibly -- needs confirmation with cmason)
> Does this matter that much really?, is there an update on this?

Not familiar with this though.

> 
> 4. The algorithm uses as many devices as are available: No support for a 
> fixed-width stripe.
> What is the plan for this one? There was patches on the mailing list by 
> the SnapRAID author to support up to 6 parity devices. Will the (re?) 
> resign of btrfs raid5/6 support a scheme that allows for multiple parity 
> devices?

Considering current maintainers seems to be focusing on bug fixes, not 
new features, I'm not confident with such new feature.

> 
> I do have a few other questions as well...
> 
> 5. BTRFS does still (kernel 4.9) not seem to use the device ID to 
> communicate with devices.

Btrfs is always using device ID to build up its device mapping.
And for any multi-device implementation (LVM,mdadam) it's never a good 
idea to use device path.

> 
> If you on a multi device filesystem yank out a device, for example 
> /dev/sdg and it reappear as /dev/sdx for example btrfs will still 
> happily try to write to /dev/sdg even if btrfs fi sh /mnt shows the 
> correct device ID. What is the status for getting BTRFS to properly 
> understand that a device is missing?

It's btrfs that doesn't support runtime switch from missing device to 
re-appeared device.

Most device missing detection is done at btrfs device scan time.
Runtime detect is not that perfect, but Anand Jain is introducing some 
nice infrastructure as basis to enhance it.

> 
> 6. RAID1 needs to be able to make two copies always. E.g. if you have 
> three disks you can loose one and it should still work. What about 
> RAID10 ? If you have for example 6 disk RAID10 array, loose one disk and 
> reboots (due to #5 above). Will RAID10 recognize that the array now is a 
> 5 disk array and stripe+mirror over 2 disks (or possibly 2.5 disks?) 
> instead of 3? In other words, will it work as long as it can create a 
> RAID10 profile that requires a minimum of four disks?

At least, after reboot, btrfs still knows it's a fs on 6 disks, although 
lost one, it will still create new chunk using all 6 disks.

Thanks,
Qu

> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


