Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab3JUVUl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 17:20:41 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E58DFA60D0
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 23:20:39 +0200 (CEST)
Message-Id: <20131021212006.467949781@suse.com>
Date: Mon, 21 Oct 2013 17:19:42 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
Subject: [patch 02/13] kobject: export kobj_sysfs_ops
References: <20131021211940.432195222@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

struct kobj_attribute implements the baseline attribute functionality
that can be used all over the place. We should export the ops associated
with it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
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




