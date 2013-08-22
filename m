Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59313 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab3HVXxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 19:53:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VCehG-0004hB-4i
	for linux-btrfs@vger.kernel.org; Fri, 23 Aug 2013 01:53:46 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 01:53:46 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 01:53:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Date: Thu, 22 Aug 2013 23:53:28 +0000 (UTC)
Message-ID: <pan$c2c58$61dbf027$55d0c5a2$71b9b679@cox.net>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas Lee posted on Thu, 22 Aug 2013 02:47:38 -0400 as excerpted:

> Problem: My filesystem is screwed up, and I can't mount it at all right
> now. In the logs, the problem begins around 45s.

> Adding insult to injury, this occurred right as I began the initial
> backup to another system with rsync. :(

> I would be seriously grateful to anyone that can figure out a way to
> mount/fix this partition, and I'd be willing to send some bitcoin

Not to add insult to injury, but for future reference anyway, you /are/ 
aware that btrfs is still marked experimental both in the kernel btrfs 
option description and on the btrfs wiki[1], and that as such, anything 
you put on it should be considered subject to loss, basically throw-away 
data that you don't care about losing either because you have multiple 
backups (on rather less developmental-stage stable filesystems), or 
because it really is throw-away data, and backups would be overkill.

I know you were just starting that backup, but the fact that you're 
willing to throw some bitcoin at recovery indicates that you 
/already/ had valuable data on the filesystem, that should have already 
been restoreable from (tested) backup.  Alternatively, perhaps btrfs 
simply isn't an appropriate choice of filesystem for you at this point, 
because it /is/ still considered experimental.  Maybe in a year or two, 
sometime after that experimental label comes off, depending on how 
conservative you actually need to be with your data.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

