Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58911 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaBHWAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 17:00:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCFwS-0001l2-5C
	for linux-btrfs@vger.kernel.org; Sat, 08 Feb 2014 23:00:04 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 23:00:04 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 23:00:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sat, 08 Feb 2014 22:50:11 +0100
Message-ID: <jdlisa-rt7.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <20140207104005.7bd1438a@natsu> <1B8BB06F-64EA-40EC-B0D7-FB4A38928DA3@colorremedies.com> <2016480.0iFfLibb6i@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald <Martin@lichtvoll.de> schrieb:

> While I understand that there is *never* a guarentee that a given free
> space can really be allocated by a process cause other processes can
> allocate space as well in the mean time, and while I understand that its
> difficult to provide an accurate to provide exact figures as soon as RAID
> settings can be set per subvolume, it still think its important to improve
> on the figures.

The question here: Does the free space indicator "fail" predictably or 
inpredictably? It will do the latter with this change.

-- 
Replies to list only preferred.

