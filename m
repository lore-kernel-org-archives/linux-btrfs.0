Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:32953 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3G1Gv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jul 2013 02:51:27 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 599003878EF
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 08:51:23 +0200 (CEST)
Received: from localhost (ppp-58-8-14-23.revip2.asianet.co.th [58.8.14.23])
	by mail.virtall.com (Postfix) with ESMTPSA id 63608387792
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 08:51:22 +0200 (CEST)
Date: Sun, 28 Jul 2013 13:51:16 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs qgroup assign -> "ERROR: bad relation requested"
Message-ID: <20130728135116.5ed992d4@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to use this feature of qgroup:

btrfs qgroup assign <srcid> <destid> <path>
    Assigns the lower level qgroup src to the higher level qgroup dest
    in the btrfs found in <path>. It is used to build qgroup
    hierarchies.


However, I fail to understand how this feature should work, and I'm
getting "ERROR: bad relation requested":

# btrfs sub create test1
Create subvolume './test1'

# btrfs sub create test2
Create subvolume './test2'

# btrfs sub list /mnt/lxc2 | grep test
ID 1177 gen 85131 top level 5 path test1
ID 1178 gen 85132 top level 5 path test2

# btrfs qgroup show /mnt/lxc2
0/1177 4096 4096
0/1178 4096 4096

# btrfs qgroup assign 1177 1178 /mnt/lx2
ERROR: bad relation requested '/mnt/lx2'


Could anyone give examples of proper usage of this feature?

This is Linux 3.10.


-- 
Tomasz Chmielewski
http://wpkg.org
