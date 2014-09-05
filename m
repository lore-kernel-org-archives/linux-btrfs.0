Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaIECFd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 22:05:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPiu2-0003zL-8f
	for linux-btrfs@vger.kernel.org; Fri, 05 Sep 2014 04:05:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 04:05:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 04:05:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
Date: Fri, 5 Sep 2014 02:05:17 +0000 (UTC)
Message-ID: <pan$ce4d5$ba59968f$c3d9c659$6cf74c52@cox.net>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
	<CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com>
	<pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net>
	<CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

john terragon posted on Fri, 05 Sep 2014 02:20:26 +0200 as excerpted:

> Everyone knows what raid0 entails. Moreover, with btrfs being an
> experimental fs, not having backups would obviously be pure idiocy.
> 
> I wrote that it was "pretty serious" because the situation came out of
> nowhere on a low-traffic fs[.]

> I'm pretty sure about that because for obvious reasons I rsync the hell
> out of that filesystem  every chance I get.

Mea culpa, then.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

