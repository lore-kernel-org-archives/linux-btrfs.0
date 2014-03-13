Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.220]:30900 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaCMTTJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 15:19:09 -0400
Received: from fuchsia.localnet (p5DE8FFB9.dip0.t-ipconnect.de [93.232.255.185])
	by smtp.strato.de (RZmta 32.27 DYNA|AUTH)
	with ESMTPSA id R076e3q2DJCi4RI
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Thu, 13 Mar 2014 20:12:44 +0100 (CET)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Incremental backup for a raid1
Date: Thu, 13 Mar 2014 20:12:44 +0100
Message-ID: <1564384.fRV1HUkfCq@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


My backup use case is different from the what has been recently 
discussed in another thread. I'm trying to guard against hardware 
failure and other causes of destruction.

I have a btrfs raid1 filesystem spread over two disks. I want to backup 
this filesystem regularly and efficiently to an external disk (same 
model as the ones in the raid) in such a way that

* when one disk in the raid fails, I can substitute the backup and 
rebalancing from the surviving disk to the substitute only applies the 
missing changes.

* when the entire raid fails, I can re-build a new one from the backup.

The filesystem is mounted at its root and has several nested subvolumes 
and snapshots (in a .snapshots subdir on each subvol).

Is it possible to do what I'm looking for?

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

