Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43291 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaFXFhk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:37:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WzJQI-0001Ns-BQ
	for linux-btrfs@vger.kernel.org; Tue, 24 Jun 2014 07:37:38 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:37:38 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:37:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs on whole disk (no partitions)
Date: Tue, 24 Jun 2014 05:37:24 +0000 (UTC)
Message-ID: <pan$c3e0c$d2484a5b$564bbd55$afd82e0@cox.net>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>
	<2316027.LZEnVG8laK@xev>
	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>
	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>
	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>
	<53A6DDAD.8070804@chinilu.com>
	<99AD3EFE-AF9A-44A1-912E-07B1E934239B@colorremedies.com>
	<pan$600a2$3927cc39$ae007590$e90b8415@cox.net>
	<yq1bntjizkr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin K. Petersen posted on Mon, 23 Jun 2014 08:24:04 -0400 as excerpted:

> Anyway. The short answer is that Linux will pretty much always do I/O in
> multiples of the system page size regardless of the logical block size
> of the underlying device. There are a few exceptions to this such as
> direct I/O, legacy filesystems using bufferheads and raw block device
> access.

Thank you.  Good to have that made clear. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

