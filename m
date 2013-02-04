Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:40136 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3BDVme (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Feb 2013 16:42:34 -0500
Message-ID: <51102B40.6000207@zytor.com>
Date: Mon, 04 Feb 2013 13:42:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: experimental raid5/6 code in git
References: <20130202160212.GB4694@shiny>
In-Reply-To: <20130202160212.GB4694@shiny>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

@@ -1389,6 +1392,14 @@ int btrfs_rm_device(struct btrfs_root *root, char
*device_path)
 	}
 	btrfs_dev_replace_unlock(&root->fs_info->dev_replace);

+	if ((all_avail & (BTRFS_BLOCK_GROUP_RAID5 |
+			  BTRFS_BLOCK_GROUP_RAID6) && num_devices <= 3)) {
+		printk(KERN_ERR "btrfs: unable to go below three devices "
+		       "on raid5 or raid6\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) && num_devices <= 4) {
 		printk(KERN_ERR "btrfs: unable to go below four devices "
 		       "on raid10\n");
@@ -1403,6 +1414,21 @@ int btrfs_rm_device(struct btrfs_root *root, char
*device_path)
 		goto out;
 	}

+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
+	    root->fs_info->fs_devices->rw_devices <= 2) {
+		printk(KERN_ERR "btrfs: unable to go below two "
+		       "devices on raid5\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
+	    root->fs_info->fs_devices->rw_devices <= 3) {
+		printk(KERN_ERR "btrfs: unable to go below three "
+		       "devices on raid6\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;


This seems inconsistent?

	-hpa

