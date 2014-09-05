Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43274 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbaIECKJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 22:10:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XPiyR-0006gP-RF
	for linux-btrfs@vger.kernel.org; Fri, 05 Sep 2014 04:10:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 04:10:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Sep 2014 04:10:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
Date: Fri, 5 Sep 2014 02:07:39 +0000 (UTC)
Message-ID: <pan$5901d$624c09af$56db7999$22491b15@cox.net>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com>
	<CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com>
	<pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net>
	<CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com>
	<03A7512C-C195-4906-9995-945AF3D76EB2@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Thu, 04 Sep 2014 19:41:39 -0600 as excerpted:

>  Off chance scrub might fix the problem

How?  He said it's btrfs raid0.  There's no second copy to fix from.

(Of course if only the data is raid0, metadata being raid1, then if it's 
metadata yes a scrub could fix it, but that's not what he said...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

