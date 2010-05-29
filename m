From: Dan Carpenter <error27@gmail.com>
Subject: potential null derefs in fs/btrfs/relocation.c
Date: Sat, 29 May 2010 11:39:55 +0200
Message-ID: <20100529093955.GA5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: zheng.yan@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi hi,

Still going through some more smatch stuff and there are two potential
null dereferences in fs/btrfs/relocation.c

This was introduced by 3fd0a5585e: "Btrfs: Metadata ENOSPC handling for
balance"

fs/btrfs/relocation.c +791 build_backref_tree(142)
	warn: variable dereferenced before check 'root'
   787                  root = find_tree_root(rc, eb, ref0);
   788                  if (!root->ref_cows)
                             ^^^^^^^^^^^^^^
	dereference here.

   789                          cur->cowonly = 1;
   790                  if (key.objectid == key.offset) {
   791                          if (root && !should_ignore_root(root))
                                   ^^^^^^^^

	check here.

   792                                  cur->root = root;
   793                          else
   794                                  list_add(&cur->list, &useless);
   795                          break;
   796                  }

fs/btrfs/relocation.c +1241 __update_reloc_root(15)
	error: potential null derefence 'node'.
  1229          struct mapping_node *node = NULL;
                                    ^^^^^^^^^^^^^

  1230          struct reloc_control *rc = root->fs_info->reloc_ctl;
  1231  
  1232          spin_lock(&rc->reloc_root_tree.lock);
  1233          rb_node = tree_search(&rc->reloc_root_tree.rb_root,
  1234                                root->commit_root->start);
  1235          if (rb_node) {
  1236                  node = rb_entry(rb_node, struct mapping_node, rb_node);
  1237                  rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
  1238          }
  1239          spin_unlock(&rc->reloc_root_tree.lock);
  1240  
  1241          BUG_ON((struct btrfs_root *)node->data != root);
                                            ^^^^^^^^^^
	if tree_search() returns NULL it will oops here.

regards,
dan carpenter
