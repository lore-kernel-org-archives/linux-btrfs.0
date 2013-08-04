Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39685 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab3HDBDT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 21:03:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5mj7-0000MD-Uo
	for linux-btrfs@vger.kernel.org; Sun, 04 Aug 2013 03:03:17 +0200
Received: from dyndsl-085-016-048-159.ewe-ip-backbone.de ([85.16.48.159])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 03:03:17 +0200
Received: from hurikhan77+btrfs by dyndsl-085-016-048-159.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Aug 2013 03:03:17 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Is the checkpoint interval adjustable?
Date: Sun, 04 Aug 2013 02:58:36 +0200
Message-ID: <4jl0da-ep6.ln1@hurikhan.ath.cx>
References: <20130731200229.221580@gmx.com> <17rvca-hju.ln1@hurikhan.ath.cx> <51FD3FDC.803@skagestad.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Torbjørn <lists@skagestad.org> schrieb:

>> Just curious: What would be the benefit of increasing the checkpoint
>> interval?
> Laptops typically spin down disks to save power. If btrfs forces a write
> every 30 second, you have to spin it back up.

I'd expect btrfs not to write to the disk when a checkpoint is reached and 
no writes occurred to the filesystem meanwhile... Could some developer shed 
some light on this?

IMHO if this is true, there is no point in increasing the checkpoint 
interval... Thoughts?

Regards,
Kai

