Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35851 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbcFJRHs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 13:07:48 -0400
Received: by mail-vk0-f41.google.com with SMTP id g67so105660612vkb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 10:07:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2dac6$9a9c194e$57b6cef4$3686a053@cox.net>
References: <572D0C8B.8010404@mendix.com> <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5758A5F6.4060400@mendix.com> <pan$2dac6$9a9c194e$57b6cef4$3686a053@cox.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 10 Jun 2016 19:07:46 +0200
Message-ID: <CAPmG0jb=+dS+_MLGiSoGk-Sho8tcjrvrOwMSSQnmdHq4THBjVg@mail.gmail.com>
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent reason
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 9, 2016 at 5:41 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Hans van Kranenburg posted on Thu, 09 Jun 2016 01:10:46 +0200 as
> excerpted:
>
>> The next question is what files these extents belong to. To find out, I
>> need to open up the extent items I get back and follow a backreference
>> to an inode object. Might do that tomorrow, fun.
>>
>> To be honest, I suspect /var/log and/or the file storage of mailman to
>> be the cause of the fragmentation, since there's logging from postfix,
>> mailman and nginx going on all day long in a slow but steady tempo.
>> While using btrfs for a number of use cases at work now, we normally
>> don't use it for the root filesystem. And the cases where it's used as
>> root filesystem don't do much logging or mail.
>
> FWIW, that's one reason I have a dedicated partition (and filesystem) for
> logs, here.  (The other reason is that should something go runaway log-
> spewing, I get a warning much sooner when my log filesystem fills up, not
> much later, with much worse implications, when the main filesystem fills
> up!)
>
>> And no, autodefrag is not in the mount options currently. Would that be
>> helpful in this case?
>
> It should be helpful, yes.  Be aware that autodefrag works best with
> smaller (sub-half-gig) files, however, and that it used to cause
> performance issues with larger database and VM files, in particular.

I don't know why you relate filesize and autodefrag. Maybe because you
say '... used to cause ...'.

autodefrag detects random writes and then tries to defrag a certain
range. Its scope size is 256K as far as I see from the code and over
time you see VM images that are on a btrfs fs (CoW, hourly ro
snapshots) having a lot of 256K (or a bit less) sized extents
according to what filefrag reports. I once wanted to try and change
the 256K to 1M or even 4M, but I haven't  come to that.
A 32G VM image would consist of 131072 extents for 256K, 32768 extents
for 1M, 8192 extents for 4M.

> There used to be a warning on the wiki about that, that was recently
> removed, so apparently it's not the issue that it was, but you might wish
> to monitor any databases or VMs with gig-plus files to see if it's going
> to be a performance issue, once you turn on autodefrag.

For very active databases, I don't know what the effects are, with or
without autodefrag ( either on SSD and/or HDD).
At least on HDD-only, so no persistent SSD caching and noautodefrag,
VMs will result in unacceptable performance soon.

> The other issue with autodefrag is that if it hasn't been on and things
> are heavily fragmented, it can at first drive down performance as it
> rewrites all these heavily fragmented files, until it catches up and is
> mostly dealing only with the normal refragmentation load.

I assume you mean that one only gets a performance drop if you
actually do new writes to the fragmented files since autodefrag on. It
shouldn't start defragging by itself AFAIK.

> Of course the
> best way around that is to run autodefrag from the first time you mount
> the filesystem and start writing to it, so it never gets overly
> fragmented in the first place.  For a currently in-use and highly
> fragmented filesystem, you have two choices, either backup and do a fresh
> mkfs.btrfs so you can start with a clean filesystem and autodefrag from
> the beginning, or doing manual defrag.
>
> However, be aware that if you have snapshots locking down the old extents
> in their fragmented form, a manual defrag will copy the data to new
> extents without releasing the old ones as they're locked in place by the
> snapshots, thus using additional space.  Worse, if the filesystem is
> already heavily fragmented and snapshots are locking most of those
> fragments in place, defrag likely won't help a lot, because the free
> space as well will be heavily fragmented.   So starting off with a clean
> and new filesystem and using autodefrag from the beginning really is your
> best bet.

If it is about multi-TB fs, I think most important is to have enough
unfragmented free space available and hopefully at the beginning of
the device if it is flat HDD. Maybe a  balance -ddrange=1M..<20% of
device> can do that, I haven't tried.
