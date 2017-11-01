Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:55198 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752066AbdKAMWC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Nov 2017 08:22:02 -0400
Received: by mail-io0-f179.google.com with SMTP id e89so5551011ioi.11
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Nov 2017 05:22:02 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: Dave <davestechshop@gmail.com>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Peter Grandi <pg@btrfs.list.sabi.co.uk>
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
 <pan$a362c$5b92cac0$d2d78b7f$25ff3b3a@cox.net>
 <CAH=dxU6f_DunAsOqKQTXKp469bOaLCiqOMuSE0T3QYqc9CqFNQ@mail.gmail.com>
 <23033.512.820691.680916@tree.ty.sabi.co.uk>
 <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9e274506-9780-bb74-8ba0-e5fa6c9663c3@gmail.com>
Date: Wed, 1 Nov 2017 08:21:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAH=dxU7aNg+VTeQFk-9Tk4yzPemsgL1E0iqSFXFQOxM8=ATDFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-31 20:37, Dave wrote:
> On Tue, Oct 31, 2017 at 7:06 PM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
>>
>> Also nothing forces you to defragment a whole filesystem, you
>> can just defragment individual files or directories by using
>> 'find' with it.
> 
> Thanks for that info. When defragmenting individual files on a BTRFS
> filesystem with COW, I assume reflinks between that file and all
> snapshots are broken. So if there are 30 snapshots on that volume,
> that one file will suddenly take up 30 times more space... Is that
> correct? Or are the reflinks only broken between the live file and the
> latest snapshot? Or is it something between, based on how many times
> the file has changed?
Only that file will be split, all the other reflinks will be preserved, 
so it will only take up twice the space in your example.  Reflinks are 
at the block level, and don't have a single origin point where they can 
all be broken at once.  It's just like having multiple hardlinks to a 
file, and then replacing one of them via a rename.  The rename will 
break _that_ hardlink, but not any of the others.  In fact, the simplest 
way to explain reflinks is block-level hard links that automatically 
break when the block is updated.
> 
>>
>> My top "$HOME" fragmented files are the aKregator RSS feed
>> databases, usually a few hundred fragments each, and the
>> '.sqlite' files for Firefox. Occasionally like just now I do
>> this:
>>
>>    tree$  sudo filefrag .firefox/default/*.sqlite | sort -t: -k 2n | tail -4
>>    .firefox/default/cleanup.sqlite: 43 extents found
>>    .firefox/default/content-prefs.sqlite: 67 extents found
>>    .firefox/default/formhistory.sqlite: 87 extents found
>>    .firefox/default/places.sqlite: 3879 extents found
>>
>>    tree$  sudo btrfs fi defrag .firefox/default/*.sqlite
>>
>>    tree$  sudo filefrag .firefox/default/*.sqlite | sort -t: -k 2n | tail -4
>>    .firefox/default/webappsstore.sqlite: 1 extent found
>>    .firefox/default/favicons.sqlite: 2 extents found
>>    .firefox/default/kinto.sqlite: 2 extents found
>>    .firefox/default/places.sqlite: 44 extents found
> 
> That's a very helpful example.
> 
> Can you also give an example of using find, as you suggested above?
> I'm generally familiar with using find to execute specific commands,
> but an example is appreciated in this case.
> 
>>> 2. Put $HOME/.cache on a separate BTRFS subvolume that is mounted nocow -- it will NOT be snapshotted
> 
>> Also, you can declare the '.firefox/default/' directory to be NOCOW, and that "just works".
> 
> The cache is in a separate location from the profiles, as I'm sure you
> know.  The reason I suggested a separate BTRFS subvolume for
> $HOME/.cache is that this will prevent the cache files for all
> applications (for that user) from being included in the snapshots. We
> take frequent snapshots and (afaik) it makes no sense to include cache
> in backups or snapshots. The easiest way I know to exclude cache from
> BTRFS snapshots is to put it on a separate subvolume. I assumed this
> would make several things related to snapshots more efficient too.
Yes, it will, and it will save space long-term as well since 
$HOME/.cache is usually the most frequently modified location in $HOME. 
In addition to not including this in the snapshots, it may also improve 
performance.  Each subvolume is it's own tree, with it's own locking, 
which means that you can generally improve parallel access performance 
by splitting the workload across multiple subvolumes.  Whether it will 
actually provide any real benefit in that respect is heavily dependent 
on the exact workload however, but it won't hurt performance.
> 
> As far as the Firefox profile being declared NOCOW, as soon as we take
> the first snapshot, I understand that it will become COW again. So I
> don't see any point in making it NOCOW.When snapshotting NOCOW files, exactly one COW operation happens for 
each block as it gets written.  In your case, this may not matter (most 
people don't change settings on a sub-hourly basis), but in cases where 
changes are very frequent relative to snapshots, it can have a big 
impact to only COW once instead of all the time.
> 
> Thanks for your reply. I appreciate any other feedback or suggestions.
> 
> Background: I'm not sure why our Firefox performance is so terrible
> but here's my original post from Sept 20. (I could repost the earlier
> replies too if needed.) I've been waiting to have a window of
> opportunity to try to fix our Firefox performance again, and now I
> have that chance.
> 
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
> read the answers before asking.
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
> 
> Furthermore, on the same BTRFS Wiki page, it mentions the performance
> penalties of many snapshots. I am keeping 30 to 50 snapshots of the
> volume that contains the Firefox profile.
> 
> Would these two things be enough to turn top-of-the-line hardware into
> a mediocre-preforming desktop system? (The system performs fine on
> benchmarks -- it's real life usage, particularly with Firefox where it
> is disappointing.)
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

