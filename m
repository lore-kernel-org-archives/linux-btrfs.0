Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:56864 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966053AbdIYUSc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:32 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] btrfs-progs: use the new ioctl BTRFS_IOC_GET_CHUNK_INFO
Date: Mon, 25 Sep 2017 22:18:13 +0200
Message-Id: <20170925201815.10161-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi all,

this patches set uses the new ioctl BTRFS_IOC_GET_CHUNK_INFO to get
information about the chunk (see my other emails). 

The first patch change the function get_partition_size() to avoid
ioctl which would require root privileges (BLKGETSIZE64).
Instead it obtain the information via the sysfs filesystem.

The second patch use the BTRFS_IOC_GET_CHUNK_INFO instead of
TREE_SEARCH_IOCTL. The old code is still in place as fallback
when the kernel doesn't have the new ioctl.

These patches allow to use "btrfs fi usage" without root privileges.

Comments are welcome
BR
G.Baroncelli

--
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
