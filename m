Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56225 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbbHUSSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 14:18:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZSqtW-00015N-48
	for linux-btrfs@vger.kernel.org; Fri, 21 Aug 2015 20:18:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 20:18:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 20:18:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Chunk fullness distribution
Date: Fri, 21 Aug 2015 18:18:20 +0000 (UTC)
Message-ID: <pan$3cda0$8efee9f8$3720f4b$2571ee17@cox.net>
References: <CAEp_DRAR5yjYNm-26jfVmajGqoSt3C9P1L5kS+C9s6g=zZhynQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bostjan Skufca posted on Fri, 21 Aug 2015 17:49:01 +0200 as excerpted:

> is there a way to get information about how much space is occupied in
> each chunk?
> 
> In the end, a simple ascii chart of usage distribution should be
> preferable, but I can work towards that if there is a way to get
> information about individual chunks.
> 
> I know that "btrfs fi show" displays aggregate info, but having
> distribution chart enables one to predict how much time "btrfs
> rebalance" operation will take for various X values in "dusage=X"
> filter.

AFAIK, no admin-level-user tool to get that information, no.  But doing a 
successive balances while incrementing the -dusage= -musage= counts 
should get you a rough idea (tho it looks like that's what you're trying 
to avoid by asking for the report in the first place), and I believe it's 
findable with the lower-level developer tools, I'd guess btrfs-debug-tree.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

