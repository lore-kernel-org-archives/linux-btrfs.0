Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42765 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdHZBg6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 21:36:58 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dlQ1i-0001Ne-HX
        for linux-btrfs@vger.kernel.org; Sat, 26 Aug 2017 03:36:42 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: status of inline deduplication in btrfs
Date: Sat, 26 Aug 2017 01:36:35 +0000 (UTC)
Message-ID: <pan$e34b7$dc9b9508$835301e3$9a80c4d6@cox.net>
References: <CAP9W88g3Pr=JYqj=QOKpeP=6uKaQkXsx9xegefeJsZ+wApiZ9g@mail.gmail.com>
        <7e12fa55-d01a-6c02-f798-2b63cf3b4a6d@jp.fujitsu.com>
        <CAP9W88gfFUj3QBjmztDjYamR9MKSh7Gsv66X7vJ-M9FNq3F=eA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

shally verma posted on Fri, 25 Aug 2017 23:01:10 +0530 as excerpted:

> On Thu, Aug 24, 2017 at 6:39 AM, Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> wrote:
>> On 2017/08/23 23:52, shally verma wrote:
>>> HI
>>>
>>> Through btrfs wiki, I got to know about inline patch and this git
>>> location https://github.com/adam900710/linux but I am not sure what's
>>> progress and status on this. Could any one please confirm what is the
>>> status of inline  deduplication into btrfs and if it is the correct
>>> location to see its support?
>>
>> Lu Fengqi has posted the latest patchset (v14.4).
>> https://marc.info/?l=linux-btrfs&m=149984943031184&w=2
>>
>> Unfortunately, it has not been committed yet.
>>
> Thanks for your response, I will go through patches. Could you also help
> with answer to this question " what's progress and status on this".  Do
> we have any test run reports that tell about its stability levels,
> performance metric and other known issues?
> and possibly a roadmap of commit?

I'm not a dev, just a btrfs user and list regular myself, and don't 
remember seeing a mainline-merge roadmap, tho dedup's not part of my own 
use-case so I could have missed it.

But I can answer some of the other questions based on what I've seen on-
list...

First, while I don't have a merge-roadmap, I do know there's some major 
dev-sponsoring corporate interest in dedup, so the feature should be on 
the fast-track to merge, and it should get pretty good testing and 
bugfixing as well.

That said, as any new feature, it's likely to take a few kernel cycles 
after merge to settle down, and my own rule-of-thumb recommendation for 
new feature stability is wait at least 3-6 kernel cycles after merge 
before considering a feature for anything but testing, and then, check 
the list for current status before relying on it.

It's worth noting that with raid56, after feature-completion in 3.19 
(IIRC), it took two kernel cycles to work out the immediate bugs, and 
only at about 5-6 cycles, basically a year later, did the alarm bells 
really start going off that there were still very serious problems with 
it, problems that only very recently (4.12 IIRC) have been fixed, and 
even now after the fix, due to btrfs implementation peculiarities, the 
infamous e parity-raid write hole negates some of the btrfs data 
checksumming and integrity features that are otherwise major advantages 
to btrfs, a problem that's going to require some tweaks to the 
implementation to fix.

So basically, wait a year after merge and ask what the status is then if 
your use-case can't afford either live-failover (to something /not/ using 
the feature) or the down-time to restore from backup.  Because a year out 
is sometimes how long it takes for normally hidden but potentially quite 
nasty bugs to show up...

As for performance...

The in-band dedup is designed to be fast, but with limited memory usage,  
rather than slow and thorough.  It won't catch all dups, only those where 
the original data extent has been recently used enough for the hashes to 
be in the in-memory-inline-dedup-cache, so it's opportunistic and should 
be very close to the same speed as non-deduped IO.  This contrasts with 
the out-of-band dedup, which is far more through, relying on a larger on-
storage cache, thus potentially making it slower but much more likely to 
catch dups.

There are two big caveats, both related to the way dedup works its magic, 
via reflinks.  The first, fragmentation due to the block-based dedup, 
should be easily anticipated by anyone familiar with block based 
filesystems and the hows and whys of fragmentation in general, but 
fragmentation in general tends to be more of an issue on COW-based 
filesystems, particularly where the write pattern includes heavy file-
internal rewrites, and dedup has the potential to exacerbate that even 
further, since it may well pick blocks from multiple files and extents if 
they happen to be duplicated blocks, used recently enough to still be in-
cache.

Of course you can manually defrag, but that breaks the reflinks and thus 
re-duplicates the data (regardless of it was deduped due to dedup or to 
snapshotting).  The autodefrag mount option should help at less cost than 
manual defrag, because it only triggers during write and will only try to 
COW somewhat larger extents than the single block that would otherwise be 
COWed if that was all that was rewritten, but it'll still affect dedup 
efficiency, just less so than a manual defrag.  So it's a trade-off.

The second has to do with btrfs scaling issues due to reflinking, which 
of course is the operational mechanism for both snapshotting and dedup.  
Snapshotting of course reflinks the entire subvolume, so it's reflinking 
on a /massive/ scale.  While normal file operations aren't affected much, 
btrfs maintenance operations such as balance and check scale badly enough 
with snapshotting (due to the reflinking) that keeping the number of 
snapshots per subvolume under 250 or so is strongly recommended, and 
keeping them to double-digits or even single-digits is recommended if 
possible.

It's worth noting that btrfs quotas increase the scaling issues even 
more, and bring snapshot deletion into the bad scaling mix.  Disabling 
quotas if you don't actually need them is strongly recommended, and if 
they're enabled in general, disabling them temporarily for snapshot 
deletion or balance will speed them up dramatically.

Dedup works by reflinking as well, but its effect on btrfs maintenance 
will be far more variable, depending of course on how effective the 
deduping, and thus the reflinking, is.  But considering that snapshotting 
is effectively 100% effective deduping of the entire subvolume (until the 
snapshot and active copy begin to diverge, at least), that tends to be 
the worst case, so figuring a full two-copy dedup as equivalent to one 
snapshot is a reasonable estimate of effect.  If dedup only catches 10%, 
only once, than it would be 10% of a snapshot's effect.  If it's 10% but 
there's 10 duplicated instances, that's the effect of a single snapshot.  
Assuming of course that the dedup domain is the same as the subvolume 
that's being snapshotted.

Of course if you have 1000 near 100% duplicated instances, you'll run 
into btrfs maintenance scaling trouble, just the same as you would with 
1000 snapshots...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

