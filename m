Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17799 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932228AbaFTPlJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 11:41:09 -0400
Message-ID: <53A45601.9070305@fb.com>
Date: Fri, 20 Jun 2014 08:40:49 -0700
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP
 build_backref_tree+0x9fc/0xcc4
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com> <20140617185549.GP19071@merlins.org> <53A1AFB6.40906@fb.com> <20140618202135.GE19071@merlins.org> <53A30BDD.6080309@fb.com> <20140619222518.GA20894@merlins.org> <53A36928.1030104@fb.com> <20140620005359.GA10485@merlins.org>
In-Reply-To: <20140620005359.GA10485@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2014 05:53 PM, Marc MERLIN wrote:
> On Thu, Jun 19, 2014 at 03:50:16PM -0700, Josef Bacik wrote:
>> Ok same drill as before, reset and apply this, hopefully no panic this time
>>
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index 65245a0..bca5240 100644
>

Ok I see what it is but I want to get rid of the panicing so we're going to do
this dance a few more times until it's just failing to mount instead of
panicing, and then we'll fix the actual bug.  Give this a whirl, and I've added
another printk just to make sure what I think is happening is actually what's
happening, so same drill as before.  Thanks,

Josef


diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65245a0..21e8a57 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -702,6 +702,7 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
  	int err = 0;
  	bool need_check = true;
  
+	printk(KERN_ERR "running build_backref_tree\n");
  	path1 = btrfs_alloc_path();
  	path2 = btrfs_alloc_path();
  	if (!path1 || !path2) {
@@ -722,6 +723,8 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
  	node->lowest = 1;
  	cur = node;
  again:
+	printk(KERN_ERR "building backref for bytenr %llu level %d\n",
+	       cur->bytenr, cur->level);
  	end = 0;
  	ptr = 0;
  	key.objectid = cur->bytenr;
@@ -757,6 +760,7 @@ again:
  		 */
  		if (!exist->checked)
  			list_add_tail(&edge->list[UPPER], &list);
+		printk(KERN_ERR "exist is %llu, checked %d\n", exist->bytenr, exist->checked);
  	} else {
  		exist = NULL;
  	}
@@ -807,6 +811,8 @@ again:
  		      exist->owner == key.offset) ||
  		     (key.type == BTRFS_SHARED_BLOCK_REF_KEY &&
  		      exist->bytenr == key.offset))) {
+			printk(KERN_ERR "exist is fucking us, bytenr %llu, "
+			       "type %d\n", exist->bytenr, key.type);
  			exist = NULL;
  			goto next;
  		}
@@ -865,6 +871,7 @@ again:
  				 *  cached, add the block to pending list
  				 */
  				list_add_tail(&edge->list[UPPER], &list);
+				printk(KERN_ERR "found shared ref %llu, needs checking\n", upper->bytenr);
  			} else {
  				upper = rb_entry(rb_node, struct backref_node,
  						 rb_node);
@@ -958,14 +965,30 @@ again:
  					      &root->state))
  					upper->cowonly = 1;
  
+				printk(KERN_ERR "eb in path %llu, level %d, "
+				       "cowonly %d, owner %llu, gen %llu, last "
+				       "snap %llu, reloc %d, root %llu\n",
+				       upper->bytenr, upper->level,
+				       upper->cowonly, upper->owner,
+				       btrfs_header_generation(eb),
+				       btrfs_root_last_snapshot(&root->root_item),
+				       btrfs_header_flag(eb,
+							 BTRFS_HEADER_FLAG_RELOC),
+				       root->objectid);
+
  				/*
  				 * if we know the block isn't shared
  				 * we can void checking its backrefs.
  				 */
-				if (btrfs_block_can_be_shared(root, eb))
+				if (btrfs_block_can_be_shared(root, eb)) {
+					printk(KERN_ERR "is shared, need_check"
+					       " %d\n", need_check);
  					upper->checked = 0;
-				else
+				} else {
+					printk(KERN_ERR "isn't shared, "
+					       "need_check %d\n", need_check);
  					upper->checked = 1;
+				}
  
  				/*
  				 * add the block to pending list if we
@@ -1019,6 +1042,7 @@ next:
  		edge = list_entry(list.next, struct backref_edge, list[UPPER]);
  		list_del_init(&edge->list[UPPER]);
  		cur = edge->node[UPPER];
+		printk(KERN_ERR "doing the checking for block %llu\n", cur->bytenr);
  		goto again;
  	}
  
@@ -1062,7 +1086,12 @@ next:
  			continue;
  		}
  
-		BUG_ON(!upper->checked);
+		if (!upper->checked) {
+			printk(KERN_ERR "block %llu wasn't checked\n",
+			       upper->bytenr);
+			err = -EINVAL;
+			goto out;
+		}
  		BUG_ON(cowonly != upper->cowonly);
  		if (!cowonly) {
  			rb_node = tree_insert(&cache->rb_root, upper->bytenr,
@@ -1114,6 +1143,7 @@ next:
  		}
  	}
  out:
+	printk(KERN_ERR "done building backref tree\n");
  	btrfs_free_path(path1);
  	btrfs_free_path(path2);
  	if (err) {
@@ -1123,7 +1153,6 @@ out:
  			list_del_init(&lower->upper);
  		}
  		upper = node;
-		INIT_LIST_HEAD(&list);
  		while (upper) {
  			if (RB_EMPTY_NODE(&upper->rb_node)) {
  				list_splice_tail(&upper->upper, &list);
