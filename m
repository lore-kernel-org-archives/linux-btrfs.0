Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:34816 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbHAEfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 00:35:40 -0400
Received: by qgii95 with SMTP id i95so58948444qgi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2015 21:35:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
Date: Fri, 31 Jul 2015 21:35:39 -0700
Message-ID: <CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2015 at 10:45 PM, John Ettedgui <john.ettedgui@gmail.com> wrote:
> On Thu, Jul 30, 2015 at 10:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> It seems that you're using Chromium while doing the dump. :)
>> If no CD drive, I'll recommend to use Archlinux installation iso to make a
>> bootable USB stick and do the dump.
>> (just download and dd would do the trick)
>> As its kernel and tools is much newer than most distribution.
So I did not have any usb sticks large enough for this task (only 4Gb)
so I restarted into emergency runlevel with only / mounted and as ro,
I hope that'll do.
>>
>> It's better to provide two trace.
>> One is the function tracer one, with "btrfs:*" as set_event.
>> The other is the function_graph one. with "btrfs_mount" as
>> set_graph_function.
So I got 2 new traces, and I am hoping that these are what you meant,
but I am still not sure.
Here are the commands I used in case...:

trace-cmd record -o
trace-function_graph.dat -p function_graph -g btrfs_mount mount MountPoint

and

trace-function_graph.dat -p function -l 'btrfs_*' mount MountPoint
(using -e btrfs only lead to a crash but -l 'btrfs_*' passed, though I
am sure they have different purposes.. I hope that's the correct one)

The first one was so big, 2Gb, I had to use xz to compress it and host
it somewhere else, the ML would most likely not take it.
The other one is quite small but I hosted it in the same place....
Here are the links:
https://mega.nz/#!8tgTjKyK!XJnWH05bsv9sJ3nANIxKsdkL20RePPS4cKgWSxit0eQ
https://mega.nz/#!xopkVA6L!z9xjo3us1Nv6wdOs05jNZdhNbiAP5yeLdneEp0huUzI

I hope that was it this time!
Thanks,
John
