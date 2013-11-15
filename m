Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3KOUgT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 15:36:19 -0500
Message-Id: <20131115203545.412473560@suse.com>
Date: Fri, 15 Nov 2013 15:33:56 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/13] kobject: export kobj_sysfs_ops
References: <20131115203354.082181444@suse.com>
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




