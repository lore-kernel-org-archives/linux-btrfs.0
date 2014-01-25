Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37241 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaAYAJ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 19:09:56 -0500
Received: by mail-ie0-f174.google.com with SMTP id tp5so3661533ieb.33
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 16:09:55 -0800 (PST)
MIME-Version: 1.0
From: Aastha Mehta <aasthakm@gmail.com>
Date: Sat, 25 Jan 2014 01:09:35 +0100
Message-ID: <CAEx9m47jxKWro0x6U7h9Ma2=kGTNm7cGFM+VZkFyHvY7qt87dg@mail.gmail.com>
Subject: questions regarding fsync in btrfs
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I would like to clarify a bit on how the fsync works in btrfs. The log
tree journals only the metadata of the files that have been modified
prior to the fsync, correct? It does not log the data extents of
files, which are directly sync'ed to the disk. Also, if I understand
correctly, fsync and fdatasync are the same thing in btrfs currently.
Is it more like fsync or fdatasync?

What exactly happens once a file inode is in the tree log? Does it
mean it is guaranteed to be persisted on disk, or is it already on
disk? I see two flags in btrfs_sync_file -
BTRFS_INODE_HAS_ASYNC_EXTENT and BTRFS_INODE_NEEDS_FULL_SYNC. I do not
fully understand them. After full sync, what does log_dentry_safe and
sync_log do?

Finally, Wikipedia says that "the items in the log tree are replayed
and deleted at the next full tree commit or (if there was a system
crash) at the next remount". Even if there is no crash, why is there a
need to replay the log?

Thanks,
Aastha.
