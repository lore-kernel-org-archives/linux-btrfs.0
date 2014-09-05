Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53523 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754128AbaIEDUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 23:20:18 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:55556 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XPk4O-003V35-1f
	for linux-btrfs@vger.kernel.org; Thu, 04 Sep 2014 21:20:17 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: BTRFS critical (device dm-0): invalid dir item name len: 45389
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$5901d$624c09af$56db7999$22491b15@cox.net>
Date: Thu, 4 Sep 2014 21:20:14 -0600
Message-Id: <1582E246-D254-4CE3-AE8B-82E2A2ED452D@colorremedies.com>
References: <CANg_oxxmR+qkSfZeVYK5dF1HnbSJapEF1tZ+3-9ij5hq7d2E=w@mail.gmail.com> <CANg_oxzsAAV3S-Qc=mz0GTVXnPFrQ43riNXVbtT4Wjqtwsbo2A@mail.gmail.com> <pan$680f3$c4143e4$b1f456fa$d9f8eac0@cox.net> <CANg_oxzTv3cDyS0prJc_ZLopt3YNvm7oa9dFnghV7aZGNiyMvA@mail.gmail.com> <03A7512C-C195-4906-9995-945AF3D76EB2@colorremedies.com> <pan$5901d$624c09af$56db7999$22491b15@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 4, 2014, at 8:07 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> Chris Murphy posted on Thu, 04 Sep 2014 19:41:39 -0600 as excerpted:
> 
>> Off chance scrub might fix the problem
> 
> How?  He said it's btrfs raid0.  There's no second copy to fix from.
> 
> (Of course if only the data is raid0, metadata being raid1, then if it's 
> metadata yes a scrub could fix it, but that's not what he said…)

True, I'm assuming only -draid0 was specified, and therefore the multiple device default of raid1 applies. In any case the conservative option is to ensure the fs isn't changed.

Chris Murphy