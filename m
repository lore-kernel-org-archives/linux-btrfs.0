Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34268 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969Ab2JCRWf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:22:35 -0400
Received: by bkcjk13 with SMTP id jk13so6281168bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 10:22:34 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH][BTRFS-PROGS][V2] btrfs filesystem df
Date: Wed,  3 Oct 2012 19:22:30 +0200
Message-Id: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>From the man page (see 2nd patch):

[...]
The  command  btrfs  filesystem  df is used to query the
status of the chunks, how many space on the disk(s) are used  by
the  chunks,  how many space are available in the chunks, and an
estimation of the free space of the filesystem.
[...]

$ ./btrfs filesystem df --help
usage: btrfs filesystem disk-usage [-d|-s][-k] <path> [<path>..]

    Show space usage information for a mount point(s).

    -k  Set KB (1024 bytes) as unit
    -s  Show the summary section only
    -d  Show the detail section only

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
  Chunk-type  Mode      Chunk_size Logical_size        Used
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
        Chunk_type                      -> kind of chunk
        Mode                            -> allocation policy of a chunk
        Chunk_size                      -> area of disk(s) occuped by the
                                           chunk (see it as raw space used)
        Logical_size                    -> logical area size of the chunk
        Used                            -> portion of the logical area
                                           used by the filesystem



You can pull this change from
   http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
   disk_free

Please pull.

BR
Goffredo Baroncelli

Changelog:
V0->V1          Change the name of command from disk-usage to df
V1->V2		Uses getopt(); replace "-" with "_"; change the behaviour
		of the switches '-s' and '-d'.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
