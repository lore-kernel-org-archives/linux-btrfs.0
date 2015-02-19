Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36841 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbbBSUli (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 15:41:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YOXuj-0007wJ-0r
	for linux-btrfs@vger.kernel.org; Thu, 19 Feb 2015 21:41:37 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 21:41:37 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2015 21:41:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Parallel bug reporting on bugzilla.kernel.org and mailing list?
Date: Thu, 19 Feb 2015 20:41:31 +0000 (UTC)
Message-ID: <pan$6006f$56639ebf$6205229f$71b136eb@cox.net>
References: <54E5D46E.7090108@richtercloud.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Karl-Philipp Richter posted on Thu, 19 Feb 2015 13:17:50 +0100 as
excerpted:

> According to
> https://btrfs.wiki.kernel.org/index.php/
Problem_FAQ#How_do_I_report_bugs_and_issues.3F
> bugs ought to be reported on bugzilla.kernel.org and on the mailing
> list. Is "and" to be interpreted as a logical AND or rather XOR.

Logical AND, at least for bugs that aren't immediately picked up by a dev 
on the list.

The idea is that lists tend to be rather informal and chaotic and a 
report to the list only can get lost, particularly when the devs are all 
hard at work on other bugs ATM (as they will be most of the time), while 
if it's on bugzilla, it won't get lost and will thus be ready for them 
when they're ready for it.

At the same time, there's a lot more users (like me) reading the list and 
it's a much more natural way to compare notes, etc, often leading to 
faster pickup on bugs that affect many people and more eyes to spot more 
simple things like potential method issues (with answers like read the 
wiki), faster pickup on old versions and suggestions to see if it happens 
with a new version before a dev even responds at all, etc.

Which is why (in the general case at least) I suggest posting to the list 
first, and then in a day or two to bugzilla, once the first round of "not 
a bug, read the wiki", "try a newer version and see if it's fixed", and 
"that looks like the bug I'm working on right now, here's a preliminary 
patch to try", type replies has weeded out the low hanging fruit.  OTOH, 
the kernel dev already familiar with the ropes and (particularly) already 
having a first-round suggested patch... isn't exactly the general case 
above.

> If the former is the case, is it sufficient to set the mailing list CC
> in the bugzilla?

I'd personally discourage that, preferring instead reciprocal links, 
posting a link to the list thread[1] on the bug, and a link to the bug on 
the list thread, but otherwise keeping them separate.  Among other 
reasons, discussions on lists tend to be more informal, containing what 
is hopefully useful information to other list readers, but would only be 
"noise" in the context of the more formal bug report.

But a link from each to the other can indeed be incredibly useful. =:^)

> Are there any plans to create a bug mailing list tracking bugzilla?

I'm not aware of any, at least for the near future, tho I believe the 
suggestion has come up a time or two...

---
[1] For those following the list on gmane's list2news service, as I do, 
for instance, gmane adds a handy Archived-At: header that normally 
contains a link to the post on the list2web service archive.  This can 
then be followed to get a link to the thread as well.  Posting either the 
link to the original post, or to the thread, should work.  Here's the one 
in your post, for instance.

<http://permalink.gmane.org/gmane.comp.file-systems.btrfs/43186>

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

