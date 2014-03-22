Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49066 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCVVE4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 17:04:56 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WRT68-0002eC-3J
	for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 14:04:56 -0700
Date: Sat, 22 Mar 2014 14:04:56 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive still gets out of sync in 3.14.0
Message-ID: <20140322210455.GL28005@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After deleting a huge directory tree in my /home subvolume, syncing
snapshots now fails with:

ERROR: rmdir o1952777-157-0 failed. No such file or directory
Error line 156 with status 1

 DIE: Code dump:
   153	if [[ -n "$init" ]]; then
   154	    btrfs send "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
   155	else
   156	    btrfs send -p "$src_snap" "$src_newsnap" | $ssh btrfs receive "$dest_pool/"
   157	fi
   158	
   159	# We make a read-write snapshot in case you want to use it for a chroot


Is there anything useful I can provide before killing my snapshot and doing
a full sync again?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
