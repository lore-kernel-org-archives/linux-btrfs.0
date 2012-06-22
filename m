Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:48449 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab2FVGpP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jun 2012 02:45:15 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q5M6jEHR020729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 06:45:14 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q5M6jDrg009679
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 06:45:13 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q5M6jDXG013528
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2012 01:45:13 -0500
Date: Fri, 22 Jun 2012 09:45:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [report] NULL dereference in __update_reloc_root()
Message-ID: <20120622064506.GA25515@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Btrfs devs,

The patch 5d4f98a28c7d: "Btrfs: Mixed back reference  (FORWARD
ROLLING FORMAT CHANGE)" from Jun 10, 2009, leads to the following
warning:
fs/btrfs/relocation.c:1270 __update_reloc_root()
	 error: potential NULL dereference 'node'.

fs/btrfs/relocation.c
  1255  static int __update_reloc_root(struct btrfs_root *root, int del)
  1256  {
  1257          struct rb_node *rb_node;
  1258          struct mapping_node *node = NULL;
  1259          struct reloc_control *rc = root->fs_info->reloc_ctl;
  1260  
  1261          spin_lock(&rc->reloc_root_tree.lock);
  1262          rb_node = tree_search(&rc->reloc_root_tree.rb_root,
  1263                                root->commit_root->start);
  1264          if (rb_node) {
  1265                  node = rb_entry(rb_node, struct mapping_node, rb_node);
                        ^^^^^^^^^^^^^^^^
Node is only non-NULL if "rb_node" is non-NULL.

  1266                  rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
  1267          }
  1268          spin_unlock(&rc->reloc_root_tree.lock);
  1269  
  1270          BUG_ON((struct btrfs_root *)node->data != root);
                                            ^^^^^^^^^^

Null dereference.

  1271  
  1272          if (!del) {
  1273                  spin_lock(&rc->reloc_root_tree.lock);
  1274                  node->bytenr = root->node->start;
                        ^^^^^^^^^^^^
We assume "node" is non-NULL on this side of the if else statement.

  1275                  rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
  1276                                        node->bytenr, &node->rb_node);
  1277                  spin_unlock(&rc->reloc_root_tree.lock);
  1278                  if (rb_node)
  1279                          backref_tree_panic(rb_node, -EEXIST, node->bytenr);
  1280          } else {
  1281                  spin_lock(&root->fs_info->trans_lock);
  1282                  list_del_init(&root->root_list);
  1283                  spin_unlock(&root->fs_info->trans_lock);
  1284                  kfree(node);
                        ^^^^^^^^^^^
And here as well I guess.

  1285          }
  1286          return 0;

regards,
dan carpenter

