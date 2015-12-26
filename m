Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35182 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbLZUdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 15:33:39 -0500
Received: by mail-ig0-f182.google.com with SMTP id to4so125012058igc.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 12:33:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <28201.1451160163@ccs.covici.com>
References: <16107.1451037790@ccs.covici.com>
	<CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
	<18552.1451078098@ccs.covici.com>
	<CAJCQCtTQ-73RbohA9wdrttj_uSnF5f8x1Opa0a6O2ZF-5NVqhQ@mail.gmail.com>
	<5117.1451114951@ccs.covici.com>
	<pan$a2c8c$6af1fa21$56a24ebc$40b50ca8@cox.net>
	<25045.1451129900@ccs.covici.com>
	<CAJCQCtQ6y2h5k4cnGQn5Fk67HGqWnvhrqASowhjNEe-vV3Wprg@mail.gmail.com>
	<23484.1451157722@ccs.covici.com>
	<CAJCQCtQiTYfV=bEikXgeT1K2xOR+0j37=0a=hu5qBcu+t--GzA@mail.gmail.com>
	<28201.1451160163@ccs.covici.com>
Date: Sat, 26 Dec 2015 13:33:38 -0700
Message-ID: <CAJCQCtSp=EiMYSd5x5UL_QT7mGuWMDk2krLcp+howro2QhA-8w@mail.gmail.com>
Subject: Re: btrfs problems on new file system
From: Chris Murphy <lists@colorremedies.com>
To: John Covici <covici@ccs.covici.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 26, 2015 at 1:02 PM,  <covici@ccs.covici.com> wrote:
> Chris Murphy <lists@colorremedies.com> wrote:
>
>> On Sat, Dec 26, 2015 at 12:22 PM,  <covici@ccs.covici.com> wrote:
>> > Chris Murphy <lists@colorremedies.com> wrote:
>> >
>> >> On Sat, Dec 26, 2015 at 4:38 AM,  <covici@ccs.covici.com> wrote:
>> >> > Duncan <1i5t5.duncan@cox.net> wrote:
>> >> >
>> >> >> covici posted on Sat, 26 Dec 2015 02:29:11 -0500 as excerpted:
>> >> >>
>> >> >> > Chris Murphy <lists@colorremedies.com> wrote:
>> >> >> >
>> >> >> >> If you can post the entire dmesg somewhere that'd be useful. MUAs tend
>> >> >> >> to wrap that text and make it unreadable on list. I think the problems
>> >> >> >> with your volume happened before the messages, but it's hard to say.
>> >> >> >> Also, a generation of nearly 5000 is not that new?
>> >> >> >
>> >> >> > The file system was only a few days old.  It was on an lvm volume group
>> >> >> > which consisted of two ssd drives, so I am not sure what you are saying
>> >> >> > about lvm cache -- how could I do anything different?
>> >> >> >
>> >> >> >> On another thread someone said you probably need to specify the device
>> >> >> >> to mount when using Btrfs and lvmcache? And the device to specify is
>> >> >> >> the combined HDD+SSD logical device, for lvmcache that's the "cache
>> >> >> >> LV", which is the OriginLV + CachePoolLV. If Btrfs decides to mount the
>> >> >> >> origin, it can result in corruption.
>> >> >> >
>> >> >> > See above.
>> >> >>
>> >> >> I think he mixed up two threads and thought you were running lvm-cache,
>> >> >> not just regular lvm, which should be good unless you're exposing lvm
>> >> >> snapshots and thus letting btrfs see multiple supposed UUIDs that aren't
>> >> >> actually universal.  Since btrfs is multi-device and uses the UUID to
>> >> >> track which devices belong to it (because they're _supposed_ to be
>> >> >> universally unique, it's even in the _name_!), if it sees the same UUID
>> >> >> it'll consider it part of the same filesystem, thus potentially causing
>> >> >> corruption if it's a snapshot or something that's not actually supposed
>> >> >> to be part of the (current) filesystem.
>> >> >
>> >> > I found a few more log entries, perhaps these may be helpful to track
>> >> > this down, or maybe prevent the filesystem from going read-only.
>> >>
>> >> No, you need to post the entire dmesg. The "cut here" part is maybe
>> >> useful for a developer diagnosing Btrfs's response to the problem, but
>> >> the problem, or the pre-problem, happened before this.
>> >
>> > It would be a 20meg file, if I were to post the whole file.  but I can
>> > tell you, no hardware errors at any time.
>>
>> The kernel is tainted, looks like a proprietary kernel module, so you
>> have to have very good familiarity with the workings of that module to
>> know whether it might affect what's going on, or you'd have to retest
>> without that kernel module.
>>
>> Anyway, asking for the whole dmesg isn't arbitrary, it saves times
>> having to ask for more later. The two things you've provided so far
>> aren't enough, any number of problems could result in those messages.
>> So my suggestion is when people ask for something, provide it or don't
>> provide it, but don't complain about what they're asking for. The
>> output from btrfs-debug-tree might be several hundred MB. The output
>> from btrfs-image might be several GB. So if you're not willing to
>> provide 100kB, let alone 20MB, of kernel messages that might give some
>> hint what's going on, the resistance itself is off putting. It's like
>> having to pull your own loose tooth for you, no one really wants to do
>> that.
>
> How far back do you want to go in terms of the messages?

The kernel log buffer isn't that big by default which is why I asked
for the entire dmesg, not the entire /var/log/messages file. But if
you can reproduce the problem with a new boot, that'd certainly make
the kernel log shorter and cleaner if that's the concern.

The errno -95 is itself sufficiently rare there's no possible way to
answer your question because I don't know anyone would even know what
they're looking for until they find it. It's even possible it won't be
found by looking at kernel messages.

How was the fs created? Conversion? If mkfs.btrfs, what version of
progs and what options were used to create it?  And what was happening
at the time of the first errno=-95?

-- 
Chris Murphy
