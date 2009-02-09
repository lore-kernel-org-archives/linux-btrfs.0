From: sniper <s3c24xx@gmail.com>
Subject: code problem report
Date: Mon, 9 Feb 2009 21:06:53 +0800
Message-ID: <9bd6b5360902090506x36670c14sc46b0f9458842e3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 31 int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 32                         struct btrfs_root *root, int cache_only)
 33 {
...
 45         if (cache_only)   //check once
 46                 goto out;
....
 79                 root->defrag_max.objectid = 0;  //needless? The
following code will rewrite soon.
 80                 /* from above we know this is not a leaf */
 81                 btrfs_node_key_to_cpu(root_node, &root->defrag_max,
 82                                       nritems - 1);
...
 91         if (cache_only)   //?check again. It seems no one can
modify 'cache_only', which check is needless or wrong?
 92                 min_trans = root->defrag_trans_start;
...
129 out:
