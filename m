Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:45562 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDGQFH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 12:05:07 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1WXC2k-0006Lc-MM
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 09:05:06 -0700
Date: Mon, 7 Apr 2014 09:05:06 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
Message-ID: <20140407160506.GG10789@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was debugging my why backup failed to run, and eventually found it was
stuck on sync:
14080       18:18 btrfs_tree_read_lock           sync

This was hung for hours on this lock.

Strangely, it looks like taking my sysrq-w hung the machine pretty hard for
close to 30sec, but this seems to have unhung sync and in the end btrfs send
completed after that.

Sysqrq-w is here:
http://marc.merlins.org/tmp/sysrq-btrfs-sync-hang.txt

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
