Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lw-001-i3050.relay.mailchannels.net ([177.153.0.175]:4130 "EHLO
        lw-001-i3050.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750705AbdAWIO0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 03:14:26 -0500
Subject: Re: RAID56 status?
To: Jan Vales <jan@jvales.net>, Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net>
 <20170122223906.GA24076@carfax.org.uk>
 <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
From: Brendan Hide <brendan@swiftspirit.co.za>
Message-ID: <525f6b68-07fa-54ec-4cfb-8e99199ff11c@swiftspirit.co.za>
Date: Mon, 23 Jan 2017 08:57:58 +0200
MIME-Version: 1.0
In-Reply-To: <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hey, all

Long-time lurker/commenter here. Production-ready RAID5/6 and N-way 
mirroring are the two features I've been anticipating most, so I've 
commented regularly when this sort of thing pops up. :)

I'm only addressing some of the RAID-types queries as Qu already has a 
handle on the rest.

Small-yet-important hint: If you don't have a backup of it, it isn't 
important.

On 01/23/2017 02:25 AM, Jan Vales wrote:
> [ snip ]
> Correct me, if im wrong...
> * It seems, raid1(btrfs) is actually raid10, as there are no more than 2
> copies of data, regardless of the count of devices.

The original "definition" of raid1 is two mirrored devices. The *nix 
industry standard implementation (mdadm) extends this to any number of 
mirrored devices. Thus confusion here is understandable.

> ** Is there a way to duplicate data n-times?

This is a planned feature, especially in lieu of feature-parity with 
mdadm, though the priority isn't particularly high right now. This has 
been referred to as "N-way mirroring". The last time I recall discussion 
over this, it was hoped to get work started on it after raid5/6 was stable.

> ** If there are only 3 devices and the wrong device dies... is it dead?

Qu has the right answers. Generally if you're using anything other than 
dup, raid0, or single, one disk failure is "okay". More than one failure 
is closer to "undefined". Except with RAID6, where you need to have more 
than two disk failures before you have lost data.

> * Whats the diffrence of raid1(btrfs) and raid10(btrfs)?

Some nice illustrations from Qu there. :)

> ** After reading like 5 diffrent wiki pages, I understood, that there
> are diffrences ... but not what they are and how they affect me :/
> * Whats the diffrence of raid0(btrfs) and "normal" multi-device
> operation which seems like a traditional raid0 to me?

raid0 stripes data in 64k chunks (I think this size is tunable) across 
all devices, which is generally far faster in terms of throughput in 
both writing and reading data.

By '"normal" multi-device' I will assume this means "single" with 
multiple devices. New writes with "single" will use a 1GB chunk on one 
device until the chunk is full, at which point it allocates a new chunk, 
which will usually be put on the disk with the most available free 
space. There is no particular optimisation in place comparable to raid0 
here.

>
> Maybe rename/alias raid-levels that do not match traditional
> raid-levels, so one cannot expect some behavior that is not there.

> The extreme example is imho raid1(btrfs) vs raid1.
> I would expect that if i have 5 btrfs-raid1-devices, 4 may die and btrfs
> should be able to fully recover, which, if i understand correctly, by
> far does not hold.
> If you named that raid-level say "george" ... I would need to consult
> the docs and I obviously would not expect any behavior. :)

We've discussed this a couple of times. Hugo came up with a notation 
since dubbed "csp" notation: c->Copies, s->Stripes, and p->Parities.

Examples of this would be:
raid1: 2c
3-way mirroring across 3 (or more*) devices: 3c
raid0 (2-or-more-devices): 2s
raid0 (3-or-more): 3s
raid5 (5-or-more): 4s1p
raid16 (12-or-more): 2c4s2p

* note the "or more": Mdadm *cannot* mirror less mirrors or stripes than 
devices, whereas there is no particular reason why btrfs won't be able 
to do this.

A minor problem with csp notation is that it implies a complete 
implementation of *any* combination of these, whereas the idea was 
simply to create a way to refer to the "raid" levels in a consistent way.

I hope this brings some clarity. :)

>
> regards,
> Jan Vales
> --
> I only read plaintext emails.
>

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
