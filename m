Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60425 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaBHXpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 18:45:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCHa2-0001vc-SI
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 00:45:02 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:45:02 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 00:45:02 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 09 Feb 2014 00:32:47 +0100
Message-ID: <0erisa-t5d.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de> <20140209041050.529ff6f9@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov <rm@romanrm.net> schrieb:

> UNIX 'df' and the 'statfs' call on the other hand should keep the behavior
> people are accustomized to rely on since 1970s.

When I started to use unix, df returned blocks, not bytes. Without your 
proposed patch, it does that right. With your patch, it does it wrong.
 
-- 
Replies to list only preferred.

