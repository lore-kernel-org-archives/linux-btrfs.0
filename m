Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58879 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab2JCLn0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 07:43:26 -0400
Received: by bkcjk13 with SMTP id jk13so6051880bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 04:43:25 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Date: Wed,  3 Oct 2012 13:43:14 +0200
Message-Id: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This serie of patches updated the command "btrfs filesystem
df". I update this command because it is not so easy to get
the information about the disk usage from the command "fi df" and "fi show".

>From the man page (see 2nd patch):

[...]
The  command  btrfs  filesystem  df is used to query the
status of the chunks, how many space on the disk(s) are used  by
the  chunks,  how many space are available in the chunks, and an
estimation of the free space of the filesystem.
[...]

$ ./btrfs filesystem df --help
usage: btrfs filesystem disk-usage [-d][-s][-k] <path> [<path>..]

    Show space usage information for a mount point(s).

    -k  Set KB (1024 bytes) as unit
    -s  Don't show the summary section
    -d  Don't show the detail section

$ ./btrfs filesystem df /
Path: /
Summary:
  Disk_size:                 72.57GB
  Disk_allocated:            25.10GB
  Disk_unallocated:          47.48GB
  Logical_size:              23.06GB
  Used:                      11.01GB
  Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
  Data_to_disk_ratio:           92 %

Details:
  Chunk-type  Mode      Chunk-size Logical-size        Used
  Data        Single       21.01GB      21.01GB     10.34GB
  System      DUP          80.00MB      40.00MB      4.00KB
  System      Single        4.00MB       4.00MB        0.00
  Metadata    DUP           4.00GB       2.00GB    686.93MB
  Metadata    Single        8.00MB       8.00MB        0.00

Where:
        Disk_size                       -> sum of sizes of teh disks
        Disk_allocated                  -> sum of chunk sizes
        Disk_unallocated                -> Disk_size - Disk_allocated
        Logical_size                    -> sum of logical area sizes
        Used                            -> logical area used
        Free_(Estimated)                -> on the basis of allocated
                                           chunk, an estrapolation of
                                           the free space
        Data_to_disk_ratio              -> ration between the space occuped
                                           by a chunk and the real space
                                           available ( due to duplication
                                           and/or RAID level)
        Chunk-type                      -> kind of chunk
        Mode                            -> allocation policy of a chunk
        Chunk-size                      -> area of disk(s) occuped by the
                                           chunk (see it as raw space used)
        Logical-size                    -> logical area size of the chunk
        Used                            -> portion of the logical area
                                           used by the filesystem



You can pull this change from
   http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
   disk_free

Comments are welcome.

BR
Goffredo Baroncelli

Changelog:
V0->V1          Change the name of command from disk-usage to df

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
