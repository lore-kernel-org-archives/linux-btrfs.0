Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:35766 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750775AbdHRHE0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 03:04:26 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Piotr Szymaniak <szarpaj@grubelek.pl>,
        Chris Murphy <lists@colorremedies.com>
Subject: [PATCH] btrfs: incorrect invalid lookup_path_rootid() error handling
Date: Fri, 18 Aug 2017 09:04:19 +0200
Message-Id: <20170818070421.2696-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

Piotr and Chris, pointed me at these bugs which could be triggered by this test case:

# btrfs sub create test1
# btrfs sub create test1/test2
# btrfs sub snap test1 test1.snap
# btrfs fi du -s test1
     Total   Exclusive  Set shared  Filename
     0.00B       0.00B       0.00B  test1
# btrfs fi du -s test1.snap
     Total   Exclusive  Set shared  Filename
ERROR: cannot check space of 'test1.snap': Inappropriate ioctl for device

These are two bugs:
1) in the function du_walk_dir() the error returned by du_add_file() normally
is ignored. But if du_walk_dir() "walks" the last items, the error is returned
to the caller
2) in the function du_add_file() it doesn't make sense to call
lookup_path_rootid() when the inode is BTRFS_EMPTY_SUBVOL_DIR_OBJECTID: in this
case the function doesn't return a valid value.

BR
G.Baroncelli
--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

