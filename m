From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: BTRFS data structures integrity
Date: Wed, 28 Sep 2011 16:41:03 +0300
Message-ID: <CALLzPKbpP+_txNF61EEDS+nDnm+OC50z_+Gmtb5JcgqvrQ0gGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vgre.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a question about BTRFS data structure integrity.

On Ext3 file system I was able to modify offline inode block mapping
in such a way,
that 2 inodes did point to the same data blocks, so when modifying one
file, did affect another file..
FSCK detects such problems and create duplicated blocks, so that inode
content will not overlap...

Does Ext4 suffers from the same problem?

Can anyone please tell if BTRFS is persistent to such attacks and
running fsck is not needed?

Thanks,
Dmitry
