Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from milliways.cryptomilk.org ([78.46.80.163]:38760 "EHLO
	milliways.cryptomilk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3KHLOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 06:14:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by milliways.cryptomilk.org (Postfix) with SMTP id CD05DE0D1C
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Nov 2013 12:07:54 +0100 (CET)
From: Andreas Schneider <asn@cryptomilk.org>
To: linux-btrfs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Subject: btrfs and default directory link count
Date: Fri, 08 Nov 2013 12:07:52 +0100
Message-ID: <1528226.ndb0o2H7AC@magrathea>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I did run the Samba testsuite and have a failing test 
(samba.vfstest.stream_depot). It revealed that it only fails on btrfs. The 
reason is that a simple check fails:

if (smb_fname_base->st.st_ex_nlink == 2)

If you create a directory on btrfs and check stat:

$ mkdir x
$ stat x
  File: ‘x’
  Size: 0               Blocks: 0          IO Block: 4096   directory
Device: 2bh/43d Inode: 3834720     Links: 1
Access: (0755/drwxr-xr-x)  Uid: ( 1000/     asn)   Gid: (  100/   users)
Access: 2013-11-08 11:54:32.431040963 +0100
Modify: 2013-11-08 11:54:32.430040956 +0100
Change: 2013-11-08 11:54:32.430040956 +0100
 Birth: -

then you see Links: 1. On ext4 or other filesystems:

mkdir x
stat x
  File: ‘x’
  Size: 4096            Blocks: 8          IO Block: 4096   directory
Device: fd00h/64768d    Inode: 8126886     Links: 2
Access: (0755/drwxr-xr-x)  Uid: ( 1000/     asn)   Gid: (  100/   users)
Access: 2013-11-08 11:54:55.428212340 +0100
Modify: 2013-11-08 11:54:55.427212319 +0100
Change: 2013-11-08 11:54:55.427212319 +0100
 Birth: -

the link count for a directory differs: Links: 2.

Why is btrfs different here? Could someone explain this?


Thanks,


	-- andreas

-- 
Andreas Schneider                   GPG-ID: CC014E3D
www.cryptomilk.org                asn@cryptomilk.org

