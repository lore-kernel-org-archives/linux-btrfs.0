Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47146 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbcCUJna (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 05:43:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ahwMq-0003lV-9J
	for linux-btrfs@vger.kernel.org; Mon, 21 Mar 2016 10:43:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:43:20 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 10:43:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Btrfsck memory usage reduce idea
Date: Mon, 21 Mar 2016 09:43:09 +0000 (UTC)
Message-ID: <pan$4aef4$19f8b299$f561cb94$e137c056@cox.net>
References: <56DD14B6.4070908@cn.fujitsu.com>
	<56DE8D1D.5050504@jp.fujitsu.com> <56DE9171.8040309@cn.fujitsu.com>
	<20160318181854.GF21722@twin.jikos.cz> <56EF595B.7080509@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Mon, 21 Mar 2016 10:15:55 +0800 as excerpted:

> The point that I didn't want to keep the current behavior is, the old
> one is just OK or OOM, no one would know if it will OOM until it
> happens.
> 
> But the new one would be much flex than current behavior.
> As it fully uses the IO cache provided by kernel.
> 
> For machine with lot of memory, the whole IO will be cached except the
> first read.
> Making the difference between new and old implementation quite small.
> 
> For machine with less memory or the fs is just too large, at least
> btrfsck won't cause OOM.

That makes more sense to me, now.

I didn't initially post but I was worried about the tradeoff to much 
longer times, tho with lower memory requirements, on operations that can 
already take a long time.  But if as you say here the new, lower memory 
version makes use of cache so there shouldn't be a lot of difference on 
higher memory machines anyway, then yes, replacing the current 
implementation instead of providing an option so either implementation 
can be used, makes more sense, because otherwise one option will get more 
testing than the other, fixes to one might not carry over to the other, 
etc.

Tho as you suggest, possibly with a transition period during which both 
implementations are available, to work out any differences in results and/
or dramatically worse runtime cases.

Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

