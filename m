Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:49186 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab3CPMCW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 08:02:22 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 3433B228CB0
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 23:02:20 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: multiple btrfsck runs
Date: Sat, 16 Mar 2013 23:02:14 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201303162302.14746.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Is it expected that running btrfsck more than once will keep reporting errors?

Below is the end of a btrfsck output when run the second time.

backpointer mismatch on [111942471680 32768]
owner ref check failed [111942471680 32768]
ref mismatch on [111942504448 40960] extent item 1, found 0
Incorrect local backref count on 111942504448 root 5 owner 160739 offset 
3440640 found 0 wanted 1 back 0x14331f48
backpointer mismatch on [111942504448 40960]
owner ref check failed [111942504448 40960]
Errors found in extent allocation tree
checking fs roots
root 5 inode 427603 errors 400
found 79658786895 bytes used err is 1
total csum bytes: 75604824
total tree bytes: 2109984768
total fs tree bytes: 1835044864
btree space waste bytes: 593880456
file data blocks allocated: 1065636474880
 referenced 133464895488
Btrfs Btrfs v0.19

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
