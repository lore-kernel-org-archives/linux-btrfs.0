Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:54342 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753237Ab3AaABh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:01:37 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/11] btrfs: misc fixes and cleanups
Date: Wed, 30 Jan 2013 18:54:51 -0600
Message-Id: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A handful of fixes from looking at Coverity static checker
results, and the surrounding code.  Of varying severity,
but all worthwhile I hope.

Full disclosure: compile-tested only, but nothing too crazy
in here I think.

Thanks,
-Eric

[PATCH 01/11] btrfs: remove unused fd in btrfs_ioctl_send()
[PATCH 02/11] btrfs: list_entry can't return NULL
[PATCH 03/11] btrfs: remove unused fs_info from btrfs_decode_error()
[PATCH 04/11] btrfs: handle null fs_info in btrfs_panic()
[PATCH 05/11] btrfs: annotate intentional switch case fallthroughs
[PATCH 06/11] btrfs: add missing break in btrfs_print_leaf()
[PATCH 07/11] btrfs: fix varargs in __btrfs_std_error
[PATCH 08/11] btrfs: remove unused "item" in btrfs_insert_delayed_item()
[PATCH 09/11] btrfs: remove unnecessary DEFINE_WAIT() declarations
[PATCH 10/11] btrfs: ensure we don't overrun devices_info[] in __btrfs_alloc_chunk
[PATCH 11/11] btrfs: don't try to notify udev about missing devices
