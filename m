Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44647 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752698AbcGSLF5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jul 2016 07:05:57 -0400
Date: Tue, 19 Jul 2016 07:05:36 -0400
From: Chris Mason <clm@fb.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
CC: Gabriel C <nix.or.die@gmail.com>, <linux-btrfs@vger.kernel.org>,
        <quwenruo@cn.fujitsu.com>
Subject: Re: A lot warnings in dmesg while running thunderbird
Message-ID: <20160719110534.GA96833@clm-mbp.thefacebook.com>
References: <CAEJqkghMZDOJoyRkf_-HTfuKLnj0eaAGmtjVAPY2UftV7TxbvA@mail.gmail.com>
 <47ff1ea1-d4a9-55d9-f65d-60e94be93146@gmail.com>
 <73545420-2ce5-c4d3-d59a-98d2114bafd2@fb.com>
 <35812568.Zn4Yz0rfXf@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <35812568.Zn4Yz0rfXf@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 11:28:01AM +0530, Chandan Rajendra wrote:
>Hi Chris,
>
>I am able to reproduce the issue with the 'short-write' program. But before
>the call trace associated with btrfs_destroy_inode(), I see the following call
>trace ...
>
>------------[ cut here ]------------
>WARNING: CPU: 2 PID: 2311 at /home/chandan/repos/linux/fs/btrfs/extent-tree.c:4303 btrfs_free_reserved_data_space_noquota+0xe8/0x100

[ ... ]

Ok, the problem is in how we're dealing with the offset into the sector when
we fail. The dirty_sectors variable already has this accounted in it, so
this patch fixes it for me.  I ran overnight, but I'll let it go for a few
days just to make sure:

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index fac9b839..5842423 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1629,13 +1629,11 @@ again:
 		 * managed to copy.
 		 */
 		if (num_sectors > dirty_sectors) {
-			/*
-			 * we round down because we don't want to count
-			 * any partial blocks actually sent through the
-			 * IO machines
-			 */
-			release_bytes = round_down(release_bytes - copied,
-				      root->sectorsize);
+
+			/* release everything except the sectors we dirtied */
+			release_bytes -= dirty_sectors <<
+				root->fs_info->sb->s_blocksize_bits;
+
 			if (copied > 0) {
 				spin_lock(&BTRFS_I(inode)->lock);
 				BTRFS_I(inode)->outstanding_extents++;
