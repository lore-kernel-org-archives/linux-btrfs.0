Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:34014 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbaJTJOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 05:14:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 646CB400B8
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 20:14:09 +1100 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 29929-10 for <linux-btrfs@vger.kernel.org>;
 Mon, 20 Oct 2014 20:14:09 +1100 (EST)
Received: from quad.localnet (2001-44b8-41dd-d500-7c09-6e1b-3563-d195.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:7c09:6e1b:3563:d195])
	by csamuel.org (Postfix) with ESMTPSA id F0CE440016
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 20:14:08 +1100 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Date: Mon, 20 Oct 2014 20:14:12 +1100
Message-ID: <2588267.pfc4WIxGVz@quad>
In-Reply-To: <12404322.5f6czpaAWj@fb07-iapwap2>
References: <20141017085448.GA1050018@mother.pipebreaker.pl> <1798492.UPHDTB8iYW@quad> <12404322.5f6czpaAWj@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 20 Oct 2014 10:01:56 AM Marc Dietrich wrote:

> so fixes would be tagged earlier this way and merged automaticly.

I don't think there's a lot automatic about stable, Greg K-H merges patches
into a git tree here:

http://git.kernel.org/cgit/linux/kernel/git/stable/stable-queue.git

As you can see since last night he pulled in a bunch of btrfs fixes into that
based upon what Chris Mason emailed out yesterday.


commit 2792dbfd1e02a70a8eef7e0cc3f44cb77d6c100f
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon Oct 20 07:08:43 2014 +0800

    3.17-stable patches
    
    added patches:
        btrfs-add-missing-compression-property-remove-in-btrfs_ioctl_setflags.patch
        btrfs-cleanup-error-handling-in-build_backref_tree.patch
        btrfs-don-t-do-async-reclaim-during-log-replay.patch
        btrfs-don-t-go-readonly-on-existing-qgroup-items.patch
        btrfs-fix-a-deadlock-in-btrfs_dev_replace_finishing.patch
        btrfs-fix-and-enhance-merge_extent_mapping-to-insert-best-fitted-extent-map.patch
        btrfs-fix-build_backref_tree-issue-with-multiple-shared-blocks.patch
        btrfs-fix-race-in-wait_sync-ioctl.patch
        btrfs-fix-the-wrong-condition-judgment-about-subset-extent-map.patch
        btrfs-fix-up-bounds-checking-in-lseek.patch
        btrfs-try-not-to-enospc-on-log-replay.patch
        btrfs-wake-up-transaction-thread-from-sync_fs-ioctl.patch
        revert-btrfs-race-free-update-of-commit-root-for-ro-snapshots.patch

(there are also a bunch going in for 3.10, 3.14 and 3.16 too)

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


