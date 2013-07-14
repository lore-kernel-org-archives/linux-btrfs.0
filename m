Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab3GNJzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 05:55:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UyJ1A-0002OA-V1
	for linux-btrfs@vger.kernel.org; Sun, 14 Jul 2013 11:55:00 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 11:55:00 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 11:55:00 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Troublesome failure mode and recovery
Date: Sun, 14 Jul 2013 09:54:40 +0000 (UTC)
Message-ID: <pan$34dc5$5935c1de$90ceba6d$c7cbfaeb@cox.net>
References: <20130713121404.65fc89ea@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jérôme Carretero posted on Sat, 13 Jul 2013 12:14:04 -0400 as excerpted:

> - `btrfsck` was crashing because the code would progress even if fs_root
>   was null... fixed with this patch:

AFAIK (based on what I've seen go by on the list, tho I'm not technical 
enough to actually make sense of the patches themselves) there's a still 
new patch floating around that deals with that one already.  It's too new 
to be in 3.10.0 (tho it might possibly make a 3.10 stable if it hits 
3.11), but will hopefully be in 3.11.

The rest I'll leave to the experts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

