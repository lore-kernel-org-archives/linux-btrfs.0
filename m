Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54183 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab3HCQ5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 12:57:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5f8s-0002Nz-Ap
	for linux-btrfs@vger.kernel.org; Sat, 03 Aug 2013 18:57:22 +0200
Received: from host-091-097-227-150.ewe-ip-backbone.de ([91.97.227.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 18:57:22 +0200
Received: from hurikhan77+btrfs by host-091-097-227-150.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 18:57:22 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Which better: rsync or snapshot + rsync --delete
Date: Sat, 03 Aug 2013 18:54:18 +0200
Message-ID: <s6pvca-4tt.ln1@hurikhan.ath.cx>
References: <kthh5l$7ti$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin <m_btrfs@ml1.co.uk> schrieb:

> Which is 'best' or 'faster'?
> 
> Take a snapshot of an existing backup and then "rsync --delete" into
> that to make a backup of some other filesystem?
> 
> Or use "rsync --link" to link a new backup tree against a previous
> backup tree for the some other filesystem?

I'm doing it vice-versa... I rsync --inplace --delete to a scratch area and 
only then after that finished without errors, I'm taking a snapshot of that. 
That way I always know the snapshots are in good and consistent state while 
the scratch area is just playground for in-progress backups.

Just in case you are curious, here's the gist: 
https://gist.github.com/kakra/5520370

Using inplace and no-whole-file options ensures space-efficient snapshots. I 
don't worry about fragmentation, it's only the backup drive. It doesn't 
matter if it's fragmented and thus a little bit slower, it only matters 
restore works fine.

It is using systemd for automation but feel free to call it from cron...

HTH
Kai

