Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52953 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbaCXUTz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 16:19:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WSBLb-0001aT-SJ
	for linux-btrfs@vger.kernel.org; Mon, 24 Mar 2014 21:19:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 21:19:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 21:19:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Suggestion: Anti-fragmentation safety catch (RFC)
Date: Mon, 24 Mar 2014 20:19:19 +0000 (UTC)
Message-ID: <pan$191e5$f5ca4422$3e26f4d9$15d09a73@cox.net>
References: <lgq247$lgk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin posted on Mon, 24 Mar 2014 19:47:34 +0000 as excerpted:

> Possible fix:
> 
> btrfs checks the ratio of filesize versus number of fragments and for a
> bad ratio either: [...]

> 3: Automatically defragments the file.

See the autodefrag mount option.

=:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

