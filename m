Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58922 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3KARYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 13:24:30 -0400
Message-Id: <20131101172240.304000254@suse.com>
Date: Fri, 01 Nov 2013 13:06:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/13] kobject: export kobj_sysfs_ops
References: <20131101170654.164867629@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

struct kobj_attribute implements the baseline attribute functionality
that can be used all over the place. We should export the ops associated
with it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/kobject.c	2013-10-21 16:09:51.868220920 -0400
+++ b/lib/kobject.c	2013-10-21 16:10:00.216037635 -0400
@@ -726,6 +726,7 @@ const struct sysfs_ops kobj_sysfs_ops =
 	.show	= kobj_attr_show,
 	.store	= kobj_attr_store,
 };
+EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 
 /**
  * kset_register - initialize and add a kset.




