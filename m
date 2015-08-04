Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36338 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbHDRgD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 13:36:03 -0400
Received: by qgeh16 with SMTP id h16so11815611qge.3
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 10:36:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C0A1ED.6020407@gmail.com>
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
Date: Tue, 4 Aug 2015 10:36:02 -0700
Message-ID: <CAJ3TwYQgm2f4SQFOO_vgGLP0V71q+oesbjFxTjhEJnrXYLe4fQ@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 4, 2015 at 4:28 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-08-04 00:58, John Ettedgui wrote:
>>
>> On Mon, Aug 3, 2015 at 8:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> Although the best practice is staying away from such converted fs, either
>>> using pure, newly created btrfs, or convert back to ext* before any
>>> balance.
>>>
>> Unfortunately I don't have enough hard drive space to do a clean
>> btrfs, so my only way to use btrfs for that partition was a
>> conversion.
>
> If you could get your hands on a decent sized flash drive (32G or more), you
> could do an incremental conversion offline.  The steps would look something
> like this:
>
> 1. Boot the system into a LiveCD or something similar that doesn't need to
> run from your regular root partition (SystemRescueCD would be my personal
> recommendation, although if you go that way, make sure to boot the
> alternative kernel, as it's a lot newer then the standard ones).
> 2. Plug in the flash drive, format it as BTRFS.
> 3. Mount both your old partition and the flash drive somewhere.
> 4. Start copying files from the old partition to the flash drive.
> 5. When you hit ENOSPC on the flash drive, unmount the old partition, shrink
> it down to the minimum size possible, and create a new partition in the free
> space produced by doing so.
> 6. Add the new partition to the BTRFS filesystem on the flash drive.
> 7. Repeat steps 4-6 until you have copied everything.
> 8. Wipe the old partition, and add it to the BTRFS filesystem.
> 9. Run a full balance on the new BTRFS filesystem.
> 10. Delete the partition from step 5 that is closest to the old partition
> (via btrfs device delete), then resize the old partition to fill the space
> that the deleted partition took up.
> 11. Repeat steps 9-10 until the only remaining partitions in the new BTRFS
> filesystem are the old one and the flash drive.
> 12. Delete the flash drive from the BTRFS filesystem.
>
> This takes some time and coordination, but it does work reliably as long as
> you are careful (I've done it before on multiple systems).
>
>
I suppose I could do that even without the flash as I have some free
space anyway, but moving Tbs of data with Gbs of free space will take
days, plus the repartitioning. It'd probably be easier to start with a
1Tb drive or something.
Is this currently my best bet as conversion is not as good as I thought?

I believe my other 2 partitions also come from conversion, though I
may have rebuilt them later from scratch.

Thank you!
John
