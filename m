Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39416 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbaBTLDt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 06:03:49 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGRPv-0007Ny-MW
	for linux-btrfs@vger.kernel.org; Thu, 20 Feb 2014 12:03:47 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 12:03:47 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 12:03:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental backup over writable snapshot
Date: Thu, 20 Feb 2014 11:03:22 +0000 (UTC)
Message-ID: <pan$70982$400c23a8$2994c48a$4db2a63a@cox.net>
References: <17860756.QfG9CfNMqv@linuxpc> <2285169.jbztTl7OC0@linuxpc>
	<880EBF41-577C-4791-B022-DECE2960748F@colorremedies.com>
	<16991840.tqyQc6bZHr@linuxpc>
	<1985F36E-E720-415C-8BCD-9D7D2847C5DF@colorremedies.com>
	<99gfta-695.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Wed, 19 Feb 2014 21:20:23 +0100 as excerpted:

>  Duncan had a nice example in this list how to migrate
> directories to subvolumes by using shallow copies: "mv dir dir.old &&
> btrfs sub create dir && cp -a -- reflink=always dir.old/. dir/. && rm
> -Rf dir.old".

FWIW, that was someone else.  I remember seeing it and I may well have 
been involved in some aspect of the discussion and thus might have quoted 
it, but my particular use-case doesn't involve a lot of subvolumes or 
snapshots, so I don't typically get quite that deep into the command-
detail in subvolume discussions as I've simply not had the necessary 
personal experience in that area to properly discuss at that level.  (Tho 
it's certainly typical of what I might post in other areas, just not that 
one.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

