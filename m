Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35894 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbcDOQVU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 12:21:20 -0400
Received: by mail-lf0-f51.google.com with SMTP id g184so151353071lfb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 09:21:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160415124910.GD30971@carfax.org.uk>
Date: Fri, 15 Apr 2016 18:21:14 +0200
Message-ID: <CAPmG0jbp15p6shXq2GtVude_AKTcN2xRDwki0M5m-iiC_Wh51g@mail.gmail.com>
Subject: Re: btrfs-image and btrfs send related queries
From: Henk Slager <eye1tm@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, sri <toyours_sridhar@yahoo.co.in>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <loom.20160415T142724-462@post.gmane.org>
 <20160415124910.GD30971@carfax.org.uk>

On Fri, Apr 15, 2016 at 2:49 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Apr 15, 2016 at 12:41:36PM +0000, sri wrote:
>> Hi,
>>
>> I have couple of queries related to btrfs-image, btrfs send and with
>> combination of two.
>> 1)
>> I would like to know if a btrfs source file system is spread across more
>> than 1 disks, does btrfs-image require same number of disks to create
>> empty file system without files content??
>
>    I don't _think_ you need as many devices as there were originally.

Indeed, if you run    btrfs-image -r     on a dump from a multi device
fs, you get 1 big fs image. I once did that for a 4x4TB RAID10 fs
(tools v4.3.x at that time I believe), resulting in a 17TB (sparse)
file. I was expecting that option  -m would create multiple files,
however, scanning the source-code revealed that there are things not
implemented (it resulted in a 34T file that was simply not a valid
fs). Or I did something wrong or there is a bug.

For just my case, it was much quicker to patch the kernel so that it
worked with the 17T file. There are then still issues w.r.t. devices,
but data is missing so anyhow only a limited set of tool actions or
issues can be researched with such a generated image. But for a
multi-TB fs, the data volume is acceptable (roughly in 1G or 10G
order).

I think it would make sense that the btrfs-image restore output can be
split into multiple files, so that the multidevice aspects are better
represented (or modelled).

>> 2) would btrfs-image can be modified to keep only given subvolume foot
>> print and related meta data to bring back file system live on destination
>> disk?
>>
>>    To elaborate more on this, Lets say I have 5 subvolumes on source btrfs
>> and i run btrfs-image written to destination disk say /dev/sdd. In this
>> process, can btrfs-image modified to just have only 1 subvolume and skipp
>> other 4 subvolumes and write to destination i.. /dev/sdd so that when I
>> mount /dev/sdd , I will have btrfs with only 1 subvolume with no data.
>
>    For a first approximation, you could just drop any FS tree from the
> image which wasn't the target one. After that, it turns into a
> complicated accounting exercise to drop all of the back-refs to the
> missing FS trees, and to drop all the extent records for the
> non-shared data and the metadata for the missing FS trees.
>
>    It's probably going to be complicated, and will basically involve
> rewriting most of the image to avoid the metadata you didn't want.
>
>> 3) If 3 can successful, can btrfs-image further changed to include data of
>> selected subvolume which gives files data also written to /dev/sdd which
>> would be kind of a backup of a subvolume taken out of a btrfs file system
>> which is having more than 1 subvolumes.
>
>    If you're going to do all the hard work of (2), then (3) is a
> reasonable logical(?) extension.
>
>    On the other hand, what's wrong with simply using send/receive? It
> gives you a data structure (a FAR-format send stream) which contains
> everything you need to reconstruct a subvolume on a btrfs different
> to the original.
>
>    Hugo.
>
> --
> Hugo Mills             | Mary had a little lamb
> hugo@... carfax.org.uk | You've heard this tale before
> http://carfax.org.uk/  | But did you know she passed her plate
> PGP: E2AB1DE4          | And had a little more?
