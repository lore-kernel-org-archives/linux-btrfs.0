From: Goffredo Baroncelli <kreijack@libero.it>
Subject: [BUG] Calling BTRFS_IOC_TREE_SEARCH for a non existant key
Date: Sun, 19 Dec 2010 17:19:14 +0100
Message-ID: <201012191719.15182.kreijack@libero.it>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Cc: Li Zefan <lizf@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I discovered that when I call the BTRFS_IOC_TREE_SEARCH ioctl for a not 
existent key, the ioctl requires a lot of time to be completed.

I tracks down the problem in the function search_ioctl(). It seems that the 
function btrfs_search_forward() doesn't check if key is greater than max_key. 

file ioctl.c
       
   988	static noinline int search_ioctl(struct inode *inode,
   989					 struct btrfs_ioctl_search_args *args)
[...]
  1025		while(1) {
  1026			ret = btrfs_search_forward(root, &key, &max_key, path, 
0,
  1027						   sk->min_transid);
  1028			if (ret != 0) {
  1029				if (ret > 0)
  1030					ret = 0;
  1031				goto err;
  1032			}
  1033			ret = copy_to_sk(root, path, &key, sk, args->buf,
  1034					 &sk_offset, &num_found);
  1035			btrfs_release_path(root, path);
  1036			if (ret || num_found >= sk->nr_items)
  1037				break;
       
  1038		}

The function btrfs_search_forward() doesn't check the key (or min_key) against 
max_key when the parameter cache_only == 0.

from ctree.c

  3624  int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key 
*min_key,
  3625                           struct btrfs_key *max_key,
  3626                           struct btrfs_path *path, int cache_only,
  3627                           u64 min_trans)
  3628  {
[..]
  3678                          if (!cache_only)
  3679                                  break;
       
  3680                          if (max_key) {
  3681                                  btrfs_node_key(cur, &disk_key, slot);
  3682                                  if (comp_keys(&disk_key, max_key) >= 
0) {
  3683                                          ret = 1;
  3684                                          goto out;
  3685                                  }
  3686                          }
       


So in the function search_ioctl the search is not completed until the "args" 
buffer is filled or the function copy_to_sk detects that key is greater than 
sk->max_*. 

However the check performed by the function copy_to_sk is not always 
sufficient to detect if a key is greater than sk->max_*. For example if 
key.objectid > sk->max_objectid but key.offset is < sk->max_offset, the key is 
supposed to be valid.

   913	static noinline int copy_to_sk(struct btrfs_root *root,
[...]
   970		}
   971	advance_key:
   972		ret = 0;
   973		if (key->offset < (u64)-1 && key->offset < sk->max_offset)
   974			key->offset++;
   975		else if (key->type < (u8)-1 && key->type < sk->max_type) {
   976			key->offset = 0;
   977			key->type++;
   978		} else if (key->objectid < (u64)-1 && key->objectid < sk-
>max_objectid) {
   979			key->offset = 0;
   980			key->type = 0;
   981			key->objectid++;
   982		} else
   983			ret = 1;
   984	overflow:
   985		*num_found += found;
   986		return ret;
   987	}
      
To solve this problem it should be sufficient a key check before the call of 
btrfs_search_forward(). 
But I don't know if this is a workaround or the root cause is inside the 
function btrfs_search_forward() that doesn't check the key against max_key if 
cached_only is 0.


Regards
G.Baroncelli

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
