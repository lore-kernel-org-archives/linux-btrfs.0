Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52862 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaBMUWr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 15:22:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WE2o1-0002MC-3M
	for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 21:22:45 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 21:22:45 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Feb 2014 21:22:45 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH 5/8] Add command btrfs filesystem disk-usage
Date: Thu, 13 Feb 2014 20:22:18 +0000 (UTC)
Message-ID: <pan$166a9$744f4965$bbb246f5$8c607ae6@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <52FD1AD6.50500@libero.it>
 <20140214012810.26297146@natsu>
 <52FD21B4.4050502@libero.it>

Goffredo Baroncelli posted on Thu, 13 Feb 2014 20:49:08 +0100 as
excerpted:

> Thanks for the comments, however I don't like du not usage; but you are
> right when you don't like "disk-usage". What about "btrfs filesystem
> chunk-usage" ? The short form would be
> 
> 	btrfs fi chunk
> 
> which is coherent with the data displayed

That makes much more sense from a different perspective as well.  "Disk" 
sounds so 20th-century spinning rust..., and at least to me, "du" isn't 
as intuitive or commonly used as "df", so while "df" seems natural to me, 
while I understand where "du" comes from, it still makes me go "huh?" as 
I wouldn't expect to see it in the btrfs context.

So btrfs filesystem chunk(-usage), please. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

