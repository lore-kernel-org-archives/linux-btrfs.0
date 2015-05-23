Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34868 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbbEWC4R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 22:56:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Yvzbj-00074W-4X
	for linux-btrfs@vger.kernel.org; Sat, 23 May 2015 04:56:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 04:56:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 04:56:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
Date: Sat, 23 May 2015 02:56:06 +0000 (UTC)
Message-ID: <pan$2d29f$68e50c54$420ff0f1$97d19c19@cox.net>
References: <loom.20150521T231006-840@post.gmane.org>
	<pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net>
	<CAJCQCtTeoYHganNAJf=cyXzgCN9z1X=G1N=xEbksyRVDpZPbjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 22 May 2015 13:15:09 -0600 as excerpted:

> On Thu, May 21, 2015 at 10:43 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> For in-production use, therefore, btrfs raid56 mode, while now at least
>> in theory complete, is really too immature at this point to recommend.
> 
> At some point perhaps a developer will have time to state the expected
> stability level on stable hardware. And what things should be included
> in a complete report. I see many reports only including the bug/ Warning
> with call trace. And too often problems were happening before that.
> 
> The XFS FAQ has an explicit "what to include in a report" other that may
> serve as a guide to adapt for Btrfs reports.

There's one spot on the wiki (bottom of the btrfs mailing lists page) that
lists the information to provide when filing a bug.

https://btrfs.wiki.kernel.org/index.php/Btrfs_mailing_list

But, even being somewhat familiar with the wiki and knowing it was, or had
been, somewhere on the wiki, I had trouble finding it.  It's definitely
not in the first place I looked, the Problem FAQ, under How do I report
bugs and issues?  (Tho it does link to the list page.)

https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F

If I had ever gotten around to getting a wiki login, I'd fix that, but for
some reason, while I seem to be fine posting to newsgroups and
mailinglists (as newsgroups, via gmane.org's list2news service), I mostly
treat the web, wikis included, as read-only, other than the occasional
reply to an article.  I never got into web forums that much either.

So if you have a wiki login and time to fix it... =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

