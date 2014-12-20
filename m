Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44516 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaLTBjO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 20:39:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y290i-0002ov-Aq
	for linux-btrfs@vger.kernel.org; Sat, 20 Dec 2014 02:39:12 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 02:39:12 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 02:39:12 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs is using 25% more disk than it should
Date: Sat, 20 Dec 2014 01:38:55 +0000 (UTC)
Message-ID: <pan$adc4e$7418237b$e110dc41$6207434a@cox.net>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
	<54949454.9020601@fb.com> <549495D4.9030800@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik posted on Fri, 19 Dec 2014 16:17:08 -0500 as excerpted:

> tl;dr: Cow means you can in the worst case end up using 2 * filesize -
> blocksize of data on disk and the file will appear to be filesize.

Thanks for the tl;dr /and/ the very sensible longer explanation.  That's 
a very nice thing to know and to file away for further reference. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

