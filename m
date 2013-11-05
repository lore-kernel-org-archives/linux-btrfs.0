Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:46587 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3KEBeu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 20:34:50 -0500
Received: from bluebottle.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 461582189E
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Nov 2013 12:24:47 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: csum failure messages
Date: Tue, 5 Nov 2013 12:24:43 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201311051224.44255.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The below messages are from dmesg on a system where "btrfs balance" just 
aborted.  It's running kernel 3.11.6 (the latest Debian package).

This seems to be telling me that Inode 388 is involved, but there are over 300 
subvols on that system which could contain such an Inode.

I think that more information is needed for such log messages.  We need to at 
least be able to identify the subvol (is it possible to extract this from the 
numbers in the log messages?).  Ideally we would be able to identify the file 
name as well.


[10751.637517] BTRFS info (device sda3): csum failed ino 388 off 23191552 csum 
2566472073 private 3193692311
[10751.646390] BTRFS info (device sda3): csum failed ino 388 off 24104960 csum 
5219137 private 2264608335
[10751.654472] BTRFS info (device sda3): csum failed ino 388 off 24154112 csum 
4084831521 private 1792217768
[10751.731830] BTRFS info (device sda3): csum failed ino 388 off 23191552 csum 
2566472073 private 3193692311

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
