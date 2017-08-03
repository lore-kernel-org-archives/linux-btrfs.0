Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33599 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdHCWAY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 18:00:24 -0400
Received: by mail-wm0-f67.google.com with SMTP id q189so3754217wmd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 15:00:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ce5ca6f1-19ef-3bfc-541b-90d526e29e5c@swiftspirit.co.za>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net> <1501784952.4789.3.camel@scientia.net>
 <fd0875d1-c96c-b1ac-0284-50613af0bd76@gmail.com> <ce5ca6f1-19ef-3bfc-541b-90d526e29e5c@swiftspirit.co.za>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 3 Aug 2017 16:00:22 -0600
Message-ID: <CAJCQCtSCFvPYt_L9WwpMX7PhOLA-0_60miCxtczCWZbVAV8eQw@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 3, 2017 at 2:45 PM, Brendan Hide <brendan@swiftspirit.co.za> wrote:
>
> To counter, I think this is a big problem with btrfs, especially in terms of
> user attrition. We don't need "GUI" tools. At all. But we do need that btrfs
> is self-sufficient enough that regular users don't get burnt by what they
> would view as unexpected behaviour.  We have currently a situation where
> btrfs is too demanding on inexperienced users.

I think the top complaint is the manual nature of balancing to avoid
enospc when there's free space, followed by balancing needed to
avoid/reduce free space fragmentation and thus maintain consistent
performance.

Obviously the kernel needs more intelligent code to free up partially
full block groups, more correctly to free up contiguous space for it
to write to. That solve both problems.

But in the meantime, btrfs-progs should ship a policy to do some
minimal balance to totally obviate this and find the edge cases. Maybe
it's dusage=3 every day. And dusage=10 one a week. And dusage=20
musage=20 once a month. I don't know but some iteration in this area
is better than saying, PUNT! And putting it on the user's lap.

Better would be a trigger that is statistics based rather than time
based. The metric might be some combination of workload (i.e. idle)
and ratios found in sysfs.

Anyway, the first step is for people on this list to stop
micromanaging their own volumes, and try to center on a sane one size
fits all solution. And then iterate better and better solutions as we
determine the edge cases where one size doesn't fit all. We're
throwing hammers at the problem by default because it's a learned
behavior. We all need to just stop balancing and act like regular
users. And then figure out how to automatically optimize.




>
> I feel we need better worst-case behaviours. For example, if *I* have a
> btrfs on its second-to-last-available chunk, it means I'm not micro-managing
> properly. But users shouldn't have to micro-manage in the first place. Btrfs
> (or a management tool) should just know to balance the least-used chunk
> and/or delete the lowest-priority snapshot, etc. It shouldn't cause my
> services/apps to give diskspace errors when, clearly, there is free space
> available.

Ideally the kernel code needs to do a better job freeing up partial
block groups. But in the meantime, this can be set as an optimization
policy in user space. And it should be in btrfs-progs so it's
consistent across distros. SUSE has a distro specific balancer, on a
systemd timer, but I don't think it's enabled by default and I also
think it's weirdly too aggressive.

If it could be made smarter, with a trigger other than a timer, that'd
be even better.

But doing nothing has been one of the most consistently negative user
responses about Btrfs is the manual balance to maintain performance.



> The other "high-level" aspect would be along the lines of better guidance
> and standardisation for distros on how best to configure btrfs. This would
> include guidance/best practices for things like appropriate subvolume
> mountpoints and snapshot paths, sensible schedules or logic (or perhaps even
> example tools/scripts) for balancing and scrubbing the filesystem.

Would they listen? My experience with openSUSE is, nope.


> I don't have all the answers. But I also don't want to have to tell people
> they can't adopt it because a) they don't (or never will) understand it; and
> b) they're going to resent me for their irresponsibly losing their own data.

Sure.

You can read on the linux-raid@ list where there are still constant
problems with users doing crazy things like mdadm --create to fix a
raid assembly problem, and obliterate their data by doing this and
then getting pissed. It's like, where the hell do people keep getting
the idea of doing that?

There are six ways to Sunday ways of fixing a Btrfs volume. It reads
like a choose your own adventure book. No, actually it's worse because
at least the choose your own adventure book tells you what page to go
to next, and Btrfs gives you zero advice what order to try things in.


-- 
Chris Murphy
