Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42231 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3EFHuU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 03:50:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZGBe-0002Lp-IT
	for linux-btrfs@vger.kernel.org; Mon, 06 May 2013 09:50:18 +0200
Received: from host-091-097-225-022.ewe-ip-backbone.de ([91.97.225.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 09:50:18 +0200
Received: from hurikhan77+btrfs by host-091-097-225-022.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 09:50:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient backups
Date: Mon, 06 May 2013 09:44:19 +0200
Message-ID: <lj3k5a-6dh.ln1@hurikhan.ath.cx>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <51874A85.1050608@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs@jan-o-sch.net> schrieb:

>> I'm using an bash/rsync script[1] to backup my whole system on a nightly
>> basis to an attached USB3 drive into a scratch area, then take a snapshot
>> of this area. I'd like to have these snapshots immutable, so they should
>> be read-only.
> 
> Have you considered using btrfs send / receive for that purpose? You would
> just save the dedup step.

This is planned for later. In the first step I want to stay as file system 
agnostic for the source as possible. But I've put it on my todo list in the 
gist.

Regards,
Kai

