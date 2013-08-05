Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab3HEVtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 17:49:35 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r75LnZnH005065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Aug 2013 17:49:35 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r75LnXQr031686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 5 Aug 2013 17:49:35 -0400
Message-ID: <52001DED.7020302@redhat.com>
Date: Mon, 05 Aug 2013 16:49:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: make set/get functions for the super compat_ro
 flags use compat_ro
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Port of commit 12534832 to userspace:

 commit 12534832cb7b0abc7369298246e8b7af03b863ca
 Author: Josef Bacik <josef@redhat.com>
 Date:   Thu Dec 17 21:32:27 2009 +0000

    Btrfs: make set/get functions for the super compat_ro flags use compat_ro
    
    Our set/get functions for compat_ro_flags actually look at compat_flags.  This
    will mess any attempt to use compat flags up.  The fix is obvious.  Thanks,
    
    Signed-off-by: Josef Bacik <josef@redhat.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/ctree.h b/ctree.h
index d459733..4f602d4 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1934,7 +1934,7 @@ BTRFS_SETGET_STACK_FUNCS(super_num_devices, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_compat_flags, struct btrfs_super_block,
 			 compat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_compat_ro_flags, struct btrfs_super_block,
-			 compat_flags, 64);
+			 compat_ro_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_incompat_flags, struct btrfs_super_block,
 			 incompat_flags, 64);
 BTRFS_SETGET_STACK_FUNCS(super_csum_type, struct btrfs_super_block,

