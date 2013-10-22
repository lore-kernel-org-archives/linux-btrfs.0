Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:52565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149Ab3JVUZ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 16:25:58 -0400
Message-ID: <5266DF4F.8010403@sgi.com>
Date: Tue, 22 Oct 2013 15:25:51 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH 5/8] xfstests: generic/274 increase scratch fs size to
 2g
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com> <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382120790-31060-5-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Patch does not apply, already committed.

Thanks
--Rich

commit 859f127da2ee6d49faa41cafd4ed362aa526e4a0
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Jun 21 20:31:10 2013 +0000

     xfstests: make fs for 274 larger

     Btrfs will default to mixed block groups for 1 gigabyte file 
systems and
     smaller, which means data and metadata share the same area.  This makes
     generic/274 fail for us because we cannot reserve enough metadata 
space to do
     our writes.  Bumping the scratch fs up to 2 gigabytes allows us to 
do our normal
     metadata/data separation and allows us to pass this test.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Ben Myers <bpm@sgi.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

diff --git a/tests/generic/274 b/tests/generic/274
index da45fab..7c4887f 100755
--- a/tests/generic/274
+++ b/tests/generic/274
@@ -57,7 +57,7 @@ echo "------------------------------"
  rm -f $seqres.full

  umount $SCRATCH_DEV 2>/dev/null
-_scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
+_scratch_mkfs_sized $((2 * 1024 * 1024 * 1024)) >>$seqres.full 2>&1
  _scratch_mount

  # Create a 4k file and Allocate 4M past EOF on that file
