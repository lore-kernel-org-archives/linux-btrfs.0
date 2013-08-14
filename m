Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab3HNXRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:24 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHO70006161
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:24 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSx017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:23 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 14/15] btrfs-progs: give raid6.c its exported prototypes
Date: Wed, 14 Aug 2013 16:16:44 -0700
Message-Id: <1376522205-16992-15-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

raid6.c is built without access to the prototypes of functions it
exports.

  warning: symbol 'raid6_gen_syndrome' was not declared.  Should it be static?

They could be changed and get out of sync of the exported prototypes
without errors.   So we add disk-io.h, and its dependency ctree.h, so
that it has a chance to check that its exported prototypes are correct.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 raid6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/raid6.c b/raid6.c
index ce0f655..a6ee483 100644
--- a/raid6.c
+++ b/raid6.c
@@ -20,6 +20,8 @@
 #include <stdint.h>
 #include <unistd.h>
 #include "kerncompat.h"
+#include "ctree.h"
+#include "disk-io.h"
 
 /*
  * This is the C data type to use
-- 
1.7.11.7

