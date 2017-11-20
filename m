Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:38279 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752932AbdKTV4s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 16:56:48 -0500
Received: by mail-ot0-f194.google.com with SMTP id b49so8886183otj.5
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 13:56:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com> <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com> <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
 <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 14:56:46 -0700
Message-ID: <CAJCQCtTJ54V11gOfUTta4z3y80kngGoNOn=KTKOXMb8rgFFdfg@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Jeff Mahoney <jeffm@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 1:40 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 11/20/17 3:01 PM, Jeff Mahoney wrote:
>> On 11/20/17 3:00 PM, Jeff Mahoney wrote:
>>> On 11/19/17 4:38 PM, Chris Murphy wrote:
>>>> On Sat, Nov 18, 2017 at 11:27 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
>>>>> 19.11.2017 09:17, Chris Murphy пишет:
>>>>>> fstrim should trim free space, but it only trims unallocated. This is
>>>>>> with kernel 4.14.0 and the entire 4.13 series. I'm pretty sure it
>>>>>> behaved this way with 4.12 also.
>>>>>>
>>>>>
>>>>> Well, I was told it should also trim free space ...
>>>>>
>>>>> https://www.spinics.net/lists/linux-btrfs/msg61819.html
>>>>>
>>>>
>>>> It definitely isn't. If I do a partial balance, then fstrim, I get a
>>>> larger trimmed value, corresponding exactly to unallocated space.
>>>
>>>
>>> I've just tested with 4.14 and it definitely trims within block groups.
>>
>> Derp.  This should read 4.12.
>>
>>> I've attached my test script and the log of the run.  I'll build and
>>> test a 4.14 kernel and see if I can reproduce there.  It may well be
>>> that we're just misreporting the bytes trimmed.
>
> I get the same results on v4.14.  I wrote up a little script to parse
> the btrfs-debug-tree extent tree dump and the discards that are issued
> after the final sync (when the tree is dumped) match.
>
> The script output is also as expected:
> /mnt2: 95.1 GiB (102082281472 bytes) trimmed
> # remove every other 100MB file, totalling 1.5 GB
> + sync
> + killall blktrace
> + wait
> + echo 'after sync'
> + sleep 1
> + btrace -a discard /dev/loop0
> + fstrim -v /mnt2
> /mnt2: 96.6 GiB (103659962368 bytes) trimmed
>
> One thing that may not be apparent is that the byte count is from the
> device(s)'s perspective.  If you have a file system with duplicate
> chunks or a redundant RAID mode, the numbers will reflect that.

This is a single device volume, single profile for data and metadata bg's.


>
> The total byte count should be correct as well.  It's the total number
> of bytes that we submit for discard and that were accepted by the block
> layer.

Total byte count from fstrim matches unallocated space, it does not
match reported free space. And when I do a filtered balance to reclaim
free space into unallocated space, subsequent fstrim shows a different
total value even though no files have been deleted. So it seems like
it's really trimming unallocated space not free space, or the trimmed
total wouldn't chance just because I've done a partial balance.
>
> Do you have a test case that shows it being wrong and can you provide
> the blktrace capture of the device(s) while the fstrim is running?

I have a test machine exhibiting this problem and can run whatever you
want on the machine, but it'll have to be rather verbose instructions.
In the meantime I'm about to test Qu's patch.



-- 
Chris Murphy
