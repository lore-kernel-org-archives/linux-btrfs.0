Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298Ab3HNXRV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHLES005727
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSm017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/15] btrfs-progs: add ULL to u64 constant
Date: Wed, 14 Aug 2013 16:16:33 -0700
Message-Id: <1376522205-16992-4-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This silences a sparse warning:

	warning: constant 0x4D5F53665248425F is so big it is long

from

  commit 52162700bb59663add809a6465ce2769d80b3664
  Author: Zach Brown <zab@redhat.com>
  Date:   Thu Jan 17 11:54:47 2013 -0800

      btrfs-progs: treat super.magic as an le64

High fives, past me!

Signed-off-by: Zach Brown <zab@redhat.com>
---
 ctree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ctree.h b/ctree.h
index 3c65d0a..bfe9f72 100644
--- a/ctree.h
+++ b/ctree.h
@@ -38,7 +38,7 @@
 struct btrfs_root;
 struct btrfs_trans_handle;
 struct btrfs_free_space_ctl;
-#define BTRFS_MAGIC 0x4D5F53665248425F /* ascii _BHRfS_M, no null */
+#define BTRFS_MAGIC 0x4D5F53665248425FULL /* ascii _BHRfS_M, no null */
 
 #define BTRFS_MAX_LEVEL 8
 
-- 
1.7.11.7

