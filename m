From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] Add debug-btrfs command to btrfs-progs
Date: Sun, 31 Jan 2010 19:51:34 +0530
Message-ID: <1264947698-32371-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The below set of patches add debug-btrfs command to btrfs-progs package.
The new command depends on the libss.a library provided e2fsprogs. To build
one have to set E2FSPRGS_BUILD_DIR to point to the e2fsprogs build directory.
Once we get e2fsprogs to create a proper libss package we should be able
to remove the above export.

Currently supported list of commands are listed below. It should be really
easy to add new commands

debug-btrfs:  ?
Available debug-btrfs requests:

show_debugfs_params, params
                         Show btrfs_debug parameters
open_filesys, open       Open the file system
dump_tree                Show full btrfs tree
dump_root_tree           Show root tree
dump_chunk_tree          Show btrfs chunk tree
print_inode              Print inode details
help                     Display info on command or topic.
list_requests, lr, ?     List available commands.
quit, q                  Leave the subsystem.


You should be able to get the patches with --no-renames at
http://www.kernel.org/pub/linux/kernel/people/kvaneesh/debug-btrfs/

-aneesh

