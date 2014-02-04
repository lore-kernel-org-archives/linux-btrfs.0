Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36139 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933098AbaBDVCD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WAn84-00055Y-BD
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 22:02:00 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 22:02:00 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Feb 2014 22:02:00 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Are nocow files snapshot-aware
Date: Tue, 04 Feb 2014 21:52:38 +0100
Message-ID: <mh08sa-5tp.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I'm curious... The whole snapshot thing on btrfs is based on its COW design. 
But you can make individual files and directory contents nocow by applying 
the C attribute on it using chattr. This is usually recommended for database 
files and VM images. So far, so good...

But what happens to such files when they are part of a snapshot? Do they 
become duplicated during the snapshot? Do they become unshared (as a whole) 
when written to? Or when the the parent snapshot becomes deleted? Or maybe 
the nocow attribute is just ignored after a snapshot was taken?

After all they are nocow and thus would be handled in another way when 
snapshotted.

-- 
Replies to list only preferred.

