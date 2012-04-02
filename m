From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: btrfs: enhance transaction abort infrastructure
Date: Mon, 2 Apr 2012 12:08:54 +0300
Message-ID: <20120402090854.GA9939@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: jeffm@suse.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

The patch 49b25e054090: "btrfs: enhance transaction abort 
infrastructure" from Mar 1, 2012, leads to the following warning:
fs/btrfs/transaction.c:137 join_transaction()
	warn: inconsistent returns spin_lock:&root->fs_info->trans_lock:
	locked (77) unlocked  (64,70,82,88,137)

fs/btrfs/transaction.c
    74          cur_trans = root->fs_info->running_transaction;
    75          if (cur_trans) {
    76                  if (cur_trans->aborted)
    77                          return cur_trans->aborted;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
Should we do a spin_unlock(&root->fs_info->trans_lock); here before
returning?

    78                  atomic_inc(&cur_trans->use_count);
    79                  atomic_inc(&cur_trans->num_writers);
    80                  cur_trans->num_joined++;
    81                  spin_unlock(&root->fs_info->trans_lock);
    82                  return 0;
    83          }
    84          spin_unlock(&root->fs_info->trans_lock);

Also later on:

  1399          ret = commit_fs_roots(trans, root);
  1400          if (ret) {
  1401                  mutex_unlock(&root->fs_info->tree_log_mutex);
  1402                  goto cleanup_transaction;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^
  1403          }
  1404  
  1405          /* commit_fs_roots gets rid of all the tree log roots, it is now
  1406           * safe to free the root of tree log roots
  1407           */
  1408          btrfs_free_log_root_tree(trans, root->fs_info);
  1409  
  1410          ret = commit_cowonly_roots(trans, root);
  1411          if (ret) {
  1412                  mutex_unlock(&root->fs_info->tree_log_mutex);
  1413                  goto cleanup_transaction;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^

Should we do an mutex_unlock(&root->fs_info->reloc_mutex); before these
two gotos?

  1414          }

regards,
dan carpenter

