Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:53463 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdITLq6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 07:46:58 -0400
Received: by mail-io0-f176.google.com with SMTP id q11so3763103ioe.10
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 04:46:58 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6ab6ffd8-a556-800d-b812-e5361b13ea8d@gmail.com>
Date: Wed, 20 Sep 2017 07:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-20 02:38, Dave wrote:
>> On Thu 2017-08-31 (09:05), Ulli Horlacher wrote:
>>> When I do a
>>> btrfs filesystem defragment -r /directory
>>> does it defragment really all files in this directory tree, even if it
>>> contains subvolumes?
>>> The man page does not mention subvolumes on this topic.
>>
>> No answer so far :-(
>>
>> But I found another problem in the man-page:
>>
>>   Defragmenting with Linux kernel versions < 3.9 or >= 3.14-rc2 as well as
>>   with Linux stable kernel versions >= 3.10.31, >= 3.12.12 or >= 3.13.4
>>   will break up the ref-links of COW data (for example files copied with
>>   cp --reflink, snapshots or de-duplicated data). This may cause
>>   considerable increase of space usage depending on the broken up
>>   ref-links.
>>
>> I am running Ubuntu 16.04 with Linux kernel 4.10 and I have several
>> snapshots.
>> Therefore, I better should avoid calling "btrfs filesystem defragment -r"?
>>
>> What is the defragmenting best practice?
>> Avoid it completly?
> 
> My question is the same as the OP in this thread, so I came here to
> read the answers before asking. However, it turns out that I still
> need to ask something. Should I ask here or start a new thread? (I'll
> assume here, since the topic is the same.)
> 
> Based on the answers here, it sounds like I should not run defrag at
> all. However, I have a performance problem I need to solve, so if I
> don't defrag, I need to do something else.
> 
> Here's my scenario. Some months ago I built an over-the-top powerful
> desktop computer / workstation and I was looking forward to really
> fantastic performance improvements over my 6 year old Ubuntu machine.
> I installed Arch Linux on BTRFS on the new computer (on an SSD). To my
> shock, it was no faster than my old machine. I focused a lot on
> Firefox performance because I use Firefox a lot and that was one of
> the applications in which I was most looking forward to better
> performance.
> 
> I tried everything I could think of and everything recommended to me
> in various forums (except switching to Windows) and the performance
> remained very disappointing.
Switching to Windows won't help any more than switching to ext4 would. 
If you were running Chrome, it might (Chrome actually has better 
performance on Windows than Linux by a small margin last time I 
checked), but Firefox gets pretty much the same performance on both 
platforms.
> 
> Then today I read the following:
> 
>      Gotchas - btrfs Wiki
>      https://btrfs.wiki.kernel.org/index.php/Gotchas
> 
>      Fragmentation: Files with a lot of random writes can become
> heavily fragmented (10000+ extents) causing excessive multi-second
> spikes of CPU load on systems with an SSD or large amount a RAM. On
> desktops this primarily affects application databases (including
> Firefox). Workarounds include manually defragmenting your home
> directory using btrfs fi defragment. Auto-defragment (mount option
> autodefrag) should solve this problem.
> 
> Upon reading that I am wondering if fragmentation in the Firefox
> profile is part of my issue. That's one thing I never tested
> previously. (BTW, this system has 256 GB of RAM and 20 cores.)
Almost certainly.  Most modern web browsers are brain-dead and insist on 
using SQLite databases (or traditional DB files) for everything, 
including the cache, and the usage for the cache in particular kills 
performance when fragmentation is an issue.
> 
> Furthermore, on the same BTRFS Wiki page, it mentions the performance
> penalties of many snapshots. I am keeping 30 to 50 snapshots of the
> volume that contains the Firefox profile.
> 
> Would these two things be enough to turn top-of-the-line hardware into
> a mediocre-preforming desktop system? (The system performs fine on
> benchmarks -- it's real life usage, particularly with Firefox where it
> is disappointing.)
Even ignoring fragmentation and reflink issues (it's reflinks, not 
snapshots that are the issue, snapshots just have tons of reflinks), 
BTRFS is slower than ext4 or XFS simply because of the fact that it's 
doing way more work.  The difference should have limited impact on an 
SSD if you get a handle on the other issues though.
> 
> After reading the info here, I am wondering if I should make a new
> subvolume just for my Firefox profile(s) and not use COW and/or not
> keep snapshots on it and mount it with the autodefrag option.
> 
> As part of this strategy, I could send snapshots to another disk using
> btrfs send-receive. That way I would have the benefits of snapshots
> (which are important to me), but by not keeping any snapshots on the
> live subvolume I could avoid the performance problems.
> 
> What would you guys do in this situation?
Personally?  Use Chrome or Chromium and turn on the simple cache backend 
(chrome://flags/#enable-simple-cache-backend) which doesn't have issues 
with fragmentation because it doesn't use a database file to store the 
cache and lets the filesystem handle the allocations.  The difference in 
performance in Chrome itself from flipping this switch is pretty amazing 
to be honest.  They're also faster than Firefox in general in my 
experience, but that's a separate discussion.

 From a practical perspective though, if you're using the profile sync 
feature in Firefox, you don't need the checksumming of BTRFS and 
shouldn't need snapshots either (at least, not for that), so through 
some symlink trickery you could put your Firefox profile on another 
filesystem (same for Thunderbird, which has the same issues).

Alternatively, if you can afford to have your space usage effectively 
multiplied by the number of snapshots, defragment the FS after every 
snapshot.  That will deal both with the performance issues from 
fragmentation, and the performance issues from reflinks (because defrag 
breaks reflinks).
