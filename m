Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:34310 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756146AbcINL3V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 07:29:21 -0400
Received: by mail-it0-f49.google.com with SMTP id 15so5972013ita.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 04:29:21 -0700 (PDT)
Subject: Re: Filesystem forced to readonly after use
To: Cesar Strauss <cestrauss@gmail.com>, linux-btrfs@vger.kernel.org
References: <a74b20fd-9640-b543-c31c-d475a51dcc57@gmail.com>
 <53969836-4a5a-f842-6156-3f88a78bfc4e@gmail.com>
 <3756c0ee-4f64-7974-932c-0a1615c658c8@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <77342640-d414-5c45-2c0d-06411c827380@gmail.com>
Date: Wed, 14 Sep 2016 07:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <3756c0ee-4f64-7974-932c-0a1615c658c8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-13 16:39, Cesar Strauss wrote:
> On 13-09-2016 16:49, Austin S. Hemmelgarn wrote:
>> I'd be kind of curious to see the results from btrfs check run without
>> repair, but I doubt that will help narrow things down any further.
>
> Attached.
>
>>
>> As of right now, the absolute first thing I'd do is check your logs to
>> see if you can find any indication of errors from the disk itself.  I
>> don't think it's likely, but it's worth checking.
>
> Will do.
>
>> The couple of lines just before the crash in the attached kernel log
>> would indicate to me that some of the metadata is corrupted.  There are
>> two likely possibilities for how that happened:
>> 1. Running with no extra space for new chunks to be allocated is not a
>> common use case, so it's not well tested, and it wouldn't surprise me if
>> some accounting falls apart in that situation.
>
> Indeed. I periodically remove old snapshots and check for disk space,
> bit I guess I ran a bit too near the limit this time.
In theory, BTRFS _should_ work in such a situation.  In practice, you 
get all kinds of odd behaviors.  In your case, you still have a 
reasonable amount of free space in both data and metadata chunks, so it 
isn't quite as bad as it could be (trying to get a FS working again when 
you have zero space in any chunks is a serious pain).
>
>> 2. You might have bad RAM or a bad PSU.  This is the second thing you
>> should check after checking to see if the disk is OK, as either will
>> likely cause any repair attempts to make things worse.  RAM is pretty
>> easy to check, but for a PSU you need a proper testing device.  You can
>> get such a device on Amazon or similar sites for about 25USD, and it's
>> generally worth having around for troubleshooting.
>
> Understood.
>
> This notebook has occasional failures when resuming from hibernation. I
> suppose, from the point of view of the filesystem, this corresponds to
> an unclean reboot.
Yeah, although it's generally not quite as bad as an unclean reboot 
(default configurations on almost all Linux distros call sync just 
before the actual power off, so you don't have to worry about stuff in 
the write cache being lost).  That said, it can also be worse than an 
unclean reboot depending on when the crash happens.

This brings up a good point though that I forgot, repeated unclean 
shutdowns (or failed resumes) can cause stuff like this to happen.  I 
don't often think about it since I rarely have issues with power loss or 
hard crashes (and I don't use hibernation), so it's not something I 
often remember to mention when helping people with filesystem issues.
>
>>
>> Assuming your disk and RAM are good, the next thing to do would be try
>> and get the filesystem into a more usable state.  The best option for
>> this is to expand the filesystem if possible.  Given that you're running
>> right near capacity, I'd suggest at least 16G of extra space if
>> possible.  If that isn't a viable solution for you, the other option is
>> to delete some of the oldest snapshots (Ideally enough that you have at
>> least a few GB of extra space in the data chunks and a few hundred MB in
>> the metadata chunks), then add a 4-8GB device to the FS temporarily (a
>> ramdisk or flash drive works well for this), and run a full balance.  If
>> you're lucky, this will fix any metadata that's messed up, and the
>> system should be usable.  If not, it shouldn't make things any worse,
>> and you probably want to look at btrfs restore to copy out the data to a
>> new filesystem (ideally a bigger one).
>
> I will try this next.
Like Chris mentioned, you probably want to use a different version of 
btrfs-progs.  I hadn't seen that that version was marked to not be used, 
otherwise I would have said something in my first reply.
