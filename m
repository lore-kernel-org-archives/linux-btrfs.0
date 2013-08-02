Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42359 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772Ab3HCAAP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 20:00:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5PGV-0001Wz-29
	for linux-btrfs@vger.kernel.org; Sat, 03 Aug 2013 02:00:11 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 02:00:11 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 02:00:11 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Which better: rsync or snapshot + rsync --delete
Date: Sat, 03 Aug 2013 00:59:56 +0100
Message-ID: <kthh5l$7ti$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Which is 'best' or 'faster'?

Take a snapshot of an existing backup and then "rsync --delete" into
that to make a backup of some other filesystem?

Or use "rsync --link" to link a new backup tree against a previous
backup tree for the some other filesystem?

Which case does btrfs handle the better?

Would there be any problems for doing this over an nfs mount of the btrfs?


Both cases can take advantage of the raid and dedup and compression
features of btrfs. Would taking a btrfs snapshot be better than rsync
creating the hard links to unchanged files?

Any other considerations?

(There are perhaps about 5% new or changed files each time.)

Thanks,
Martin

