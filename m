Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53396 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbbDCIdb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Apr 2015 04:33:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ydx2f-0002ks-Ps
	for linux-btrfs@vger.kernel.org; Fri, 03 Apr 2015 10:33:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 10:33:29 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2015 10:33:29 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on
 btrfs-convert.
Date: Fri, 3 Apr 2015 08:33:23 +0000 (UTC)
Message-ID: <pan$e0c2f$781ca278$7c4e0058$da80a306@cox.net>
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com>
	<pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
	<551E3C06.9040305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Fri, 03 Apr 2015 15:06:46 +0800 as excerpted:

> It seems my English is really poor... :(

I think the usual response is "Better than my Chinese!" =:^)

Seriously, tho, it's better than many native English speakers/writers as 
well, good enough I'd not guess different were it not for the name and 
the cn hint in your email address.  Meanwhile, while it was a sentence 
fragment, in less formal settings (such as this list) it would have 
passed more or less unnoticed, particularly since the meaning was so 
obvious that not even a word needed changed, only a bit of punctuation.

In more formal setting such as btrfs documentation, however, a sentence 
fragment of that sort will trigger the reader's misparse detector, thus 
causing them to pause and go back and reread, slower, to see where their 
natural parsing went wrong.  As such, it brings attention to something 
that would otherwise be fairly minor.  So better to fix it now and not 
have all those people stumbling over it later. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

