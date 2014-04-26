Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53755 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751171AbaDZBlp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 21:41:45 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:53584 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wdrcf-001qGu-Bs
	for linux-btrfs@vger.kernel.org; Fri, 25 Apr 2014 19:41:45 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: safe/necessary to balance system chunks?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$a73aa$187744ee$76aa9d20$301f58e9@cox.net>
Date: Fri, 25 Apr 2014 19:41:43 -0600
Message-Id: <765C03C7-08EB-4927-8934-5D6F926D6008@colorremedies.com>
References: <alpine.DEB.2.10.1404250842350.2320@cubia.leung> <75D8579E-1284-4F12-A573-15D50EFC4614@colorremedies.com> <535AA581.1080301@gmail.com> <pan$a73aa$187744ee$76aa9d20$301f58e9@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 25, 2014, at 5:03 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> But since -m/metadata includes -s/
> system by default, and that was the intended way of doing things,
> -f/force was added as necessary when doing only -s/system, since 
> presumably that was considered an artificial distinction, and handling -s/
> system as a part of -m/metadata was considered the more natural method.

OK so somehow in Steve's conversion, metadata was converted from DUP to RAID1 completely, but some portion of system was left as DUP, incompletely converted to RAID1. It doesn't seem obvious that -mconvert is what he'd use now, but maybe newer btrfs-progs it will also convert any unconverted system chunk.

If not, then -sconvert=raid1 -f and optionally -v.

This isn't exactly risk free, given that it requires -f; and I'm not sure we can risk assess conversion failure vs the specific drive containing system DUP chunks dying. But for me a forced susage balance was fast:

[root@rawhide ~]# time btrfs balance start -susage=100 -f -v /
Dumping filters: flags 0xa, state 0x0, force is on
  SYSTEM (flags 0x2): balancing, usage=100
Done, had to relocate 1 out of 8 chunks

real	0m0.095s
user	0m0.001s
sys	0m0.017s


Chris Murphy