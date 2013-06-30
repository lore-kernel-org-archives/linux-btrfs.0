Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37527 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3F3Nzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Jun 2013 09:55:52 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4B95B7C067F
	for <linux-btrfs@vger.kernel.org>; Sun, 30 Jun 2013 07:55:51 -0600 (MDT)
Date: Sun, 30 Jun 2013 09:55:48 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: hold the tree mod lock in __tree_mod_log_rewind
Message-ID: <20130630135548.GC4288@localhost.localdomain>
References: <1372562251-27123-1-git-send-email-jbacik@fusionio.com>
 <51CFEB61.1040008@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51CFEB61.1040008@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 30, 2013 at 10:25:05AM +0200, Jan Schmidt wrote:
> On 30.06.2013 05:17, Josef Bacik wrote:
> > We need to hold the tree mod log lock in __tree_mod_log_rewind since we walk
> > forward in the tree mod entries, otherwise we'll end up with random entries and
> > trip the BUG_ON() at the front of __tree_mod_log_rewind.  This fixes the panics
> > people were seeing when running
> > 
> > find /whatever -type f -exec btrfs fi defrag {} \;
> 
> This patch cannot help to solve the problem, as far as I've understood
> what is going on. It does change timing, though, which presumably makes
> it pass the current reproducer we're having.
> 
> On rewinding, iteration through the tree mod log rb-tree goes backwards
> in time, which means that once we've found our staring point we cannot
> be trapped by later additions. The old items we're rewinding towards
> cannot be freed, because we've allocated a blocker element within the
> tree and rewinding never goes beyond the allocated blocker. The blocker
> element is allocated by btrfs_get_tree_mod_seq and mostly referred to as
> time_seq within the other tree mod log functions in ctree.c. To sum up,
> the added lock is not required.
> 
> The debug output I've analyzed so far shows that after we've rewinded
> all REMOVE_WHILE_FREEING operations on a buffer, ordered consecutively
> as expected, there comes another REMOVE_WHILE_FREEING with a sequence
> number much further in the past for the same buffer (but that sequence
> number is still higher than out time_seq rewind barrier at that point).
> This must be a logical problem I've not completely understood so far,
> but locking doesn't seem to be the right track.
> 

Finally reproduced it, this is my output

 btrfs-endio-wri-23110 [000] ...2  9556.882103: __tree_mod_log_rewind: rewinding 15450537984
 btrfs-endio-wri-23110 [000] ...2  9556.882104: __tree_mod_log_rewind: 15450537984: processing ffff880246590a40, op 3, seq 68719476829, slot 0
 btrfs-endio-wri-23110 [000] ...2  9556.882106: __tree_mod_log_rewind: 15450537984: processing ffff880246590ac0, op 3, seq 68719476828, slot 1
 btrfs-endio-wri-23110 [000] ...2  9556.882108: __tree_mod_log_rewind: 15450537984: processing ffff880246590a40, op 3, seq 68719476829, slot 0
 btrfs-endio-wri-23110 [000] ...2  9556.882110: __tree_mod_log_rewind: 15450537984: this tm is failing, ffff880246590a40, seq 68719476829, slot 0

so I'm inclined to beleive I've got it right.  Thanks,

Josef
