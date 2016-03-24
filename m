Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35400 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbcCXDoK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 23:44:10 -0400
Received: by mail-io0-f171.google.com with SMTP id v187so43992528ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 20:44:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F3559C.3030201@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
	<CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
	<56F2EA25.4070004@gmail.com>
	<CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
	<56F349F0.5070202@cn.fujitsu.com>
	<56F34D5F.4080407@gmail.com>
	<56F35216.1060103@cn.fujitsu.com>
	<56F3559C.3030201@gmail.com>
Date: Wed, 23 Mar 2016 21:44:09 -0600
Message-ID: <CAJCQCtRpsjC5LOczhb9_yjvFojE7oQUN-EQY9rVBm3pmBEnaPw@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Chris Murphy <lists@colorremedies.com>
To: Brad Templeton <bradtem@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 8:49 PM, Brad Templeton <bradtem@gmail.com> wrote:
> On 03/23/2016 07:33 PM, Qu Wenruo wrote:
>>
>> No, balance is not working like that.
>> Although most user consider balance is moving data, which is partly right.
>> The fact is, balance is, copy-and-delete. And it needs spare space.
>>
>> Means you must have enough space for the extents you are balancing, then
>> btrfs will copy them, update reference, and then delete old data (with
>> its block group).
>>
>> So for balancing data in already filled device, btrfs needs to find
>> space for them first.
>> Which will need 2 devices with unallocated space for RAID1.
>>
>> And in you case, you only have 1 devices with unallocated space, so no
>> space to balance.
>
> Ah.  I would class this as a bug, or at least a non-optimal design.  If
> I understand, you say it tries to move both of the matching chunks to
> new homes.  This makes no sense if there are 3 drives because it is
> assured that one chunk is staying on the same drive.   Even with 4 or
> more drives, where this could make sense, in fact it would still be wise
> to attempt to move only one of the pair of chunks, and then move the
> other if that is also a good idea.

In a separate thread, it's observed that balance code is getting
complicated and it's probably important that it not be too smart for
itself.

The thing to understand is that chunks are a contiguous range of
physical sectors. What's really being copied are extents in those
chunks. And the balance not only rewrites extents but it tries to
collect them together to efficiently use the chunk space. The Btrfs
chunk isn't like an md chunk.

>
>
>>
>>
>>>
>>> My next plan is to add the 2tb back. If I am right, balance will move
>>> chunks from 3 and 4 to the 2TB,
>>
>> Not only to 2TB, but to 2TB and 6TB. Never forgot that RAID1 needs 2
>> devices.
>> And if 2TB is filled and 3/4 and free space, it's also possible to 3/4
>> devices.
>>
>> That will free 2TB in already filled up devices. But that's still not
>> enough to get space even.
>>
>> You may need to balance several times(maybe 10+) to make space a little
>> even, as balance won't balance any chunk which is created by balance.
>> (Or balance will loop infinitely).
>
> Now I understand -- I had not thought it would try to move 2 when that's
> so obviously wrong on a 3-drive, and so I was not thinking of the
> general case.  So I can now calculate that if I add the 2TB, in an ideal
> situation, it will perhaps get 1TB of chunks and the 6TB will get 1TB of
> chunks and then the 4 drives will have 3 with 1TB free, and the 6TB will
> have 3TB free.

The problem is that you have two devices totally full now, devid1 and
devid2. So it's not certain it's going to start just copying chunks
off those drives. Whatever it does, it does on both chunk copies. It
might be moving them. It might be packing them more efficiently with
extents. No deallocation of a chunk can happen until it's empty. So
for two full drives it's difficult to see how this gets fixed just
with a regular balance. I think you have to go to single profile...
OR...

Add the 2TB.
Remove the 6TB and wait.

        devid    3 size 5.43TiB used 1.42TiB path /dev/sdg2   this
suggests 1.4TiB on the 6TB drive so it should be possible for those
chunks to get moved to the 2TB drive.

Now you have an empty 6TB, and you still have a (very full) raid1 with all data.

mkfs a new volume on the 6TB, btrfs send/receive to get all data on
the 6TB drive. "Data,RAID1: Size:3.87TiB, Used:3.87TiB" suggests only
4TB data so the 6TB can hold all of it.

Now you can umount the old volume; and you can force add 3TB and 4TB
to the new 6TB volume, and -dconvert=raid1 -mconvert=raid1

The worse case scenario is the the 6TB drive dies during the
conversion and then it could be totally broken and you have to go to
backup. But otherwise, it's a bit less risky than two balances to and
from single profile across three or even four drives.



-- 
Chris Murphy
