Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14129 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932904Ab3LDSOJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Dec 2013 13:14:09 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <20131204175350.3449.17368@hit-nxdomain.opendns.com>
From: Chris Mason <clm@fb.com>
Subject: [GIT PULL] Btrfs Maintainer update
Date: Wed, 4 Dec 2013 12:53:50 -0500
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Linus,

I'm still getting settled into new devel hardware etc, but I do have one
commit for the next rc.  Please grab it from my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This changes my email over to fb.com, and adds a MAINTAINERS entry for
Josef as well.

Instead of diffstat etc, I've put the patch below.  The commit is also
signed, my updated key should be floating around the pgp servers now.

commit c0778e2534b81be6b85b5ee07c0e15ff774f7136
Author: Chris Mason <clm@fb.com>
Date:   Tue Dec 3 20:16:03 2013 -0500

    Btrfs: update the MAINTAINERS file
    
    Josef and I have new email addresses
    
    Signed-off-by: Chris Mason <clm@fb.com>
    Signed-off-by: Josef Bacik <jbacik@fb.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ffcaf97..db89b5d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1921,7 +1921,8 @@ S:	Maintained
 F:	drivers/gpio/gpio-bt8xx.c
 
 BTRFS FILE SYSTEM
-M:	Chris Mason <chris.mason@fusionio.com>
+M:	Chris Mason <clm@fb.com>
+M:	Josef Bacik <jbacik@fb.com>
 L:	linux-btrfs@vger.kernel.org
 W:	http://btrfs.wiki.kernel.org/
 Q:	http://patchwork.kernel.org/project/linux-btrfs/list/
