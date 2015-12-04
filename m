Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:36701 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbbLDISL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 03:18:11 -0500
Received: by pfdd184 with SMTP id d184so22814273pfd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 00:18:10 -0800 (PST)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 0/3] btrfs-progs: fix file restore to lost+found bug
Date: Fri,  4 Dec 2015 14:37:24 +0900
Message-Id: <1449207447-1203-1-git-send-email-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series address an issue of btrfsck to restore infinite number of
same file into `lost+found' directory. The issue occur on a file which
is linked from two different directory A and B. If links from dir A is
corrupted and links from dir B is kept valid, btrfsck won't stop
creating a file in lost+found like this:

-----
Moving file 'file.del.51' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 1876
Trying to rebuild inode:1877
Moving file 'del' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 1877
Can't get file name for inode 1876, using '1876' as fallback
Moving file '1876' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 1876
Can't get file name for inode 1876, using '1876' as fallback
Moving file '1876.1876' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 1876
(snip)
Moving file '1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876.1876' to 'lost+found' dir since it has no valid backref
Fixed the nlink of inode 1876
Can't get file name for inode 1876, using '1876' as fallback
Can't get file name for inode 1876, using '1876' as fallback
Can't get file name for inode 1876, using '1876' as fallback
-----

The problem is early release of inode backrefs. The release prevents
`reset_nlink()' to add back valid backrefs to an inode. In the result,
the following results occur:

0. btrfsck scan a FS tree
1. It finds valid links and invalid links (some links are lost)
2. All valid links are released
3. btrfsck detects found_links != nlink
4. reset_nlink() reset nlink to 0
5. No valid links are restored (thus still nlink = 0)
6. The file is restored to lost+found since nlink == 0 (now, nlink = 1)
7. btrfsck rescan the FS tree
8. It finds `found_links' = #valid_links+1 (in lost+found) and nlink = 1
9. again all valid links are lost, and restore to lost+found

The first patch add clean up code to the test. It umount test
directory on failure path. The second patch fix the above problem. And
the last patch extend the test to check a case of multiple-linked file
corruption.

