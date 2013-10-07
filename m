Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3JGVnT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:19 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhJCY000757
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:19 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 12/12] btrfs-progs: free leaked roots in calc-size
Date: Mon,  7 Oct 2013 14:43:05 -0700
Message-Id: <1381182185-10896-13-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-1-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This was found by static analysis.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-calc-size.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 5aa0b70..38b70d9 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -257,5 +257,6 @@ int main(int argc, char **argv)
 		goto out;
 out:
 	close_ctree(root);
+	free(roots);
 	return ret;
 }
-- 
1.7.11.7

