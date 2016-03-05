Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42497 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759441AbcCECJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 21:09:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ac1ef-0001fJ-IP
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 03:09:17 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 03:09:17 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Mar 2016 03:09:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC while creating snapshot
Date: Sat, 5 Mar 2016 02:09:12 +0000 (UTC)
Message-ID: <pan$297ce$3e554bcd$6c1aeaa$9eef485a@cox.net>
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
	<20160305034910.576d2230@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sat, 05 Mar 2016 03:49:10 +0500 as excerpted:

> As you use the nodatacow mount option, this seems to be another case of
> http://www.spinics.net/lists/linux-btrfs/msg51276.html
> http://www.spinics.net/lists/linux-btrfs/msg51819.html
> 
> and is fixed by https://patchwork.kernel.org/patch/7967161/
> 
> Unfortunately the bug is known since the start of the 4.4 series and the
> patch is out for 2 months, but it didn't get included into even 4.4.4
> released recently. You have to apply it by yourself and recompile the
> kernel.

Tho AFAIK it should be in 4.5, which is getting close to release, so if 
you prefer to run 4.5-rcX to applying the patch yourself, that should 
work as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

