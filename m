Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:45444 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab2FLRdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 13:33:07 -0400
Message-ID: <4FD77D52.8000203@zabbo.net>
Date: Tue, 12 Jun 2012 10:33:06 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-btrfs@vger.kernel.org, wfg@linux.intel.com
Subject: Re: [PATCH] Btrfs: use rcu to protect device->name V2
References: <1339421426-1921-1-git-send-email-josef@redhat.com> <4FD65ECA.1030502@zabbo.net> <20120612134318.GD1565@localhost.localdomain>
In-Reply-To: <20120612134318.GD1565@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> #define device_name_printk(dev, level, fmt, ...) do {		\
> 	struct rcu_string *name;				\
> 								\
> 	rcu_read_lock();					\
> 	name = rcu_dereference(dev->name);			\
> 	printk(level "%s: " fmt, name->str, ##__VA_ARGS__);	\
> 	rcu_read_unlock();					\
> 	} while (0)

Right, that has the same problem of limiting flexibility in the device
name args.  That's why I gave that example of a specific macro for
dereferencing a device name arg's rcu_string.

Does this diff make it more clear?  It's generated on your patch, only
build tested..

- z

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 2c07e80..614024e 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -844,18 +844,13 @@ static int btrfsic_process_superblock_dev_mirror(
  		superblock_tmp->never_written = 0;
  		superblock_tmp->mirror_num = 1 + superblock_mirror_num;
  		if (state->print_mask & BTRFSIC_PRINT_MASK_SUPERBLOCK_WRITE) {
-			struct rcu_string *name;
-
-			rcu_read_lock();
-			name = rcu_dereference(device->name);
-			printk(KERN_INFO "New initial S-block (bdev %p, %s)"
+			printk_in_rcu(KERN_INFO "New initial S-block (bdev %p, %s)"
  			       " @%llu (%s/%llu/%d)\n",
-			       superblock_bdev, name->str,
+			       superblock_bdev, rcu_str_deref(device->name),
  			       (unsigned long long)dev_bytenr,
  			       dev_state->name,
  			       (unsigned long long)dev_bytenr,
  			       superblock_mirror_num);
-			rcu_read_unlock();
  		}
  		list_add(&superblock_tmp->all_blocks_node,
  			 &state->all_blocks_list);
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
index 4af8f61..a3a86bb 100644
--- a/fs/btrfs/rcu-string.h
+++ b/fs/btrfs/rcu-string.h
@@ -37,3 +37,14 @@ static inline void rcu_string_free(struct rcu_string 
*str)
  	if (str)
  		kfree_rcu(str, rcu);
  }
+
+#define printk_in_rcu(args...) do {	\
+	rcu_read_lock();		\
+	printk(##args);			\
+	rcu_read_unlock();		\
+} while (0)
+
+#define rcu_str_deref(rcu_str) ({				\
+	struct rcu_string *__str = rcu_dereference(rcu_str);	\
+	__str->str;						\
+})
