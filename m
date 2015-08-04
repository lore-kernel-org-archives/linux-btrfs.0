Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8798 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753214AbbHDBj5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 21:39:57 -0400
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
CC: btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55C017E7.40704@cn.fujitsu.com>
Date: Tue, 4 Aug 2015 09:39:51 +0800
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



John Ettedgui wrote on 2015/07/31 21:35 -0700:
> On Thu, Jul 30, 2015 at 10:45 PM, John Ettedgui <john.ettedgui@gmail.com> wrote:
>> On Thu, Jul 30, 2015 at 10:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> It seems that you're using Chromium while doing the dump. :)
>>> If no CD drive, I'll recommend to use Archlinux installation iso to make a
>>> bootable USB stick and do the dump.
>>> (just download and dd would do the trick)
>>> As its kernel and tools is much newer than most distribution.
> So I did not have any usb sticks large enough for this task (only 4Gb)
> so I restarted into emergency runlevel with only / mounted and as ro,
> I hope that'll do.
>>>
>>> It's better to provide two trace.
>>> One is the function tracer one, with "btrfs:*" as set_event.
>>> The other is the function_graph one. with "btrfs_mount" as
>>> set_graph_function.
> So I got 2 new traces, and I am hoping that these are what you meant,
> but I am still not sure.
> Here are the commands I used in case...:
>
> trace-cmd record -o
> trace-function_graph.dat -p function_graph -g btrfs_mount mount MountPoint
>
> and
>
> trace-function_graph.dat -p function -l 'btrfs_*' mount MountPoint
> (using -e btrfs only lead to a crash but -l 'btrfs_*' passed, though I
> am sure they have different purposes.. I hope that's the correct one)
>
> The first one was so big, 2Gb, I had to use xz to compress it and host
> it somewhere else, the ML would most likely not take it.
> The other one is quite small but I hosted it in the same place....
> Here are the links:
> https://mega.nz/#!8tgTjKyK!XJnWH05bsv9sJ3nANIxKsdkL20RePPS4cKgWSxit0eQ
> https://mega.nz/#!xopkVA6L!z9xjo3us1Nv6wdOs05jNZdhNbiAP5yeLdneEp0huUzI
>
> I hope that was it this time!
Oh, you were using trace-cmd, that's why the data is so huge.

I was originally hoping you just copy the trace file, which is human 
readable and not so huge.

But that's OK anyway.

I'll try to analyse it to find a clue if possible.

Thanks,
Qu
> Thanks,
> John
>
