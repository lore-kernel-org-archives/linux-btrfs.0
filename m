Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:59838 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbbHMWie convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 18:38:34 -0400
Received: from smtp30.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id CC051380127
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 18:38:33 -0400 (EDT)
Received: from smtp30.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id C807D380163
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 18:38:33 -0400 (EDT)
Received: from app3.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp30.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id BE86B380127
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 18:38:33 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app3.wa-webapps.iad3a (Postfix) with ESMTP id 78850280098
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 18:38:33 -0400 (EDT)
Date: Thu, 13 Aug 2015 18:38:33 -0400 (EDT)
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
In-Reply-To: <55C1F3DD.7020603@gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
 <55BAFEF9.1070107@cn.fujitsu.com>
 <CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
 <55BB0A39.1050208@cn.fujitsu.com>
 <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
 <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
 <55C017E7.40704@cn.fujitsu.com>
 <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
 <55C02AF9.3070600@cn.fujitsu.com>
 <CAJ3TwYQUX-CgqSXMxxU+6tcb0_0tuJbwKqHHPufCnsDBYuXycw@mail.gmail.com>
 <55C0A1ED.6020407@gmail.com>
 <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
 <55C1F3DD.7020603@gmail.com>
Message-ID: <1439505513.484813682@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I think I might be having this problem too. 12 x 4TB RAID10 (original makefs, not converted from ext or whatnot). Says it has ~6TiB left. Centos 7. Dual Xeon CPU. 32GB RAM. ELRepo Kernel 4.1.5. Fstab options: noatime,autodefrag,compress=zlib,space_cache,nossd,noauto,x-systemd.automount

Sometimes (not all the time) when I cd or ls the mount point it will not return within 5 minutes (I never let it run more than 5 minutes before rebooting) and I reboot and then it takes between 10-30s. Well as I'm writing this it's already been more than 10 minutes.
 
I don't have the problem when I mount manually without the "noauto,x-systemd.automount" options.
 
Can anyone help ?
 
Thanks.

Vincent

-----Original Message-----
From: "Austin S Hemmelgarn" <ahferroin7@gmail.com>
Sent: Wednesday, August 5, 2015 07:30
To: "John Ettedgui" <john.ettedgui@gmail.com>
Cc: "Qu Wenruo" <quwenruo@cn.fujitsu.com>, "btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory

On 2015-08-04 13:36, John Ettedgui wrote:
> On Tue, Aug 4, 2015 at 4:28 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-04 00:58, John Ettedgui wrote:
>>>
>>> On Mon, Aug 3, 2015 at 8:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>
>>>> Although the best practice is staying away from such converted fs, either
>>>> using pure, newly created btrfs, or convert back to ext* before any
>>>> balance.
>>>>
>>> Unfortunately I don't have enough hard drive space to do a clean
>>> btrfs, so my only way to use btrfs for that partition was a
>>> conversion.
>>
>> If you could get your hands on a decent sized flash drive (32G or more), you
>> could do an incremental conversion offline.  The steps would look something
>> like this:
>>
>> 1. Boot the system into a LiveCD or something similar that doesn't need to
>> run from your regular root partition (SystemRescueCD would be my personal
>> recommendation, although if you go that way, make sure to boot the
>> alternative kernel, as it's a lot newer then the standard ones).
>> 2. Plug in the flash drive, format it as BTRFS.
>> 3. Mount both your old partition and the flash drive somewhere.
>> 4. Start copying files from the old partition to the flash drive.
>> 5. When you hit ENOSPC on the flash drive, unmount the old partition, shrink
>> it down to the minimum size possible, and create a new partition in the free
>> space produced by doing so.
>> 6. Add the new partition to the BTRFS filesystem on the flash drive.
>> 7. Repeat steps 4-6 until you have copied everything.
>> 8. Wipe the old partition, and add it to the BTRFS filesystem.
>> 9. Run a full balance on the new BTRFS filesystem.
>> 10. Delete the partition from step 5 that is closest to the old partition
>> (via btrfs device delete), then resize the old partition to fill the space
>> that the deleted partition took up.
>> 11. Repeat steps 9-10 until the only remaining partitions in the new BTRFS
>> filesystem are the old one and the flash drive.
>> 12. Delete the flash drive from the BTRFS filesystem.
>>
>> This takes some time and coordination, but it does work reliably as long as
>> you are careful (I've done it before on multiple systems).
>>
>>
> I suppose I could do that even without the flash as I have some free
> space anyway, but moving Tbs of data with Gbs of free space will take
> days, plus the repartitioning. It'd probably be easier to start with a
> 1Tb drive or something.
> Is this currently my best bet as conversion is not as good as I thought?
>
> I believe my other 2 partitions also come from conversion, though I
> may have rebuilt them later from scratch.
>
> Thank you!
> John
>
Yeah, you're probably better off getting a TB disk and starting with 
that.  In theory it is possible to automate the process, but I would 
advise against that if at all possible, it's a lot easier to recover 
from an error if you're doing it manually.


