Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50074 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbcEYTTY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 15:19:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b5eKu-0000LS-6W
	for linux-btrfs@vger.kernel.org; Wed, 25 May 2016 21:19:20 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 21:19:20 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 21:19:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random
 generator
Date: Wed, 25 May 2016 19:19:11 +0000 (UTC)
Message-ID: <pan$bb742$78566cd9$5fc9402d$3fb62a5@cox.net>
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
	<20160523120112.GK29147@twin.jikos.cz>
	<f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
	<20160524095155.GN29147@twin.jikos.cz>
	<913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
	<20160525111138.GP29147@suse.cz>
	<5d14ab66-9894-82da-91ca-5cbfd0a7d760@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 25 May 2016 08:39:08 -0400 as
excerpted:

> I would tend to agree with Hugo on this one, we should be using
> /dev/urandom, not /dev/random.

Add me to the list.  I was wondering where urandom was in the discussion 
all along, but figured there must be some reason it was excluded that I 
as a non-dev simply didn't grok.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

