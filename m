Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:36851 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753211AbdC0OTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 10:19:12 -0400
Received: by mail-it0-f53.google.com with SMTP id e75so22222999itd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Mar 2017 07:19:00 -0700 (PDT)
Subject: Re: Shrinking a device - performance?
To: Christian Theune <ct@flyingcircus.io>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327132404.GO11714@carfax.org.uk>
 <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
 <D3C6181C-2485-4CBC-AD13-A367DD6665F2@flyingcircus.io>
 <333BD058-6365-43C3-8070-E6267936D98D@flyingcircus.io>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bf772a48-5181-d1ea-f7a7-5dffc524e2de@gmail.com>
Date: Mon, 27 Mar 2017 10:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <333BD058-6365-43C3-8070-E6267936D98D@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-27 09:54, Christian Theune wrote:
> Hi,
>
>> On Mar 27, 2017, at 3:50 PM, Christian Theune <ct@flyingcircus.io> wrote:
>>
>> Hi,
>>
>>> On Mar 27, 2017, at 3:46 PM, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>>>>
>>>>> Something I’d like to verify: does having traffic on the volume have
>>>>> the potential to delay this infinitely? I.e. does the system write
>>>>> to any segments that we’re trying to free so it may have to work on
>>>>> the same chunk over and over again? If not, then this means it’s
>>>>> just slow and we’re looking forward to about 2 months worth of time
>>>>> shrinking this volume. (And then again on the next bigger server
>>>>> probably about 3-4 months).
>>>>
>>>>  I don't know. I would hope not, but I simply don't know enough
>>>> about the internal algorithms for that. Maybe someone else can confirm?
>>> I'm not 100% certain, but I believe that while it can delay things, it can't do so infinitely.  AFAICT from looking at the code (disclaimer: I am not a C programmer by profession), it looks like writes to chunks that are being compacted or moved will go to the new location, not the old one, but writes to chunks which aren't being touched by the resize currently will just go to where the chunk is currently.  Based on this, lowering the amount of traffic to the FS could probably speed things up a bit, but it likely won't help much.
>>
>> I hoped that this is the strategy implemented, otherwise it would end up in an infinite cat-and-mouse game. ;)
>>
>>>>> (Background info: we’re migrating large volumes from btrfs to xfs
>>>>> and can only do this step by step: copying some data, shrinking the
>>>>> btrfs volume, extending the xfs volume, rinse repeat. If someone
>>>>> should have any suggestions to speed this up and not having to think
>>>>> in terms of _months_ then I’m all ears.)
>>>>
>>>>  All I can suggest is to move some unused data off the volume and do
>>>> it in fewer larger steps. Sorry.
>>> Same.
>>>
>>> The other option though is to just schedule a maintenance window, nuke the old FS, and restore from a backup.  If you can afford to take the system off-line temporarily, this will almost certainly go faster (assuming you have a reasonably fast means of restoring backups).
>>
>> Well. This is the backup. ;)
>
> One strategy that does come to mind: we’re converting our backup from a system that uses reflinks to a non-reflink based system. We can convert this in place so this would remove all the reflink stuff in the existing filesystem and then we maybe can do the FS conversion faster when this isn’t an issue any longer. I think I’ll
One other thing that I just thought of:
For a backup system, assuming some reasonable thinning system is used 
for the backups, I would personally migrate things slowly over time by 
putting new backups on the new filesystem, and shrinking the old 
filesystem as the old backups there get cleaned out.  Unfortunately, 
most backup software I've seen doesn't handle this well, so it's not all 
that easy to do, but it does save you from having to migrate data off of 
the old filesystem, and means you don't have to worry as much about the 
resize of the old FS taking forever.
