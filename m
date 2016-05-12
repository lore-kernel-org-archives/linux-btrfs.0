Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbcELJKo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 05:10:44 -0400
Date: Thu, 12 May 2016 11:10:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Mark Fasheh <mfasheh@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: [PATCH v4] btrfs: qgroup: Fix qgroup accounting when creating
 snapshot
Message-ID: <20160512091021.GK29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460711302-2478-1-git-send-email-quwenruo@cn.fujitsu.com>
 <571A697B.6050502@fb.com>
 <20160511165739.GH7633@wotan.suse.de>
 <754c27f2-4f00-da85-9a86-fe5f008a66c0@fb.com>
 <20160511195352.GI7633@wotan.suse.de>
 <beed8ba2-2d01-317b-5c9d-46c39745ed58@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <beed8ba2-2d01-317b-5c9d-46c39745ed58@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 01:30:21PM -0700, Josef Bacik wrote:
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> Reviewed-by: Josef Bacik <jbacik@fb.com>

Applied to for-next with the following fixup to make it bisectable:

---
    btrfs: build fixup for qgroup_account_snapshot

    The macro btrfs_std_error got renamed to btrfs_handle_fs_error in an
    independent branch for the same merge target (4.7). To make the code
    compilable for bisectability reasons, add a temporary stub.

    Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d7172d7ced5f..530081388d77 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1311,6 +1311,11 @@ int btrfs_defrag_root(struct btrfs_root *root)
        return ret;
 }

+/* Bisesctability fixup, remove in 4.8 */
+#ifndef btrfs_std_error
+#define btrfs_std_error btrfs_handle_fs_error
+#endif
+
 /*
  * Do all special snapshot related qgroup dirty hack.
  *
---
