Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:35791 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbcFTJW5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 05:22:57 -0400
Received: by mail-it0-f51.google.com with SMTP id z189so41827141itg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 02:22:57 -0700 (PDT)
Message-ID: <5767B5EE.30409@gmail.com>
Date: Mon, 20 Jun 2016 05:22:54 -0400
From: Tyson Whitehead <twhitehead@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub aborts on newer kernels
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>	<CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>	<25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca> <CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
In-Reply-To: <CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/06/16 06:18 PM, Chris Murphy wrote:
> On Fri, Jun 17, 2016 at 8:45 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
>> On May 27, 2016 12:12:54 PM Chris Murphy wrote:
>>> On Thu, May 26, 2016 at 11:55 AM, Tyson Whitehead <twhitehead@gmail.com> wrote:
>>>> Under the last several kernels versions (4.6 and I believe 4.4 and, 4.5) btrfs scrub aborts before completing.
>>>
>>> I can't reproduce this with btrfs-progs 4.5.2 and kernel 4.6.0.
>>>
>>> I think the bigger issue is the lack of information why a scrub is aborted.
>>
>> Thanks for checking into this Chris.
>>
>> Any advice on how to get some more information out of the scrub process?
>
> Next you need to find out why this one device has so many errors. Put the output from smartctl -x /dev/sdb somewhere, maybe even attach it to the bug report since it's somewhat related. Either that device is simply unreliable, or you've got a bad cable connection.

The device is okay.  The errors were caused by me running it for a period with only one of the devices present.

In more detail.  My desktop has a BTRFS RAID 1 setup.  I needed to access to it on the road, so I just shut the desktop down, grabbed one of the drives, and used it in my laptop in degraded mode.

When I got back I recombined them (the one I left in my office was never booted by itself) and started a scrub.  That is when I discovered scrub aborted on newer kernels but completed okay on older ones.

Cheers!  -Tyson
