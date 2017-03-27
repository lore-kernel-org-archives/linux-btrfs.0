Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:35581 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdC0Nqb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:46:31 -0400
Received: by mail-it0-f48.google.com with SMTP id y18so73691690itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 06:46:25 -0700 (PDT)
Subject: Re: Shrinking a device - performance?
To: Hugo Mills <hugo@carfax.org.uk>, Christian Theune <ct@flyingcircus.io>,
        linux-btrfs@vger.kernel.org
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327132404.GO11714@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
Date: Mon, 27 Mar 2017 09:46:16 -0400
MIME-Version: 1.0
In-Reply-To: <20170327132404.GO11714@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-27 09:24, Hugo Mills wrote:
> On Mon, Mar 27, 2017 at 03:20:37PM +0200, Christian Theune wrote:
>> Hi,
>>
>>> On Mar 27, 2017, at 3:07 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>>
>>>   On my hardware (consumer HDDs and SATA, RAID-1 over 6 devices), it
>>> takes about a minute to move 1 GiB of data. At that rate, it would
>>> take 1000 minutes (or about 16 hours) to move 1 TiB of data.
>>>
>>>   However, there are cases where some items of data can take *much*
>>> longer to move. The biggest of these is when you have lots of
>>> snapshots. When that happens, some (but not all) of the metadata can
>>> take a very long time. In my case, with a couple of hundred snapshots,
>>> some metadata chunks take 4+ hours to move.
>
>> Thanks for that info. The 1min per 1GiB is what I saw too - the “it
>> can take longer” wasn’t really explainable to me.
>
>> As I’m not using snapshots: would large files (100+gb) with long
>> chains of CoW history (specifically reflink copies) also hurt?
>
>    Yes, that's the same issue -- it's to do with the number of times
> an extent is shared. Snapshots are one way of creating that sharing,
> reflinks are another.
FWIW, I've noticed less of an issue with reflinks than snapshots, but I 
can't comment on this specific case.
>
>> Something I’d like to verify: does having traffic on the volume have
>> the potential to delay this infinitely? I.e. does the system write
>> to any segments that we’re trying to free so it may have to work on
>> the same chunk over and over again? If not, then this means it’s
>> just slow and we’re looking forward to about 2 months worth of time
>> shrinking this volume. (And then again on the next bigger server
>> probably about 3-4 months).
>
>    I don't know. I would hope not, but I simply don't know enough
> about the internal algorithms for that. Maybe someone else can confirm?
I'm not 100% certain, but I believe that while it can delay things, it 
can't do so infinitely.  AFAICT from looking at the code (disclaimer: I 
am not a C programmer by profession), it looks like writes to chunks 
that are being compacted or moved will go to the new location, not the 
old one, but writes to chunks which aren't being touched by the resize 
currently will just go to where the chunk is currently.  Based on this, 
lowering the amount of traffic to the FS could probably speed things up 
a bit, but it likely won't help much.
>
>> (Background info: we’re migrating large volumes from btrfs to xfs
>> and can only do this step by step: copying some data, shrinking the
>> btrfs volume, extending the xfs volume, rinse repeat. If someone
>> should have any suggestions to speed this up and not having to think
>> in terms of _months_ then I’m all ears.)
>
>    All I can suggest is to move some unused data off the volume and do
> it in fewer larger steps. Sorry.
Same.

The other option though is to just schedule a maintenance window, nuke 
the old FS, and restore from a backup.  If you can afford to take the 
system off-line temporarily, this will almost certainly go faster 
(assuming you have a reasonably fast means of restoring backups).
