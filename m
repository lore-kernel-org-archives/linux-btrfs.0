Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40678 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab1EJTzB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2011 15:55:01 -0400
From: y@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <chris.mason@oracle.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH v2 0/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
Date: Tue, 10 May 2011 22:57:26 +0300
Message-Id: <1305057449-12075-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sergei Trofimovich <slyfox@gentoo.org>

The really interesting commit is
    [PATCH 1/3] btrfs: don't spin in shrink_delalloc if there is nothing to free
which fixes hogs on ENOSPC for me.

The rest of patches are cleanup.

Change since v1:
- Added Josef's Reviewed-by
- Fixed my MTA and patch numbering

Thanks!
