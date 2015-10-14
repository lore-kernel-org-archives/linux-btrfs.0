Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbbJNH2V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 03:28:21 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: [PATCH 1/2] btrfs: Remove empty header file extent-tree.h
Date: Wed, 14 Oct 2015 15:26:12 +0800
Message-ID: <1444807573-29853-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1444807573-29853-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The empty file is introduced as an careless 'git add' during the qgroup
accounting framework rework.

Just remove it.

Reported-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.h | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 fs/btrfs/extent-tree.h

diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
deleted file mode 100644
index e69de29..0000000
-- 
2.6.1

