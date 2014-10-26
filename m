Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:50444 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaJZBvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Oct 2014 21:51:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 75548405F8
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 12:51:23 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 22255-10 for <linux-btrfs@vger.kernel.org>;
 Sun, 26 Oct 2014 12:51:23 +1100 (AEDT)
Received: from quad.localnet (2001-44b8-41dd-d500-adbf-d613-85ec-96d9.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:adbf:d613:85ec:96d9])
	by csamuel.org (Postfix) with ESMTPSA id 0A59C405F1
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Oct 2014 12:51:23 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance segfault, kernel BUG at fs/btrfs/extent-tree.c:7727
Date: Sun, 26 Oct 2014 12:51:28 +1100
Message-ID: <1806363.zv92A65W1k@quad>
In-Reply-To: <CAGfcS_kFnqp5aeHMfTLJbTbVx=yobNf+Zp-ECYh1xNRFG7UjaA@mail.gmail.com>
References: <20141009141944.GA11525@atrey.karlin.mff.cuni.cz> <CAGfcS_nR-MP8VLWanvvs9dMQBi02JoCCUTYd_JwA9tmtPRGmSg@mail.gmail.com> <CAGfcS_kFnqp5aeHMfTLJbTbVx=yobNf+Zp-ECYh1xNRFG7UjaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 25 Oct 2014 09:41:27 PM Rich Freeman wrote:

> So, there is something else in 3.17.1 that causes
> this problem.  I did see mention of an extent error of some kind on
> the lists and I don't have that patch - I believe it is planned for
> 3.17.2.

There are currently 13 patches for btrfs queued for 3.17.2:

queue-3.17/btrfs-add-missing-compression-property-remove-in-btrfs_ioctl_setflags.patch                                                                                                                                                       
queue-3.17/btrfs-cleanup-error-handling-in-build_backref_tree.patch                                                                                                                                                                          
queue-3.17/btrfs-don-t-do-async-reclaim-during-log-replay.patch                                                                                                                                                                              
queue-3.17/btrfs-don-t-go-readonly-on-existing-qgroup-items.patch                                                                                                                                                                            
queue-3.17/btrfs-fix-a-deadlock-in-btrfs_dev_replace_finishing.patch                                                                                                                                                                         
queue-3.17/btrfs-fix-and-enhance-merge_extent_mapping-to-insert-best-fitted-extent-map.patch                                                                                                                                                 
queue-3.17/btrfs-fix-build_backref_tree-issue-with-multiple-shared-blocks.patch                                                                                                                                                              
queue-3.17/btrfs-fix-race-in-wait_sync-ioctl.patch                                                                                                                                                                                           
queue-3.17/btrfs-fix-the-wrong-condition-judgment-about-subset-extent-map.patch                                                                                                                                                              
queue-3.17/btrfs-fix-up-bounds-checking-in-lseek.patch                                                                                                                                                                                       
queue-3.17/btrfs-try-not-to-enospc-on-log-replay.patch                                                                                                                                                                                       
queue-3.17/btrfs-wake-up-transaction-thread-from-sync_fs-ioctl.patch                                                                                                                                                                         
queue-3.17/revert-btrfs-race-free-update-of-commit-root-for-ro-snapshots.patch

You can grab them here:

http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git/tree/queue-3.17

Hope this helps!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


