Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:37275 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbcAHNoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 08:44:55 -0500
Received: from merkaba.localnet (host-188-174-209-238.customer.m-online.net [188.174.209.238])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 1B601573
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jan 2016 14:44:54 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: send/receive for encrypted backup purposes
Date: Fri, 08 Jan 2016 14:44:53 +0100
Message-ID: <1827847.pVfOzZHEoP@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Given that the Omnia Turris router has an mSATA slot and two USB 3 connectors, 
I am pondering the feasibility for using it for backups of my home dir.

I pondered checking out zbackup, attic or obnam for that, of which at least 
zbackup and obnam can do encrypted backups¹²³.

Yet then I thought why not using btrfs send and receive directly? I found two 
answers:

Client doesn´t encrypt. And even tough I think the Omnia will be pretty secure 
unless I configure a hole into it, I´d not feel that comfortable putting my 
whole home directory there unsecured.

So my question is, would it be possible to have btrfs send/receive encrypted? 
So far I have only three ideas about it, the first two are similar:

1) Mount a dm-crypted loopback file formatted with BTRFS from the router on 
the client. Of course dm-crypt stuff need to happen on the client then. And I 
wonder whether I would loose most of the probably performance benefit of using 
btrfs send/receive this way. I could export the file with nfs for example.

2) Export a block device from the Omnia directly wie NBD or iSCSI or whatnot 
and use it with dm-crypt on the client.

3) Have all home directories crypted via ecryptfs and only send/receive the 
subvolumes with the ecryptfs files.


Any other ideas?


Something like this would also be nice to have to store on cloud storage. 
Something along the line to send a crypted btrfs send/receive stream. Ideally 
target could be a directory on some storage that doesn´t even need to be a 
BTRFS. But I bet that would be a lot of work to implement.

[1] http://zbackup.org/
[2] https://attic-backup.org/
[3] http:/obnam.org

Thanks,
-- 
Martin
