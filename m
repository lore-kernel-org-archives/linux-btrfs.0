Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36246 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWORX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 May 2014 10:17:23 -0400
Date: Fri, 23 May 2014 07:17:22 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org, takeuchi_satoru@jp.fujitsu.com
Subject: Re: 3.15.0-rc5: now sync and mount are hung on call_rwsem_down_write_failed
Message-ID: <20140523141722.GA11991@merlins.org>
References: <20140522090921.GA12037@merlins.org> <20140522131528.GB22952@merlins.org> <pan$ed92c$6d9566f6$dd2041b0$f135597e@cox.net> <20140523002243.GE12312@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140523002243.GE12312@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had btrfs send/receive running.

Plugging the power in caused laptop-mode to remount my root partition.

That hung, and in turn all of btrfs hung too.

 7668 root     btrfs send home_ro.20140523 -
 7669 root     btrfs receive /mnt/btrfs_po sleep_on_page
12118 root     mount /dev/mapper/cryptroot call_rwsem_down_write_failed
10678 merlin   mencoder -passlogfile dsc04 sleep_on_page

Clearly, it takes very little for 3.15rc5 to deadlock :(

(I wasn't running balance or snapshot this time)

I was able to kill btrfs send and receive, but mencoder is very hung, and
sync does not finish either:
10654 merlin   sync                        sync_inodes_sb
17191 merlin   sync                        call_rwsem_down_read_failed

I'm not posting the sysrq-w every time, but I have it available if needed.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
