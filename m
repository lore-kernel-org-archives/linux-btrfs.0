Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33007 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbcCCHoy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Mar 2016 02:44:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1abNwJ-0001S0-PB
	for linux-btrfs@vger.kernel.org; Thu, 03 Mar 2016 08:44:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 08:44:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Mar 2016 08:44:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: fix loading of orphan roots leading to BUG_ON
Date: Thu, 3 Mar 2016 07:44:40 +0000 (UTC)
Message-ID: <pan$3da48$d9875bc6$b571bd11$61baf2c8@cox.net>
References: <1456933778-7944-1-git-send-email-fdmanana@kernel.org>
	<pan$91701$3af360aa$c931211b$9c451328@cox.net>
	<56D7D925.8070004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Thu, 03 Mar 2016 14:26:45 +0800 as excerpted:

> Never heard the 2 release cycles principle, but seems to be not flex
> enough.
>  From this point of view, every time Filipe(just an example, as he finds
> the most of bugs and corner case), some part or even the whole btrfs is
> not stable for 4 months.

Well, once a feature is considered stable (relative to the rest of btrfs, 
anyway), the two-releases-without-bugs counter/clock no longer resets, 
and it's simply bugs in otherwise stable features as opposed to more bugs 
in still unstable features, resetting the clock on those features and 
preventing them from reaching (my measure of) stability.

And it's more or less just a general rule of thumb, anyway, with per-
feature and per-bug adjustments based on the amount of new code in the 
feature and how critical the bug is or isn't.

But in my experience it /does/ seem a relatively good general rule of 
thumb level guideline, provided it is taken /as/ a rule of thumb level 
guideline and not applied too inflexibly.

The other factor, however, would be the relative view into bugs...

I suppose it's reasonably well known that in practice, one has to be a 
bit cautious about evaluating the stability of a project by the raw 
number of scary looking problems reported on the mailing list or bug 
tracker, in part, because that's what those are /for/, and while they're 
good at tracking that, they don't normally yield a good picture at all of 
all the hundreds or thousands or tens of thousands or millions actually 
using the project without problems at all.

By the same token, the developer's viewpoint of a feature is likely to 
see quite a few more bugs, due to simple familarity with the topic and 
exposure on multiple channels (IRC/btrfs-list/private-mail/lkml/
filesystems-list/kernel-bugzilla/one-or-more-distro-lists...), than 
someone like me, a simple user/admin, tracking perhaps one or two of 
those channels.

There's a lot of feature bugs that a feature developer is going to be 
aware of, that simply won't rise to my level of consciousness.  But by 
the same token, if multiple people are suddenly reporting an issue, as 
will likely happen for the serious bugs, I'm likely to see one and 
possibly more reports of it here, and /will/ be aware of it.

So what I'm saying is that, at my level of awareness at least, and 
assuming it is taken as the rule of thumb guideline I intend it as, the 
two releases without a known bug in a feature /guideline/ has from my 
experience turned out to be reasonably practical and reliable, tho I'd 
expect it would not and could not be workable at that level, applied by a 
feature dev, because by definition, that feature dev is going to know 
about way more bugs in the feature than I will, and as you said, applying 
it in that case would mean the feature /never/ stabilizes.

Does that make more sense, now?

Now back to the specific feature in question, btrfs quotas.  Thanks for 
affirming that they are in general considered workable now.  I'll mention 
that as developer perspective when I make my recommendations, and it will 
certainly positively influence my own recommendations, as well, tho I'll 
mention that there are still corner-case bugs being worked out, so 
recommend following quota related discussion and patches on the list for 
now as well.  But considering it ready for normal use is already beyond 
what I felt ready to recommend before, so it's already a much more 
positive recommendation now that previously, even if it's still tempered 
with "but keep up with the list discussion and current on your kernels, 
and be aware there are still occasional corner-cases being worked out" as 
a caveat, which it should be said, is only slightly stronger than the 
general recommendation for btrfs itself.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

