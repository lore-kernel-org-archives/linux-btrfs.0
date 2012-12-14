Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40425 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab2LNRwa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 12:52:30 -0500
Date: Fri, 14 Dec 2012 20:52:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        kbuild@01.org
Subject: [josef-btrfs:master 105/117] fs/btrfs/tree-log.c:3401
 log_one_extent() error: double unlock 'irq:'
Message-ID: <20121214175216.GB5083@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

FYI, there are new smatch warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git master
head:   39a6066ac26f336b444c666a4b7339078ebf19b1
commit: 2d6d440d12fe9999503bc909f9f9e1fe8771d84f [105/117] Btrfs: wait on ordered extents at the last possible moment

  fs/btrfs/tree-log.c:3401 log_one_extent() error: double unlock 'spin_lock:&log->log_extents_lock[index]'
+ fs/btrfs/tree-log.c:3401 log_one_extent() error: double unlock 'irq:'

git remote add josef-btrfs git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
git remote update josef-btrfs
git checkout 2d6d440d12fe9999503bc909f9f9e1fe8771d84f
vim +3401 fs/btrfs/tree-log.c

2d6d440d Josef Bacik 2012-10-12  3385  			    mod_start + mod_len)
2d6d440d Josef Bacik 2012-10-12  3386  				mod_len = 0;
2d6d440d Josef Bacik 2012-10-12  3387  		} else {
2d6d440d Josef Bacik 2012-10-12  3388  			if (ordered->file_offset + ordered->len <
2d6d440d Josef Bacik 2012-10-12  3389  			    mod_start + mod_len) {
2d6d440d Josef Bacik 2012-10-12  3390  				mod_len = (mod_start + mod_len) -
2d6d440d Josef Bacik 2012-10-12  3391  					(ordered->file_offset + ordered->len);
2d6d440d Josef Bacik 2012-10-12  3392  				mod_start = ordered->file_offset +
2d6d440d Josef Bacik 2012-10-12  3393  					ordered->len;
2d6d440d Josef Bacik 2012-10-12  3394  			} else {
2d6d440d Josef Bacik 2012-10-12  3395  				mod_len = 0;
2d6d440d Josef Bacik 2012-10-12  3396  			}
2d6d440d Josef Bacik 2012-10-12  3397  		}
2d6d440d Josef Bacik 2012-10-12  3398  
2d6d440d Josef Bacik 2012-10-12  3399  		spin_lock_irq(&log->log_extents_lock[index]);
2d6d440d Josef Bacik 2012-10-12  3400  	}
2d6d440d Josef Bacik 2012-10-12 @3401  	spin_unlock_irq(&log->log_extents_lock[index]);
2d6d440d Josef Bacik 2012-10-12  3402  
2d6d440d Josef Bacik 2012-10-12  3403  	if (!mod_len || ret)
2d6d440d Josef Bacik 2012-10-12  3404  		return ret;
2d6d440d Josef Bacik 2012-10-12  3405  
2d6d440d Josef Bacik 2012-10-12  3406  	csum_offset = mod_start - em->start;
2d6d440d Josef Bacik 2012-10-12  3407  	csum_len = mod_len;
2d6d440d Josef Bacik 2012-10-12  3408  
8a868ae3 Josef Bacik 2012-10-11  3409  	/* block start is already adjusted for the file extent offset. */

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
