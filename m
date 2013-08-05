Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314Ab3HEVqJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 17:46:09 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r75Lk9Ch031755
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Aug 2013 17:46:09 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r75Lk8Fo031810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Aug 2013 17:46:08 -0400
Message-ID: <52001D20.7090001@redhat.com>
Date: Mon, 05 Aug 2013 16:46:08 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: fix definition of struct btrfs_extent_inline_ref
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Port kernel commit 1bec1aed to userspace.

use __le64 instead of u64 in on-disk structure definition.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/ctree.h b/ctree.h
index 4f602d4..257396d 100644
--- a/ctree.h
+++ b/ctree.h
@@ -593,7 +593,7 @@ struct btrfs_shared_data_ref {
 
 struct btrfs_extent_inline_ref {
 	u8 type;
-	u64 offset;
+	__le64 offset;
 } __attribute__ ((__packed__));
 
 struct btrfs_extent_ref_v0 {

