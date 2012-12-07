Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44199 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161012Ab2LGQQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Dec 2012 11:16:10 -0500
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 9B53E20C01
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Dec 2012 11:16:09 -0500 (EST)
Message-Id: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
From: merc1984@f-m.fm
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Date: Fri, 07 Dec 2012 08:16:09 -0800
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


We're using a backups server to back up all machines in a LAN.  Four 2TB
disks are assembled in a BTRFS RAID array and mounted as /media/backups.
 Under this are subvolumes droog, hex, etc, and snapshots
droog_snap-{date1}, hex_snap-{date1}, etc.

Goal is to encrypt backups, but the concern is with snapshots.  Won't
piping rsync through encryption with GPG or somesuch, play havoc with
BTRFS snapshot accounting?

Is there any way to encrypt an array so it is inaccesible while
umounted?

I've already asked on the ecryptfs listserv and it resulted in mass
confusion.

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

