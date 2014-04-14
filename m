Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45237 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaDNA0d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 20:26:33 -0400
Date: Mon, 14 Apr 2014 01:26:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC] odd thing in btrfs_file_aio_write()
Message-ID: <20140414002625.GQ18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

		end_pos = round_up(pos + iov->iov_len, root->sectorsize);

added in commit 3ac0d7b96a268a98bd474cab8bce3a9f125aaccf
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Thu Mar 27 02:51:58 2014 +0000

    btrfs: Change the expanding write sequence to fix snapshot related bug.

doesn't look right - after all, just split the first iovec in the array
and end_pos will go down.  Do we want pos + count instead of
pos + iov->iov_len there?
