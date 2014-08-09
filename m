Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47349 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbaHIRBi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Aug 2014 13:01:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XGA1Q-0005OW-9d
	for linux-btrfs@vger.kernel.org; Sat, 09 Aug 2014 19:01:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 19:01:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Aug 2014 19:01:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
Date: Sat, 9 Aug 2014 17:01:24 +0000 (UTC)
Message-ID: <pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev> <20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jose Ildefonso Camargo Tolosa posted on Sat, 09 Aug 2014 11:06:37 -0500 as
excerpted:

> 3.16 (still in development)

??

3.16 has been out for nearly a week now and we're nearing half-way thru 
the 3.17 commit-window.  Based on the kernel git I have here, Linus' 
commit officially changing the makefile entry to 3.16 was on Sunday, Aug 
3, at 15:25:02 -0700.

The last pre-3.16 commit was a merge of two timer-related fixes from the 
tip-tree at 9:58:20 -0700 that morning.

So where does your "still in development" come from?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

