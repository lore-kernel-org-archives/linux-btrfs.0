Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33454 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdKTW7G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 17:59:06 -0500
Received: by mail-oi0-f52.google.com with SMTP id f135so7298501oib.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Nov 2017 14:59:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
References: <CAJCQCtRpWuPLsmGLmNcon45YzfewRFPHxjhCJY=mVZ_Od7jxxQ@mail.gmail.com>
 <8af43ea0-d2a3-aa3e-0b68-fefe3b3d96ea@gmail.com> <CAJCQCtQ8t8uMRsWh0gcm=KU_2CpZnn9dx=Svf_1+6UWR4BEcpA@mail.gmail.com>
 <3114a78e-485a-daea-f8b1-48cc330f4209@suse.com> <bbab87ad-b84e-2bca-5d90-47a77abd295d@suse.com>
 <94ecb41f-e825-97ce-999d-020a5abffccd@suse.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 20 Nov 2017 15:59:04 -0700
Message-ID: <CAJCQCtQ4uJG-bSQnUOXjBYYqG6Hp6Tf_fHsaoHfKgZ17w6mo0Q@mail.gmail.com>
Subject: Re: bug? fstrim only trims unallocated space, not unused in bg's
To: Jeff Mahoney <jeffm@suse.com>
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
>
> The total byte count should be correct as well.  It's the total number
> of bytes that we submit for discard and that were accepted by the block
> layer.
>
> Do you have a test case that shows it being wrong and can you provide
> the blktrace capture of the device(s) while the fstrim is running?


Further,

# fstrim -v /
/: 38 GiB (40767586304 bytes) trimmed

And then delete 10G worth of files, do not balance, and do nothing for
a minute before:

# fstrim -v /
/: 38 GiB (40767586304 bytes) trimmed

It's the same value. Free space according to fi us is +10 larger than
before, and yet nothing additional is trimmed than before. So I don't
know what's going on but it's not working for me.



-- 
Chris Murphy
