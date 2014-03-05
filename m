Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162AbaCEQcA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Mar 2014 11:32:00 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id DDEB9ACD6
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Mar 2014 16:31:58 +0000 (UTC)
Date: Wed, 5 Mar 2014 17:31:58 +0100
From: Arvin Schnell <aschnell@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: patch for ioctl.h
Message-ID: <20140305163158.GA29683@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hi,

u64 is not known when just including btrfs/ioctl.h. I assume it
should be __u64 as everywhere else in the file.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ioctl.diff"

diff --git a/ioctl.h b/ioctl.h
index a589cd7..7577862 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -539,7 +539,7 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_search_args)
 #define BTRFS_IOC_INO_LOOKUP _IOWR(BTRFS_IOCTL_MAGIC, 18, \
 				   struct btrfs_ioctl_ino_lookup_args)
-#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, u64)
+#define BTRFS_IOC_DEFAULT_SUBVOL _IOW(BTRFS_IOCTL_MAGIC, 19, __u64)
 #define BTRFS_IOC_SPACE_INFO _IOWR(BTRFS_IOCTL_MAGIC, 20, \
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \

--NzB8fVQJ5HfG6fxh--
