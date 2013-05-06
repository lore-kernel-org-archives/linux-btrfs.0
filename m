Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36396 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab3EFUvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 16:51:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UZSNW-0007Y9-S6
	for linux-btrfs@vger.kernel.org; Mon, 06 May 2013 22:51:22 +0200
Received: from host-091-097-225-022.ewe-ip-backbone.de ([91.97.225.22])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 22:51:22 +0200
Received: from hurikhan77+btrfs by host-091-097-225-022.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 06 May 2013 22:51:22 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Possible to dedpulicate read-only snapshots for space-efficient backups
Date: Mon, 06 May 2013 22:48:49 +0200
Message-ID: <dihl5a-m16.ln1@hurikhan.ath.cx>
References: <mjnh5a-mcf.ln1@hurikhan.ath.cx> <51874A85.1050608@jan-o-sch.net> <lj3k5a-6dh.ln1@hurikhan.ath.cx> <CAPkEcwgAH=w7q5JdsJB+YLxDgysOwTUg7boyZFMmfB1v3fmwCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

james northrup <northrup.james@gmail.com> schrieb:

> tried a git based backup? sounds spot-on as a compromise prior to
> applying btrfs tweaks.  snapshotting the git binaries would have the
> dedupe characteristics.

Git is efficient with space, yes. But if you have a lot of binary files, and 
a lot of them are big, git becomes really slow really fast. Checking out and 
in can be very slow and resource intensive then. And I don't think it would 
track ownership and permissions correctly.

Git is great, it's an everyday tool for me, but it is just not made for 
binary files.

Regards,
Kai

