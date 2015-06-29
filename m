Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3.munzinger.de ([195.226.116.139]:7852 "EHLO mx3.munzinger.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbbF2JlW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 05:41:22 -0400
Received: from imap2.munzinger.de (imap2.munzinger.de [192.168.0.106])
	by mx3.munzinger.de (Postfix) with ESMTP id 2121047AC0
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 11:35:13 +0200 (CEST)
Received: from o3-3.localnet (o3-3.munzinger.de [192.168.100.225])
	by imap2.munzinger.de (Postfix) with ESMTPSA id 1A42263665
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 11:35:13 +0200 (CEST)
From: David Weber <wb@munzinger.de>
To: linux-btrfs@vger.kernel.org
Subject: WARNING:  at /fs/btrfs/extent-tree.c:4029 btrfs_free_reserved_data_space
Date: Mon, 29 Jun 2015 11:35:12 +0200
Message-ID: <6617728.KSCQs1dauk@o3-3>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

we are testing Btrfs as a kvm storage system with 
"defaults,space_cache,nodatacow" mount options and regular snapshots. While 
testing we sometimes get these warnings:
WARNING: CPU: 5 PID: 11335 at /home/kernel/COD/linux/fs/btrfs/extent-
tree.c:4029 btrfs_free_reserved_data_space+0x102/0x110 [btrfs]()

Full log:
https://gist.github.com/anonymous/5f672f72899a3d52c20c

Once they start, they flood dmesg with several messages per second. After a 
reboot, it takes a while until they start to appear again. 
We have seen them with Linux 4.0.6 and 4.1

This was already reported a few times:
https://bugzilla.opensuse.org/show_bug.cgi?id=904023
https://bugzilla.redhat.com/show_bug.cgi?id=1173937
http://www.spinics.net/lists/linux-btrfs/msg39069.html
https://lkml.org/lkml/2014/10/22/899

Always with no solution
Is this a real problem or can we safely ignore this?

Cheers,
David
