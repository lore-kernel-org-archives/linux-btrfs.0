From: Jiri Slaby <jirislaby@gmail.com>
Subject: BTRFS: unreachable code found
Date: Fri, 13 Nov 2009 11:32:59 +0100
Message-ID: <4AFD35DB.6050604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Cc: zheng.yan@oracle.com, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Stanse found unreachable code in btrfs_insert_some_items below (don't
look at the line numbers, they are on preprocessed code). I would fix
that if I knew how.

Should the assignment be after the if, before the break or nowhere?

 3068|int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 3069|       struct btrfs_root *root,
 3070|       struct btrfs_path *path,
 3071|       struct btrfs_key *cpu_key, u32 *data_size,
 3072|       int nr)
 3073|{
...
 3086| for (i = 0; i < nr; i++) {
 3087|  if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 3088|      (((root->leafsize) - sizeof(struct btrfs_header)))) {
 3089|   break;
 3090|   nr = i;
     |This node is unreachable prev next
 3091|  }
 3092|  total_data += data_size[i];
 3093|  total_size += data_size[i] + sizeof(struct btrfs_item);
 3094| }

regards,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
