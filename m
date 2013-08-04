Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58795 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab3HDXPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 4 Aug 2013 19:15:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V67Wc-0005HD-Jv
	for linux-btrfs@vger.kernel.org; Mon, 05 Aug 2013 01:15:46 +0200
Received: from dyndsl-085-016-234-003.ewe-ip-backbone.de ([85.16.234.3])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 01:15:46 +0200
Received: from hurikhan77+btrfs by dyndsl-085-016-234-003.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Aug 2013 01:15:46 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Recovery advice
Date: Mon, 05 Aug 2013 01:05:21 +0200
Message-ID: <ha33da-ecm.ln1@hurikhan77.spdns.de>
References: <pan$b7e2c$bf7f3666$af6e4a6$909b9d97@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> It is a RAID-1 so why bother with the faulty drive? Just wipe it, put it
>> back in, then run a btrfs balance... There should be no data loss
>> because all data is stored twice (two-way mirroring).
> 
> The caveat would be if it didn't start as btrfs raid1, and there's still
> some data (or possibly metadata if it was the single drive at one point
> or they're ssds, as btrfs defaults to metadata single in ssd mode) that
> hasn't been duped elsewhere.

Oh... That's actually a pitfall... :-\

Note to myself: Ensure balance has been run successfully and completely.

