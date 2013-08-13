Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49539 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3HMEyw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 00:54:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V96d8-00071D-3S
	for linux-btrfs@vger.kernel.org; Tue, 13 Aug 2013 06:54:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 06:54:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 06:54:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] Btrfs: don't allow a subvol to be deleted if it is the
 default subovl
Date: Tue, 13 Aug 2013 04:54:32 +0000 (UTC)
Message-ID: <pan$445b2$64e1e159$c2f6f85b$84d1e879@cox.net>
References: <1376336375-20631-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik posted on Mon, 12 Aug 2013 15:39:35 -0400 as excerpted:

> Fix this by adding a check to see if our default subvol points to the
> subvol we are trying to delete, and if it does not allowing it to
> happen.

Umm... not to be a grammar policeman, but...

That last sub-sentence REALLY (!!) needs another comma:

... and if it does, not allowing it to happen.

or

... and if it does not, allowing it to happen.

The way it is now ends up triggering for the reader a serious logical 
train wreck, as "does not" and "not allowing" both "want" to be parsed 
together, but "does not allowing" derails the whole thing and the reader 
must start over, taking it more slowly this time, trying to figure out 
where the parsing derailed the first time through and what was actually 
intended!

(FWIW, being a languagelog.net feed subscriber and regular reader, I see 
instances of this sort of logical train wreck, as it's frequently 
analogized, feature there regularly.  Linguists know it as an interesting 
quirk of the English language both created and spotted regularly by 
experts and novices alike, sometimes with rather amusing consequences!)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

