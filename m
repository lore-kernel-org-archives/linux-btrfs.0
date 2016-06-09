Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36288 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932943AbcFISHu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 14:07:50 -0400
Received: by mail-oi0-f49.google.com with SMTP id p204so75958192oih.3
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jun 2016 11:07:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5758A5F6.4060400@mendix.com>
References: <572D0C8B.8010404@mendix.com>
	<89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
	<5758A5F6.4060400@mendix.com>
Date: Thu, 9 Jun 2016 12:07:49 -0600
Message-ID: <CAJCQCtQSM0uPKbSB6cb30eb9iB-dx4jctDwOAqLGz6AdOkjhRQ@mail.gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent reason
From: Chris Murphy <lists@colorremedies.com>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 8, 2016 at 5:10 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> Hi list,
>
>
> On 05/31/2016 03:36 AM, Qu Wenruo wrote:
>>
>>
>>
>> Hans van Kranenburg wrote on 2016/05/06 23:28 +0200:
>>>
>>> Hi,
>>>
>>> I've got a mostly inactive btrfs filesystem inside a virtual machine
>>> somewhere that shows interesting behaviour: while no interesting disk
>>> activity is going on, btrfs keeps allocating new chunks, a GiB at a time.
>>>
>>> A picture, telling more than 1000 words:
>>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/btrfs_usage_ichiban.png
>>> (when the amount of allocated/unused goes down, I did a btrfs balance)
>>
>>
>> Nice picture.
>> Really better than 1000 words.
>>
>> AFAIK, the problem may be caused by fragments.
>>
>> And even I saw some early prototypes inside the codes to allow btrfs do
>> allocation smaller extent than required.
>> (E.g. caller needs 2M extent, but btrfs returns 2 1M extents)
>>
>> But it's still prototype and seems no one is really working on it now.
>>
>> So when btrfs is writing new data, for example, to write about 16M data,
>> it will need to allocate a 16M continuous extent, and if it can't find
>> large enough space to allocate, then create a new data chunk.
>>
>> Despite the already awesome chunk level usage pricutre, I hope there is
>> info about extent level allocation to confirm my assumption.
>>
>> You could dump it by calling "btrfs-debug-tree -t 2 <device>".
>> It's normally recommended to do it unmounted, but it's still possible to
>> call it mounted, although not 100% perfect though.
>> (Then I'd better find a good way to draw a picture of
>> allocate/unallocate space and how fragments the chunks are)
>
>
> So, I finally found some spare time to continue investigating. In the
> meantime, the filesystem has happily been allocating new chunks every few
> days, filling them up way below 10% with data before starting a new one.
>
> The chunk allocation primarily seems to happen during cron.daily. But,
> manually executing all the cronjobs that are in there, even multiple times,
> does not result in newly allocated chunks. Yay. :(
>
> After the previous post, I put a little script in between every two jobs in
> /etc/cron.daily that prints the output of btrfs fi df to syslog and sleeps
> for 10 minutes so I can easily find out afterwards during which one it
> happened.
>
> Bingo! The "apt" cron.daily, which refreshes package lists and triggers
> unattended-upgrades.
>
> Jun 7 04:01:46 ichiban root: Data, single: total=12.00GiB, used=5.65GiB
> [...]
> 2016-06-07 04:01:56,552 INFO Starting unattended upgrades script
> [...]
> Jun 7 04:12:10 ichiban root: Data, single: total=13.00GiB, used=5.64GiB
>
> And, this thing is clever enough to do things once a day, even if you would
> execute it multple times... (Hehehe...)
>
> Ok, let's try doing some apt-get update then.
>
> Today, the latest added chunks look like this:
>
> # ./show_usage.py /
> [...]
> chunk vaddr 63495471104 type 1 stripe 0 devid 1 offset 9164554240 length
> 1073741824 used 115499008 used_pct 10
> chunk vaddr 64569212928 type 1 stripe 0 devid 1 offset 12079595520 length
> 1073741824 used 36585472 used_pct 3
> chunk vaddr 65642954752 type 1 stripe 0 devid 1 offset 14227079168 length
> 1073741824 used 17510400 used_pct 1
> chunk vaddr 66716696576 type 4 stripe 0 devid 1 offset 3275751424 length
> 268435456 used 72663040 used_pct 27
> chunk vaddr 66985132032 type 1 stripe 0 devid 1 offset 15300820992 length
> 1073741824 used 86986752 used_pct 8
> chunk vaddr 68058873856 type 1 stripe 0 devid 1 offset 16374562816 length
> 1073741824 used 21188608 used_pct 1
> chunk vaddr 69132615680 type 1 stripe 0 devid 1 offset 17448304640 length
> 1073741824 used 64032768 used_pct 5
> chunk vaddr 70206357504 type 1 stripe 0 devid 1 offset 18522046464 length
> 1073741824 used 71712768 used_pct 6
>
> Now I apt-get update...
>
> before: Data, single: total=13.00GiB, used=5.64GiB
> during: Data, single: total=13.00GiB, used=5.59GiB
> after : Data, single: total=14.00GiB, used=5.64GiB
>
> # ./show_usage.py /
> [...]
> chunk vaddr 63495471104 type 1 stripe 0 devid 1 offset 9164554240 length
> 1073741824 used 119279616 used_pct 11
> chunk vaddr 64569212928 type 1 stripe 0 devid 1 offset 12079595520 length
> 1073741824 used 36585472 used_pct 3
> chunk vaddr 65642954752 type 1 stripe 0 devid 1 offset 14227079168 length
> 1073741824 used 17510400 used_pct 1
> chunk vaddr 66716696576 type 4 stripe 0 devid 1 offset 3275751424 length
> 268435456 used 73170944 used_pct 27
> chunk vaddr 66985132032 type 1 stripe 0 devid 1 offset 15300820992 length
> 1073741824 used 82251776 used_pct 7
> chunk vaddr 68058873856 type 1 stripe 0 devid 1 offset 16374562816 length
> 1073741824 used 21188608 used_pct 1
> chunk vaddr 69132615680 type 1 stripe 0 devid 1 offset 17448304640 length
> 1073741824 used 6041600 used_pct 0
> chunk vaddr 70206357504 type 1 stripe 0 devid 1 offset 18522046464 length
> 1073741824 used 46178304 used_pct 4
> chunk vaddr 71280099328 type 1 stripe 0 devid 1 offset 19595788288 length
> 1073741824 used 84770816 used_pct 7
>
> Interesting. There's a new one at 71280099328, 7% filled, and the usage of
> the 4 previous ones went down a bit.
>
> Now I want to know what the distribution of data inside these chunks, to
> find out how fragmented it might be, so I spent some time this evening to
> play a bit more with the search ioctl, and list all extents and free space
> inside a chunk:
>
> https://github.com/knorrie/btrfs-heatmap/blob/master/chunk-contents.py
>
> Currently the output looks like this:
>
> # ./chunk-contents.py 70206357504 .
> chunk vaddr 70206357504 length 1073741824
> 0x1058a00000 0x105a0cafff  23900160 2.23%
> 0x105a0cb000 0x105a0cbfff      4096 0.00% extent
> 0x105a0cc000 0x105a12ffff    409600 0.04%
> 0x105a130000 0x105a130fff      4096 0.00% extent
> 0x105a131000 0x105a21dfff    970752 0.09%
> 0x105a21e000 0x105a220fff     12288 0.00% extent
> 0x105a221000 0x105a222fff      8192 0.00% extent
> 0x105a223000 0x105a224fff      8192 0.00% extent
> 0x105a225000 0x105a225fff      4096 0.00% extent
> 0x105a226000 0x105a226fff      4096 0.00% extent
> 0x105a227000 0x105a227fff      4096 0.00% extent
> 0x105a228000 0x105a2c3fff    638976 0.06%
> 0x105a2c4000 0x105a2c5fff      8192 0.00% extent
> 0x105a2c6000 0x105a317fff    335872 0.03%
> 0x105a318000 0x105a31efff     28672 0.00% extent
> 0x105a31f000 0x105a3affff    593920 0.06%
> 0x105a3b0000 0x105a3b2fff     12288 0.00% extent
> 0x105a3b3000 0x105a3b6fff     16384 0.00%
> 0x105a3b7000 0x105a3bbfff     20480 0.00% extent
> 0x105a3bc000 0x105a3e2fff    159744 0.01%
> 0x105a3e3000 0x105a3e3fff      4096 0.00% extent
> 0x105a3e4000 0x105a3e4fff      4096 0.00% extent
> 0x105a3e5000 0x105a468fff    540672 0.05%
> 0x105a469000 0x105a46cfff     16384 0.00% extent
> 0x105a46d000 0x105a493fff    159744 0.01%
> 0x105a494000 0x105a495fff      8192 0.00% extent
> 0x105a496000 0x105a49afff     20480 0.00%
> [...]
>
> After running apt-get update a few extra times, only the last (new) chunk
> keeps changing a bit, and stabilizes around 10% usage:
>
> chunk vaddr 71280099328 type 1 stripe 0 devid 1 offset 19595788288 length
> 1073741824 used 112271360 used_pct 10
>
> chunk vaddr 71280099328 length 1073741824
> 0x1098a00000 0x109e00dfff  90234880 8.40%
> 0x109e00e000 0x109e00efff      4096 0.00% extent
> 0x109e00f000 0x109e00ffff      4096 0.00% extent
> 0x109e010000 0x109e010fff      4096 0.00%
> 0x109e011000 0x109e011fff      4096 0.00% extent
> 0x109e012000 0x109e342fff   3346432 0.31%
> 0x109e343000 0x109e344fff      8192 0.00% extent
> 0x109e345000 0x109e47cfff   1277952 0.12%
> 0x109e47d000 0x109e47efff      8192 0.00% extent
> 0x109e47f000 0x109e480fff      8192 0.00%
> 0x109e481000 0x109e482fff      8192 0.00% extent
> 0x109e483000 0x109e484fff      8192 0.00% extent
> 0x109e485000 0x109e48afff     24576 0.00% extent
> 0x109e48b000 0x109e48cfff      8192 0.00%
> 0x109e48d000 0x109e48efff      8192 0.00% extent
> 0x109e48f000 0x109e490fff      8192 0.00%
> 0x109e491000 0x109e492fff      8192 0.00% extent
> 0x109e493000 0x109e493fff      4096 0.00% extent
> 0x109e494000 0x109eb00fff   6737920 0.63%
> 0x109eb01000 0x109eb10fff     65536 0.01% extent
> 0x109eb11000 0x109ebc0fff    720896 0.07%
> 0x109ebc1000 0x109ec00fff    262144 0.02% extent
> 0x109ec01000 0x109ecc4fff    802816 0.07%
>
> Full output at
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2016-06-08-extents.txt
>
> Free space is extremely fragmented. The last one, which just got filled a
> bit using apt-get update looks better, with a few blocks up to 25% of free
> space, but the previous ones are a mess.
>
> So, instead of being the cause, apt-get update causing a new chunk to be
> allocated might as well be the result of existing ones already filled up
> with too many fragments.
>
> The next question is what files these extents belong to. To find out, I need
> to open up the extent items I get back and follow a backreference to an
> inode object. Might do that tomorrow, fun.
>
> To be honest, I suspect /var/log and/or the file storage of mailman to be
> the cause of the fragmentation, since there's logging from postfix, mailman
> and nginx going on all day long in a slow but steady tempo. While using
> btrfs for a number of use cases at work now, we normally don't use it for
> the root filesystem. And the cases where it's used as root filesystem don't
> do much logging or mail.
>
> And no, autodefrag is not in the mount options currently. Would that be
> helpful in this case?


Pure speculation follows...
If existing chunks are heavily fragmented, it might be a good idea,
especially on spinning rust, to just allocate new chunks to
contiguously write to, with the idea that as chunks age, they'll
become less fragmented due to file deletions. Maybe the seemingly
premature and unnecessary new chunk allocations are (metaphorically)
equivalent to the Linux cache trying to use all available free memory
before it starts dropping cache contents? OK so to test this, what
happens if you just let the thing go? i.e. if fully allocates all the
available space? Once that happens so you get ENOSPC or other brick
wall behaviors? Or is it just a matter of performance taking a nasty
hit?

I think the brick wall behavior is a bigger bug than the performance
tuning one, and probably easier to identify and fix, especially the
fewer non-default mount options there are. The fs should be reliable,
even if it's slow.

Next, would be to find out what sort of tuning reduces this problem.
It could be relatively simple, maybe just autofrag does the trick. But
if the files are really small, but just not small enough to fit inline
with metadata, it might be a better tuning is to use a bigger
nodesize. But I have no idea what the file sizes are. Yet another one
would be using the ssd mount option even if (?) this is on an HDD. The
description of the problem sounds like what ssd_spread might do, but
it could be worth trying that one.

And still another, which I put last only because it wouldn't be nearly
so automatic, would actually be to pin the extents from being freed
with snapshots. That way piles of small fragments don't happen. You'd
really want to know what the read, write pattern is, especially the
delete pattern that results in the fragmented freeing of extents. If
it's the mail server causing this, I don't know that this is a great
solution because additions and deletions happen constantly. So this
idea might only soften the problem rather than fix it? I think if
these are really small files, say 20K, then perhaps a 64KiB nodesize
improves inlining them. And if that does help, you can in effect get a
bigger nodesize by then using the compress option.

So actually yeah a little more data about what's causing the
fragmentation would be useful; probably what's being deleted and how
big are those extents?




-- 
Chris Murphy
