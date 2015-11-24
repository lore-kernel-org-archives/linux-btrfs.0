Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:40710 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbbKXRLj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 12:11:39 -0500
Received: from smtp15.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp15.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id DC765380CD5
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:06:09 -0500 (EST)
Received: from smtp15.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp15.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id D825538017D
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:06:09 -0500 (EST)
Received: by smtp15.relay.iad3a.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id B75D7380CD5
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:06:09 -0500 (EST)
From: Vincent Olivier <vincent@up4.com>
Content-Type: text/plain; charset=us-ascii
Subject: btrfs check help
Message-Id: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
Date: Tue, 24 Nov 2015 12:06:08 -0500
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Woke up this morning with a kernel panic (for which I do not have details). Please find below the output for btrfs check. Is this normal ? What should I do ? Arch Linux 4.2.5. Btrfs-utils 4.3.1. 17x4TB RAID10.

Regards,

Vincent

[root@3dcpc5 ~]# btrfs check /dev/sdk
Checking filesystem on /dev/sdk
UUID: 6a742786-070d-4557-9e67-c73b84967bf5
checking extents
checking free space cache
checking fs roots
root 5 inode 1341670 errors 400, nbytes wrong
root 11406 inode 1341670 errors 400, nbytes wrong
found 19328809638262 bytes used err is 1
total csum bytes: 18849042724
total tree bytes: 27389886464
total fs tree bytes: 4449746944
total extent tree bytes: 3075457024
btree space waste bytes: 2880474254
file data blocks allocated: 19430708535296
referenced 20123773407232