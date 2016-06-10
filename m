Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:32923 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbcFJPiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 11:38:23 -0400
Received: by mail-vk0-f51.google.com with SMTP id d64so102499807vkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 08:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <420018f7-d129-5861-2fc4-bf2f92e46b69@cn.fujitsu.com>
References: <87eg8g5lwt.fsf@vostro.rath.org> <06ef9ac3-ed15-9621-9629-4c8965618db6@cn.fujitsu.com>
 <87zir3skpo.fsf@thinkpad.rath.org> <420018f7-d129-5861-2fc4-bf2f92e46b69@cn.fujitsu.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 10 Jun 2016 17:38:15 +0200
Message-ID: <CAPmG0ja7R4Vas=4RWVYsd5bnWrLj8NPP8-=uxg6yJd0A4r_k-Q@mail.gmail.com>
Subject: Re: How to map extents to files
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 10:17 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 06/02/2016 10:56 PM, Nikolaus Rath wrote:
>>
>> On Jun 02 2016, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>> At 06/02/2016 11:06 AM, Nikolaus Rath wrote:
>>>>
>>>> Hello,
>>>>
>>>> For one of my btrfs volumes, btrfsck reports a lot of the following
>>>> warnings:
>>>>
>>>> [...]
>>>> checking extents
>>>> bad extent [138477568, 138510336), type mismatch with chunk
>>>> bad extent [140091392, 140148736), type mismatch with chunk
>>>> bad extent [140148736, 140201984), type mismatch with chunk
>>>> bad extent [140836864, 140865536), type mismatch with chunk
>>>> [...]
>>>>
>>>> Is there a way to discover which files are affected by this (in
>>>> particular so that I can take a look at them before and after a btrfsck
>>>> --repair)?
>>>
>>>
>>> Which version is the progs? If the fs is not converted from ext2/3/4,
>>> it may be a false alert.
>>
>>
>> Version is 4.4.1. The fs may very well have been converted from ext4,
>> but I can't tell for sure.
>>
>>
>> Best,
>> -Nikolaus
>>
>
> Sorry for the late reply.
>
> For such case, btrfsck --repair is unable to fix it, as btrfs-progs is not
> able to balance extents.
>
> Normally, a full balance would fix it.
>
>
> I would try to update btrfs-progs to 4.5 and recheck, to see if it's a false
> alert.
> If not, then remove unused snapshots and then do the full balance.
>
> It's recommended to delete unused snapshots, as if there are too many
> snapshots, balance may be quite slow.

You might want to try to balance only the ranges that are problematic
if a recent kernel+tools still report this bad extents.

AFAIK, in the 'bad extent [X, Y), type mismatch with chunk' text, the
X and Y are logical byte numbers (virtual addresses).
You can list all chunks with this:
https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py

To force balance of this [X, Y) range, run   btrfs balance start -v
-dvrange=X..Y <mountpoint>
or    -mvrange or -svrange  if [X, Y) is in a metadata resp. system chunk.

The  btrfs-debugfs python script in the
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
sources might also help, but it does not list system and metadata
chunks.

After such a filtered balance, you should see at least one new chunk
added (just see the highest virtual addr)

In case the [X, Y) are physical, have a look at the man btrfs-balance
drange filter.
I currently don't know an answer to your post subject, but maybe less
important as [X, Y) might also be not file contents
related.
