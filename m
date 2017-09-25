Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:56864 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966054AbdIYUS2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 16:18:28 -0400
From: Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] btrfs: new ioctl BTRFS_IOC_GET_CHUNK_INFO
Date: Mon, 25 Sep 2017 22:10:09 +0200
Message-Id: <20170925201010.9958-1-kreijack@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The aim of this patch is to replace the BTRFS_IOC_TREE_SEARCH ioctl when
it is used to obtain information about the chunks/block groups. 

The problems in using the BTRFS_IOC_TREE_SEARCH is that it access
the very low data structure of BTRFS. This means: 
1) this would be complicated a possible change of the disk format
2) it requires the root privileges

The new BTRFS_IOC_GET_CHUNK_INFO is an attempt to address these issue.
This ioctl can be called from a not root user: I think that the data exposed 
are not sensibile data.

In a separate patches set, there is an update to the btrfs utility to
allow it to use this new ioctl int the load_chunk_info() function.
So now it is possible to do "btrfs fi us" without root privileges.

This is an RFC, because I want to be sure that
1) it is right my understanding that the chunk info are not a "sensibile data"
2) the api is a good api. In particular I am not sure that returning -EAGAIN is
the right thing to do when further data is available but the buffer is not
enough.

Comments are welcome
BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

