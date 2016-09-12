Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34960 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbcILMUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:20:25 -0400
Received: by mail-oi0-f44.google.com with SMTP id d191so93098944oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 05:20:25 -0700 (PDT)
Subject: Re: Is stability a joke?
To: Hugo Mills <hugo@carfax.org.uk>, Waxhead <waxhead@online.no>,
        Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no> <57D53E3A.1030106@online.no>
 <15194548.valIGHoaRh@merkaba> <2682119.DRdtbgPpNZ@merkaba>
 <57D55072.2010701@online.no> <20160911130221.GE7138@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <be04c51d-c35d-39fe-c5f7-a7ab13d72cc5@gmail.com>
Date: Mon, 12 Sep 2016 08:20:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160911130221.GE7138@carfax.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-11 09:02, Hugo Mills wrote:
> On Sun, Sep 11, 2016 at 02:39:14PM +0200, Waxhead wrote:
>> Martin Steigerwald wrote:
>>> Am Sonntag, 11. September 2016, 13:43:59 CEST schrieb Martin Steigerwald:
>>>>>> Thing is: This just seems to be when has a feature been implemented
>>>>>> matrix.
>>>>>> Not when it is considered to be stable. I think this could be done with
>>>>>> colors or so. Like red for not supported, yellow for implemented and
>>>>>> green for production ready.
>>>>> Exactly, just like the Nouveau matrix. It clearly shows what you can
>>>>> expect from it.
>>> I mentioned this matrix as a good *starting* point. And I think it would be
>>> easy to extent it:
>>>
>>> Just add another column called "Production ready". Then research / ask about
>>> production stability of each feature. The only challenge is: Who is
>>> authoritative on that? I´d certainly ask the developer of a feature, but I´d
>>> also consider user reports to some extent.
>>>
>>> Maybe thats the real challenge.
>>>
>>> If you wish, I´d go through each feature there and give my own estimation. But
>>> I think there are others who are deeper into this.
>> That is exactly the same reason I don't edit the wiki myself. I
>> could of course get it started and hopefully someone will correct
>> what I write, but I feel that if I start this off I don't have deep
>> enough knowledge to do a proper start. Perhaps I will change my mind
>> about this.
>
>    Given that nobody else has done it yet, what are the odds that
> someone else will step up to do it now? I would say that you should at
> least try. Yes, you don't have as much knowledge as some others, but
> if you keep working at it, you'll gain that knowledge. Yes, you'll
> probably get it wrong to start with, but you probably won't get it
> *very* wrong. You'll probably get it horribly wrong at some point, but
> even the more knowledgable people you're deferring to didn't identify
> the problems with parity RAID until Zygo and Austin and Chris (and
> others) put in the work to pin down the exact issues.
FWIW, here's a list of what I personally consider stable (as in, I'm 
willing to bet against reduced uptime to use this stuff on production 
systems at work and personal systems at home):
1. Single device mode, including DUP data profiles on single device 
without mixed-bg.
2. Multi-device raid0, raid1, and raid10 profiles with symmetrical 
devices (all devices are the same size).
3. Multi-device single profiles with asymmetrical devices.
4. Small numbers (max double digit) of snapshots, taken at infrequent 
intervals (no more than once an hour).  I use single snapshots regularly 
to get stable images of the filesystem for backups, and I keep hourly 
ones of my home directory for about 48 hours.
5. Subvolumes used to isolate parts of a filesystem from snapshots.  I 
use this regularly to isolate areas of my filesystems from backups.
6. Non-incremental send/receive (no clone source, no parent's, no 
deduplication).  I use this regularly for cloning virtual machines.
7. Checksumming and scrubs using any of the profiles I've listed above.
8. Defragmentation, including autodefrag.
9. All of the compat_features, including no-holes and skinny-metadata.

Things I consider stable enough that I'm willing to use them on my 
personal systems but not systems at work:
1. In-line data compression with compress=lzo.  I use this on my laptop 
and home server system.  I've never had any issues with it myself, but I 
know that other people have, and it does seem to make other things more 
likely to have issues.
2. Batch deduplication.  I only use this on the back-end filesystems for 
my personal storage cluster, and only because I have multiple copies as 
a result of GlusterFS on top of BTRFS.  I've not had any significant 
issues with it, and I don't remember any reports of data loss resulting 
from it, but it's something that people should not be using if they 
don't understand all the implications.

Things that I don't consider stable but some people do:
1. Quotas and qgroups.  Some people (such as SUSE) consider these to be 
stable.  There are a couple of known issues with them still however 
(such as returning the wrong errno when a quota is hit (should be 
returning -EDQUOT, instead returns -ENOSPC)).
2. RAID5/6.  There are a few people who use this, but it's generally 
agreed to be unstable.  There are still at least 3 known bugs which can 
cause complete loss of a filesystem, and there's also a known issue with 
rebuilds taking insanely long, which puts data at risk as well.
3. Multi device filesystems with asymmetrical devices running raid0, 
raid1, or raid10.  The issue I have here is that it's much easier to hit 
errors regarding free space than a reliable system should be.  It's 
possible to avoid with careful planning (for example, a 3 disk raid1 
profile with 1 disk exactly twice the size of the other two will work 
fine, albeit with more load on the larger disk).

There's probably some stuff I've missed, but that should cover most of 
the widely known features.  The problem ends up becoming that what's 
'stable' depends a lot on what you consider stable.  SUSE obviously 
considers qgroups stable (they're enabled by default in all current SUSE 
distributions), but I wouldn't be willing to use them, and I'd be 
willing to bet most of the developers wouldn't either.

As far as what I consider stable, I've been using just about everything 
I listed above in the first two lists for the past year or so with no 
issues that were due to BTRFS itself (I've had some hardware issues, but 
BTRFS actually saved my data in those cases).  I'm also not a typical 
user though, both in terms of use cases (I use LVM for storing VM images 
and then set ACL's on the device nodes so I can use them as a regular 
user, and I do regular maintenance on all the databases on my systems), 
and relative knowledge of the filesystem (I've fixed BTRFS filesystems 
by hand with a hex editor before, not something I ever want to do again, 
but I know I can do it if I need to), and both of those impact my 
confidence in using some features.
>
>    So I'd strongly encourage you to set up and maintain the stability
> matrix yourself -- you have the motivation at least, and the knowledge
> will come with time and effort. Just keep reading the mailing list and
> IRC and bugzilla, and try to identify where you see lots of repeated
> problems, and where bugfixes in those areas happen.
Exactly this.  Most people don't start working on something for the 
first time with huge amounts of preexisting knowledge about it.  Heaven 
knows I didn't both when I first started using Linux, and when I started 
using BTRFS.  One of the big advantages of open source in this respect 
though is that you generally can find people willing to help you without 
much effort, and there's generally relatively good support.

As far as documentation though, we [BTRFS] really do need to get our act 
together.  It really doesn't look good to have most of the best 
documentation be in the distro's wikis instead of ours.  I'm not trying 
to say the distros shouldn't be documenting BTRFS, but the point at 
which Debian (for example) has better documentation of the upstream 
version of BTRFS than the upstream project itself does, that starts to 
look bad.
>
>    So, go for it. You have a lot to offer the community.
>
>    Hugo.
>
>>> I do think for example that scrubbing and auto raid repair are stable, except
>>> for RAID 5/6. Also device statistics and RAID 0 and 1 I consider to be stable.
>>> I think RAID 10 is also stable, but as I do not run it, I don´t know. For me
>>> also skinny-metadata is stable. For me so far even compress=lzo seems to be
>>> stable, but well for others it may not.
>>>
>>> Since what kernel version? Now, there you go. I have no idea. All I know I
>>> started BTRFS with Kernel 2.6.38 or 2.6.39 on my laptop, but not as RAID 1 at
>>> that time.
>>>
>>> See, the implementation time of a feature is much easier to assess. Maybe
>>> thats part of the reason why there is not stability matrix: Maybe no one
>>> *exactly* knows *for sure*. How could you? So I would even put a footnote on
>>> that "production ready" row explaining "Considered to be stable by developer
>>> and user oppinions".
>>>
>>> Of course additionally it would be good to read about experiences of corporate
>>> usage of BTRFS. I know at least Fujitsu, SUSE, Facebook, Oracle are using it.
>>> But I don´t know in what configurations and with what experiences. One Oracle
>>> developer invests a lot of time to bring BTRFS like features to XFS and RedHat
>>> still favors XFS over BTRFS, even SLES defaults to XFS for /home and other non
>>> /-filesystems. That also tells a story.
>>>
>>> Some ideas you can get from SUSE releasenotes. Even if you do not want to use
>>> it, it tells something and I bet is one of the better sources of information
>>> regarding your question you can get at this time. Cause I believe SUSE
>>> developers invested some time to assess the stability of features. Cause they
>>> would carefully assess what they can support in enterprise environments. There
>>> is also someone from Fujitsu who shared experiences in a talk, I can search
>>> the URL to the slides again.
>> By all means, SUSE's wiki is very valuable. I just said that I
>> *prefer* to have that stuff on the BTRFS wiki and feel that is the
>> right place for it.
>>>
>>> I bet Chris Mason and other BTRFS developers at Facebook have some idea on
>>> what they use within Facebook as well. To what extent they are allowed to talk
>>> about it… I don´t know. My personal impression is that as soon as Chris went
>>> to Facebook he became quite quiet. Maybe just due to being busy. Maybe due to
>>> Facebook being concerned much more about the privacy of itself than of its
>>> users.
>>>
>>> Thanks,
>>
>

