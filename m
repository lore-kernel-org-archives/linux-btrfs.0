Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab3CDWtl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:49:41 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24MnfFX004499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:49:41 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r24Mnexo025581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:49:41 -0500
Message-ID: <51352504.7040104@redhat.com>
Date: Mon, 04 Mar 2013 16:49:40 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 15/14] btrfs-progs: fix scrub error return from pthread_mutex_lock
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If pthread_mutex_lock() fails it returns the error in ret,
and does not set errno.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/cmds-scrub.c b/cmds-scrub.c
index f73b3c6..8129601 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -763,7 +763,7 @@ static int scrub_write_progress(pthread_mutex_t *m, const char *fsid,
 
 	ret = pthread_mutex_lock(m);
 	if (ret) {
-		err = -errno;
+		err = -ret;
 		goto out;
 	}
 
