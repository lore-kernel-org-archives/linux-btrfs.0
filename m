Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56703 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbaDUXAr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 19:00:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcNCg-0005JQ-2e
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 01:00:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:00:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:00:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi df "unknown"
Date: Mon, 21 Apr 2014 23:00:34 +0000 (UTC)
Message-ID: <pan$6e106$ce6c8992$24f8fddd$735743cb@cox.net>
References: <9C28A5D6-F223-400F-9471-85C0F88FA939@colorremedies.com>
	<535511FE.8070608@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Mon, 21 Apr 2014 08:41:34 -0400 as excerpted:

> 3.15 has this commit, it's the cause of the unknown.

[Since I already replied to thread.]

That would explain why I haven't seen it yet.  I'm still running kernel 
3.14 as I'm trying to catch up on some other stuff before I upgrade to 
3.15-rc.  Tho I try to upgrade before rc4 at the latest, so if I spot any 
bugs I can report 'em with some time to fix before release.  Which gives 
me a week or so...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

