Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34015 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab3BBVEB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Feb 2013 16:04:01 -0500
Received: from compute2.internal (compute2.nyi.mail.srv.osa [10.202.2.42])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 6301220CE5
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Feb 2013 16:04:01 -0500 (EST)
Received: from doppelganger.localnet (unknown [70.226.166.121])
	by mail.messagingengine.com (Postfix) with ESMTPA id E2706482571
	for <linux-btrfs@vger.kernel.org>; Sat,  2 Feb 2013 16:04:00 -0500 (EST)
From: CSights <csights@fastmail.fm>
To: linux-btrfs@vger.kernel.org
Subject: cannot mount with acl
Date: Sat, 2 Feb 2013 15:03:48 -0600
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201302021503.48064.csights@fastmail.fm>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
  btrfs is failing to mount if I use the mount option acl.
  I am running debian testing with a debian experimental version of kernel 
3.7.3:

uname -a
Linux nimby 3.7-trunk-486 #1 Debian 3.7.3-1~experimental.1 i686 GNU/Linux

from fstab
LABEL=btrfs-exthd   /mnt/exthd      btrfs   defaults,noatime,compress=zlib,acl 
0 2

from dmesg
[   14.785716] device label btrfs-exthd devid 1 transid 2894 /dev/sdb1
[   14.807860] btrfs: use zlib compression
[   14.823480] btrfs: unrecognized mount option 'acl'
[   14.839605] btrfs: open_ctree failed

Can someone confirm for me that btrfs can mount with these options on their 
3.7 kernel?

Please CC me directly, I am not subscribed to the list.

Thank you!
 C.
