Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:23440 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759460Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 10/17] btrfs-progs: don't call close on error fd
Date: Mon, 25 Feb 2013 16:54:43 -0600
Message-Id: <1361832890-40921-11-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the error case where fd < 0, close(fd) is the wrong
thing to do.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-show-super.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 3614c52..f587f10 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -97,7 +97,6 @@ int main(int argc, char **argv)
 		fd = open(filename, O_RDONLY, 0666);
 		if (fd < 0) {
 			fprintf(stderr, "Could not open %s\n", filename);
-			close(fd);
 			exit(1);
 		}
 
-- 
1.7.1

