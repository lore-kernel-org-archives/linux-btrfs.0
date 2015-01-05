Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22780 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751120AbbAEGTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 01:19:55 -0500
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <takeuchi_satoru@jp.fujitsu.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH v3 0/3] Btrfs: Enhancment for qgroup.
Date: Mon, 5 Jan 2015 14:16:41 +0800
Message-ID: <1420438604-4846-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <549CF56A.2050400@jp.fujitsu.com>
References: <549CF56A.2050400@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef and others,

This patch set is about enhancing qgroup.

[1/3]: fix a bug about qgroup leak when we exceed quota limit,
	It is reviewd by Josef.
[2/3]: introduce a new accounter in qgroup to close a window where
	user will exceed the limit by qgroup. It "looks good" to Josef.
[3/3]: a new patch to fix a bug reported by Satoru.

BTW, I have some other plan about qgroup in my TODO list:

Kernel:
a). adjust the accounters in parent qgroup when we move
the child qgroup.
	Currently, when we move a qgroup, the parent qgroup
will not updated at the same time. This will cause some wrong
numbers in qgroup.

b). add a ioctl to show the qgroup info.
	Command "btrfs qgroup show" is showing the qgroup info
read from qgroup tree. But there is some information in memory
which is not synced into device. Then it will show some outdate
number.

c). limit and account size in 3 modes, data, metadata and both.
	qgroup is accounting the size both of data and metadata
togather, but to a user, the data size is the most useful to them.

d). remove a subvolume related qgroup when subvolume is deleted and
there is no other reference to it.

user-tool:
a). Add the unit of B/K/M/G to btrfs qgroup show.
b). get the information via ioctl rather than reading it from
btree. Will keep the old way as a fallback for compatiblity.

Any comment and sugguestion is welcome. :)

Yang

Dongsheng Yang (3):
  Btrfs: qgroup: free reserved in exceeding quota.
  Btrfs: qgroup: Introduce a may_use to account
    space_info->bytes_may_use.
  Btrfs: qgroup, Account data space in more proper timings.

 fs/btrfs/extent-tree.c | 41 +++++++++++++++++++++++-------
 fs/btrfs/file.c        |  9 -------
 fs/btrfs/inode.c       | 18 ++++++++++++-
 fs/btrfs/qgroup.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/qgroup.h      |  4 +++
 5 files changed, 117 insertions(+), 23 deletions(-)

-- 
1.8.4.2

