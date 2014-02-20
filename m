Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45198 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaBTVWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 16:22:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGb4T-0008T7-Cz
	for linux-btrfs@vger.kernel.org; Thu, 20 Feb 2014 22:22:17 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 22:22:17 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 22:22:17 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Incremental backup over writable snapshot
Date: Thu, 20 Feb 2014 22:16:25 +0100
Message-ID: <9u7ita-hfi.ln1@hurikhan77.spdns.de>
References: <17860756.QfG9CfNMqv@linuxpc> <2285169.jbztTl7OC0@linuxpc> <880EBF41-577C-4791-B022-DECE2960748F@colorremedies.com> <16991840.tqyQc6bZHr@linuxpc> <1985F36E-E720-415C-8BCD-9D7D2847C5DF@colorremedies.com> <99gfta-695.ln1@hurikhan77.spdns.de> <pan$70982$400c23a8$2994c48a$4db2a63a@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>>  Duncan had a nice example in this list how to migrate
>> directories to subvolumes by using shallow copies: "mv dir dir.old &&
>> btrfs sub create dir && cp -a -- reflink=always dir.old/. dir/. && rm
>> -Rf dir.old".
> 
> FWIW, that was someone else.  I remember seeing it and I may well have
> been involved in some aspect of the discussion and thus might have quoted
> it, but my particular use-case doesn't involve a lot of subvolumes or
> snapshots, so I don't typically get quite that deep into the command-
> detail in subvolume discussions as I've simply not had the necessary
> personal experience in that area to properly discuss at that level.  (Tho
> it's certainly typical of what I might post in other areas, just not that
> one.)

Oh sorry... I just was testing if you are following the list closely... ;-)

I didn't as you can see. :-)
 
-- 
Replies to list only preferred.

