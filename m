Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62667 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3C1KyV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 06:54:21 -0400
Received: by mail-pb0-f52.google.com with SMTP id ma3so5748953pbc.25
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 03:54:20 -0700 (PDT)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: sensille@gmx.net, miaox@cn.fujitsu.com, wangsl-fnst@cn.fujitsu.com
Subject: [PATCH V2 0/6] add a mutex lock to avoid race condition and  have all the ioctls check
Date: Thu, 28 Mar 2013 18:54:15 +0800
Message-Id: <1364468055-1669-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original code has only one spin_lock 'qgroup_lock' to protect quota
configurations on memory. If we want to add a BTRFS_QGROUP_INFO_KEY,
it will be added to Btree firstly and then update quota configurations
on memory, however,a race condition may happen between these operations.
For example:
	->add_qqroup_info_item()
		->add_qgroup_rb()

For the above case, del_qgroup_info_item() may happen before add_qgroup_rb().

What's worse, when we want to add a qgroup relations:
	->add_qgroup_relation_item()
		->add_qgroup_relations()

We don't have any checks whether 'src' and 'dst' exists before
add_qgroup_relation_item(), a race condition can also happen for the above case.

To avoid race conditions and have all the necessay checks, we introduce
a mutex 'quota_lock', and we make all the user change operations protected by
the mutex_lock.

The benefit of mutex_lock is more, with a mutex lock, we can remove
some spin_lock usages thus easing the burden of spin_lock 'qgroup_lock'.

V1->V2:
	use quota configurations on memory to speed up ioctl checks
Wang Shilong (6):
  Btrfs: introduce a mutex lock for btrfs quota operations
  Btrfs: remove some unnecessary spin_lock usages
  Btrfs: fix missing check before updating qgroup limit
  Btrfs: fix missing check before creating/destroying a qgroup
  Btrfs: fix missing check before assigning/removing qgroup relation
  Btrfs: fix missing check before btrfs_qgroup_inherit()

 fs/btrfs/ctree.h   |   10 +++
 fs/btrfs/disk-io.c |    1 +
 fs/btrfs/ioctl.c   |   43 ++++++++++----
 fs/btrfs/qgroup.c  |  167 +++++++++++++++++++++++++++++++++-------------------
 4 files changed, 150 insertions(+), 71 deletions(-)

-- 
1.7.7.6

