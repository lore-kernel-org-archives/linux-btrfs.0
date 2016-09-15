Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:38276 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754591AbcIOLyd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 07:54:33 -0400
Received: by mail-it0-f47.google.com with SMTP id n143so70993109ita.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 04:54:32 -0700 (PDT)
Subject: Re: stability matrix
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net>
 <c58cd350-a1e8-7d1c-cf8c-84f7f0c05682@mendix.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b21c740b-5d71-7edd-f2fd-1ba6ea156dba@gmail.com>
Date: Thu, 15 Sep 2016 07:54:26 -0400
MIME-Version: 1.0
In-Reply-To: <c58cd350-a1e8-7d1c-cf8c-84f7f0c05682@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-15 05:49, Hans van Kranenburg wrote:
> On 09/15/2016 04:14 AM, Christoph Anton Mitterer wrote:
>> Hey.
>>
>> As for the stability matrix...
>>
>> In general:
>> - I think another column should be added, which tells when and for
>>   which kernel version the feature-status of each row was
>>   revised/updated the last time and especially by whom.
>>   If a core dev makes a statement on a particular feature, this
>>   probably means much more, than if it was made by "just" a list
>>   regular.
>>   And yes I know, in the beginning it already says "this is for 4.7"...
>>   but let's be honest, it's pretty likely when this is bumped to 4.8
>>   that not each and every point will be thoroughly checked again.
>> - Optionally even one further column could be added, that lists bugs
>>   where the specific cases are kept record of (if any).
>> - Perhaps a 3rd Status like "eats-your-data" which is worse than
>>   critical, e.g. for things were it's known that there is a high
>>   chance for still getting data corruption (RAID56?)
>
> About the "for 4.7" issue... The Status page could have an extra column,
> which for every OK labeled row lists the first version (kernel.org x.y.0
> release) it's OK for.
>
> The bugs make it more complicated.
>
> * Feature A is labeled OK in kernel 5.0
> * During development of kernel 8-rc, an eat my data bug is fixed. The OK
> for this feature in the table is bumped to 8.0?
> * kernel 5 is EOL
> * kernel 6 is still supported, and the fix is applied to 6.12
> * then there's distros which have their own old kernels, applying fixes
> on them whenever they like, for example 5.6-distro4 which is leading its
> own life
>
> "Normal" users are using distro kernels. They shouldn't be panicing
> about their data if they're running 6.14 or 5.6-distro4, but the OK in
> the table is bumped to 8.0 because of the serious bugs.
>
> At least the official kernels should be tracked in the table I think.
>
> Separately, a list of known serious bugs per feature (like the 4 about
> compression, http://www.spinics.net/lists/linux-btrfs/msg58674.html )
> could be listed on another Bugs! page (lots of work) so a user, or
> someone helping the user can see if the listed commits are or aren't
> included in the actual whatever kernel a user is using.
>
> This list of serious bugs could also help disussions that now sound like
> "yeah, there were issues with compression which some time ago got fixed,
> but noone knows what it was and when, so don't use compression".
>
> Many of the commits which fix serious bugs (even if they're only
> triggered in an edge case) have some explanation about how to trigger
> them, like the excellent commit messages of Filipe in the commits
> mentioned above. This helps setting up and maintaining the bug page, and
> helps advanced users to decide if they're hitting the edge case or not
> with their usage pattern.
>
> I'd like to help creating/maintaining this bug overview. A good start
> would be to just crawl through all stable kernels and some distro
> kernels and see which commits show up in fs/btrfs.
>
As of right now, we kind of do have such a page:
https://btrfs.wiki.kernel.org/index.php/Gotchas
It's not really well labeled though, ans it's easy to overlook.

I specifically do not think we should worry about distro kernels though. 
  If someone is using a specific distro, that distro's documentation 
should cover what they support and what works and what doesn't.  Some 
(like Arch and to a lesser extent Gentoo) use almost upstream kernels, 
so there's very little point in tracking them.  Some (like Ubuntu and 
Debian) use almost upstream LTS kernels, so there's little point 
tracking them either.  Many others though (like CentOS, RHEL, and OEL) 
Use forked kernels that have so many back-ported patches that it's 
impossible to track up-date to up-date what the hell they've got.  A 
rather ridiculous expression regarding herding of cats comes to mind 
with respect to the last group.
