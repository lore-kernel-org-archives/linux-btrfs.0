Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59494 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab3KTI3o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 03:29:44 -0500
Received: from [39.217.184.150] (port=48080 helo=gandalfthegreat.merlins.org)
	by mail1.merlins.org with esmtpa (Exim 4.80 #2)
	id 1Vj396-0007hB-Ky by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 00:29:43 -0800
Received: from merlin by gandalfthegreat.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@gandalfthegreat.merlins.org>)
	id 1ViyRa-0008EC-3B
	for linux-btrfs@vger.kernel.org; Tue, 19 Nov 2013 19:27:10 -0800
Date: Tue, 19 Nov 2013 19:27:10 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs still core dumps
Message-ID: <20131120032710.GN6696@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is another way in which btrfs-tools crashes if it sees things it
doesn't like.

Is anyone interested in those, or not really?

gandalfthegreat:/tmp# btrfs-find-root /dev/mapper/ssdcrypt 
Check tree block failed, want=20971520, have=10422900740180685247
Check tree block failed, want=20971520, have=10422900740180685247
Check tree block failed, want=20971520, have=9351833364687311396
Check tree block failed, want=20971520, have=9351833364687311396
Check tree block failed, want=20971520, have=9351833364687311396
read block failed check_tree_block
Couldn't read chunk root
Segmentation fault (core dumped)

btrfs-tools 0.19+20130705-3
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
