Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47674 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753825AbbHDDBT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 23:01:19 -0400
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
To: John Ettedgui <john.ettedgui@gmail.com>
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55C02AF9.3070600@cn.fujitsu.com>
Date: Tue, 4 Aug 2015 11:01:13 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



John Ettedgui wrote on 2015/08/03 18:55 -0700:
> On Mon, Aug 3, 2015 at 6:39 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> Oh, you were using trace-cmd, that's why the data is so huge.
> Oh, I thought it was just automating the work for me, but without any
> sort of impact.
>>
>> I was originally hoping you just copy the trace file, which is human
>> readable and not so huge.
> If you mean something like the ouput of trace-cmd report, it was
> actually bigger than the dat files (about twice the size) that's why I
> shared the dats instead.
> If you want the reports instead I'll gladly share them.
Nop, not the report, but /sys/kernel/debug/tracing/trace.

But that needs some manual operation, like set event and graph functions.
>>
>> But that's OK anyway.
>>
>> I'll try to analyse it to find a clue if possible.
>>
>> Thanks,
>> Qu
> Great thank you!
>
> By the way, I just thought of a few things to mention.
> This btrfs partition is an ext4 converted partition, and I hit the
> same behavior as these guys under heavy load:
> http://www.spinics.net/lists/linux-btrfs/msg44660.html
> http://www.spinics.net/lists/linux-btrfs/msg44191.html
> I don't think it's related to the crash, but maybe to the conversion?

Oh, converted...
That's too bad. :(

[[What's wrong with convert]]
Although btrfs is flex enough in theory to fit itself into the free 
space of ext* and works fine,
But in practice, ext* is too fragmental in the standard of btrfs, not to 
mention it also enables mixed-blockgroup.


[[Recommendations]]
I'd recommend to delete the ext*_img subvolume and rebalance all chunks 
in the fs if you're stick to the converted filesystem.

Although the best practice is staying away from such converted fs, 
either using pure, newly created btrfs, or convert back to ext* before 
any balance.

[[But before that, just try something]]
But you have already provided some interesting facts. As the filesystem 
is high fragmented, I'd like to recommend to do some little test:
(BTW I assume you don't use some special mount options)
To test if it's the space cache causing the mount speed drop.

1) clear page cache
    # echo 3 > /proc/sys/vm/drop_caches
2) Do a normal mount
    Just as what you do as usual, with your normal mount options
    Record the mount time
3) umount it.
4) clear page cache
    # echo 3 > /proc/sys/vm/drop_caches
5) mount it with "clear_cache" mount option
    It may takes sometime to clear the existing cache.
    It's just used to clear space cache.
    Don't compare mount time!
6) umount it
7) clear page cache
    # echo 3 > /proc/sys/vm/drop_caches
8) mount with "nospace_cache" mount option
    To see if there is obvious mount time change.

Hopes that's the space cache thing causing the slow mount.
But don't expect it too much anyway, it's just one personal guess.

After the test, I'd recommend to follow the [[Recommendations]] if you 
just want a stable filesystem.

Thanks,
Qu

>
> Thanks Qu!
> John
>
