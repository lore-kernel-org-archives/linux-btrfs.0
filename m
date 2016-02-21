Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52910 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbcBUSAQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Feb 2016 13:00:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aXNHv-0004TD-EV
	for linux-btrfs@vger.kernel.org; Sun, 21 Feb 2016 07:14:35 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 07:14:35 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Feb 2016 07:14:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [Question]: Contributing to btrfs
Date: Sun, 21 Feb 2016 06:14:27 +0000 (UTC)
Message-ID: <pan$10f61$d1f2f571$e6679adf$76c72183@cox.net>
References: <20160220210903.GA3182@carbon.home>
	<20160220224050.GA10864@carbon.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Philippe Loctaux posted on Sat, 20 Feb 2016 23:40:50 +0100 as excerpted:

> I'm new to the mailing list and btrfs in general (I've been using it for
> two weeks on my new arch install) and I'd like to contribute to the code
> :)
> 
> I know how to work w/ git and patches, I just wanted to know which git
> repo I need to clone to start contributing :)
> 
> I went on the kernel wiki and I saw some git repos, that confused me,
> that's why I'm asking here :)

You mention the kernel wiki, but don't mention the btrfs wiki, which is 
on a kernel wiki subdomain, and which has the btrfs-specific information, 
both for users and for developers.  Missing that is thus likely to be the 
source of your confusion, which makes it easy to fix. =:^)

https://btrfs.wiki.kernel.org

More specifically of interest for developers:

https://btrfs.wiki.kernel.org/index.php/Main_Page#Developer_documentation

But as you're a new user as well, and missed the btrfs user docs on the 
wiki, spend some time looking over them as well, as they'll almost 
certainly contain some rather useful user information you missed, as well.


If OTOH, you meant that you read that, and were still confused, as may be 
the case give that I too was a bit confused as a list regular, when I was 
looking for actual development sources, as the kernel.org userspace repo 
only contains releases, the repo.or.cz repo is what I was looking for to 
get the actual under development userspace HEAD code.  Or just do what I 
did and browse around a bit until you figure out which of the listed repos 
you're actually after. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

