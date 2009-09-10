From: Premysl Hruby <dfenze@gmail.com>
Subject: slight simplification in transaction.c
Date: Thu, 10 Sep 2009 23:04:49 +0200
Message-ID: <20090910210449.GA5329@baldr.the>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

While reading source, I found possible simplification 
in btrfs_record_root_in_trans 

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cdbb502..7cd7bf9 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -123,12 +123,9 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
                return 0;
 
        mutex_lock(&root->fs_info->trans_mutex);
-       if (root->last_trans == trans->transid) {
-               mutex_unlock(&root->fs_info->trans_mutex);
-               return 0;
-       }
+       if (root->last_trans != trans->transid)
+               record_root_in_trans(trans, root);
 
-       record_root_in_trans(trans, root);
        mutex_unlock(&root->fs_info->trans_mutex);
        return 0;
 }


-- 
Premysl "Anydot" Hruby, http://www.redrum.cz/
-
I'm a signature virus. Please add me to your signature and help me spread!
