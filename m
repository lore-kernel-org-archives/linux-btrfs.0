Return-Path: <SRS0=EUcM=33=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58904C352A3
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 299DD21741
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Feb 2020 13:08:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVLe9kzD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgBGNIQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Feb 2020 08:08:16 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36535 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgBGNIP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2020 08:08:15 -0500
Received: by mail-wr1-f44.google.com with SMTP id z3so2635662wru.3
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2020 05:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U2Nx0CU20NEgvi6F51a4zB9i7nxAW6X62OkyehGmyzo=;
        b=QVLe9kzDn82xs2tsSRFzx4ZNDsEYAvp5971DdNgxL6IU1kWw949v5JpcY4GXPcCJOj
         TOf2RfuoRZwzvuQe3eV+NJSPXYPnjP+FSkLyEXTt1ioBjQuIP2Ko6szcSJgPdm7jR1R5
         2/1f/H41CFNSrcIAM6tDcIubb7ih8ln0FLxDpK6jnUYRjKqGPFsj3puA/mRonqVGff0Y
         fTRP4HYn0KVYrsGnSg0cWs+HDn35qSTx6W1cwGDOyTcLFQ8Af76UyjMRcyodE9e01m95
         wRtxl7kU8hCr0w/+kj02SxyhCZdsEJYZCBzXdK19WdQucgWcwjMI0gHkSI5WHyGep1dK
         4XeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U2Nx0CU20NEgvi6F51a4zB9i7nxAW6X62OkyehGmyzo=;
        b=SAPeg0gLTBi/lTdUTi/3nBcdYJvZ4x5/AEVmntmhIL+nPtI14gR6yl7YBYNeqvoZew
         jfAo32N4AXshrq7G+1B1sRFRgYdpcUVK5xG+BEfoiNfdV/l55jQP0rxYCGvphamxZFWx
         4455G2M99HIUoGYyVLo9ssd74kPzRTSUYBS2lqIxI+1+zqpWZgvDWzysHy9JQYVyi2fL
         c//dT+PEf7A1nEnB3At2ikcW3DoGBbGeXFYqiPbJSoIZ8Ad1xuBKKfVrkyGWEnoqvHU1
         CiAWjAgZOxK9QGipUmWpZF7aF2ej+51GaqMDgMW/HV/5dKQSDXeiW9+G1LRkTaxGIG5w
         G5lA==
X-Gm-Message-State: APjAAAVZWLjRHoKGOxaUbMh7wRq02s6ZVVNaMY7W5yM8Kce6WZ5qb2fo
        Rjh6ulAg49mY5rTs8CDJGIBUNbLa
X-Google-Smtp-Source: APXvYqxlgulW+bDFm5TenowbAR3DXAFyR+voFtsyK155zUSz68fVylMmwwsvVCgPbk/o72pIjqjh+g==
X-Received: by 2002:a5d:608f:: with SMTP id w15mr4640073wrt.20.1581080893847;
        Fri, 07 Feb 2020 05:08:13 -0800 (PST)
Received: from hephaestus.suse.de ([186.212.94.124])
        by smtp.gmail.com with ESMTPSA id n1sm3260702wrw.52.2020.02.07.05.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 05:08:13 -0800 (PST)
From:   Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To:     dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCHv2 2/4] libbtrfsutil: add IOC_SNAP_DESTROY_V2 to ioctl.h
Date:   Fri,  7 Feb 2020 10:10:26 -0300
Message-Id: <20200207131028.9977-3-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207131028.9977-1-marcos.souza.org@gmail.com>
References: <20200207131028.9977-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

This ioctl will make possible to delete a subvolume/snapshot by using
the subvolume id.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---

Changes from v1:
* Moved subvolid member to the same union containing name and devid (David)
* Changed BTRFS_SUBVOL_DELETE_BY_ID to BTRFS_SUBVOL_SPEC_BY_ID (David,
  Christoph)


 libbtrfsutil/btrfs.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/btrfs.h b/libbtrfsutil/btrfs.h
index c9a61b30..d1206410 100644
--- a/libbtrfsutil/btrfs.h
+++ b/libbtrfsutil/btrfs.h
@@ -36,12 +36,14 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_DEVICE_PATH_NAME_MAX 1024
 
 #define BTRFS_DEVICE_SPEC_BY_ID		(1ULL << 3)
+#define BTRFS_SUBVOL_SPEC_BY_ID	(1ULL << 4)
 
 #define BTRFS_VOL_ARG_V2_FLAGS_SUPPORTED		\
 			(BTRFS_SUBVOL_CREATE_ASYNC |	\
 			BTRFS_SUBVOL_RDONLY |		\
 			BTRFS_SUBVOL_QGROUP_INHERIT |	\
-			BTRFS_DEVICE_SPEC_BY_ID)
+			BTRFS_DEVICE_SPEC_BY_ID |	\
+			BTRFS_SUBVOL_SPEC_BY_ID)
 
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
@@ -119,6 +121,7 @@ struct btrfs_ioctl_vol_args_v2 {
 	};
 	union {
 		char name[BTRFS_SUBVOL_NAME_MAX + 1];
+		__u64 subvolid;
 		__u64 devid;
 	};
 };
@@ -942,5 +945,7 @@ enum btrfs_err_code {
 				struct btrfs_ioctl_get_subvol_rootref_args)
 #define BTRFS_IOC_INO_LOOKUP_USER _IOWR(BTRFS_IOCTL_MAGIC, 62, \
 				struct btrfs_ioctl_ino_lookup_user_args)
+#define BTRFS_IOC_SNAP_DESTROY_V2 _IOW(BTRFS_IOCTL_MAGIC, 63, \
+				struct btrfs_ioctl_vol_args_v2)
 
 #endif /* _LINUX_BTRFS_H */
-- 
2.24.0

