Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41480 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252AbaFLHpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 03:45:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WuzhU-0002Ld-65
	for linux-btrfs@vger.kernel.org; Thu, 12 Jun 2014 09:45:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 09:45:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 09:45:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 1/3] btrfs-progs: fix missing parity stripe for raid6 in
 chunk-recover
Date: Thu, 12 Jun 2014 07:45:13 +0000 (UTC)
Message-ID: <pan$b6f9d$aacea77$9bd67de4$294bec3e@cox.net>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gui Hecheng posted on Thu, 12 Jun 2014 10:24:59 +0800 as excerpted:

> When deal with the p & q stripes for data profile raid6, chunk-recover
> forgets to insert them into the chunk record. Just insert them back
> freely.
> Also wrap the inert procedure into a new function, fill_chunk_up.

If there's a v2 anyway: s/inert/insert/ ?

(For a moment I was contemplating the reasons one might wrap a stub, 
which is how I was translating inert procedure. Then it hit me... =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

