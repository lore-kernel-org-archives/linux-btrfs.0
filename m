Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56837 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaJXFNn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 01:13:43 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XhXBz-0002S5-Ml
	for linux-btrfs@vger.kernel.org; Fri, 24 Oct 2014 07:13:39 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 07:13:39 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Oct 2014 07:13:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: device balance times
Date: Fri, 24 Oct 2014 05:13:27 +0000 (UTC)
Message-ID: <pan$e118d$d880428d$ebc41b4b$dabf1c21@cox.net>
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
	<5446BEC0.8070009@siedziba.pl>
	<02A17DFE-290C-4447-99E9-D39480D7A26A@colorremedies.com>
	<5447A5CF.9060405@siedziba.pl> <5448C81E.4060701@cn.fujitsu.com>
	<5448E8F0.7070004@gmail.com>
	<pan$d3176$38668d14$9f498698$7cd4113f@cox.net>
	<20141024023529.GD17395@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Thu, 23 Oct 2014 22:35:29 -0400 as excerpted:

> My pet peeve:  if balance is converting profiles from RAID1 to single,
> the conversion should be *instantaneous* (or at least small_constant *
> number_of_block_groups).  Pick one mirror, keep all the chunks on that
> mirror, delete all the corresponding chunks on the other mirror.

That would argue for either a third balance mode, --convert-only, or a 
different tool, avoiding a rewrite of existing chunks entirely, simply 
replicating them if adding redundancy or deleting a copy if reducing it, 
as necessary.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

