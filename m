Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41672 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBIJy5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 04:54:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCR6D-0006b4-Ac
	for linux-btrfs@vger.kernel.org; Sun, 09 Feb 2014 10:54:53 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 10:54:53 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 10:54:53 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Provide a better free space estimate on RAID1
Date: Sun, 09 Feb 2014 10:39:39 +0100
Message-ID: <rvujsa-7l3.ln1@hurikhan77.spdns.de>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de> <20140209041050.529ff6f9@natsu> <0erisa-t5d.ln1@hurikhan77.spdns.de> <20140209070856.55c39e8d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov <rm@romanrm.net> schrieb:

>> When I started to use unix, df returned blocks, not bytes. Without your
>> proposed patch, it does that right. With your patch, it does it wrong.
> 
> It returns total/used/available space that is usable/used/available by/for
> user data.

No, it does not. It returns space allocatable to the filesystem. That's user 
data and meta data. That can be far from your expectations depending on how 
allocation on the filesystem works.

-- 
Replies to list only preferred.

