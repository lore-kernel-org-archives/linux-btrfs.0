Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-83-236-132-110.static.qsc.de ([83.236.132.110]:43020 "EHLO
        mail.daemons-point.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbdIIFsa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 01:48:30 -0400
Received: from [192.168.178.22] (HSI-KBW-085-216-006-144.hsi.kabelbw.de [85.216.6.144])
        by mail.daemons-point.com (Postfix) with ESMTPSA id F0ACE207F6
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 05:48:17 +0000 (UTC)
From: Uli Heller <uli.heller@daemons-point.com>
Subject: btrfs-progs-4.13: cmds-inspect-tree-stats.h: No such file or
 directory
To: linux-btrfs@vger.kernel.org
Message-ID: <8fab0623-c8ad-ade0-fde7-382742c801bf@daemons-point.com>
Date: Sat, 9 Sep 2017 07:48:32 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I dowloaded the btrfs-progs-v4.13.tar.xz tarball and tried to build it.
Unfortunately, I get an error about cmds-inspect-tree-stats.h. The file 
seems
to be missing from the tarball, it used to exist in v4.12.

...
true -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
-Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
-include .cc-defines.h -D__CHECKER__ -D__CHECK_ENDIAN__ -Wbitwise 
-Wuninitialized -Wshadow -Wundef -U_FORTIFY_SOURCE btrfs-calc-size.c
     [CC]     btrfs-calc-size.o
gcc -g -Os -fstack-protector --param=ssp-buffer-size=4 -Wformat 
-Werror=format-security -DBTRFS_FLAT_INCLUDES=1 -I. -Ikernel-lib -Itmp 
-c btrfs-calc-size.c -o btrfs-calc-size.o  \

btrfs-calc-size.c:22:37: fatal error: cmds-inspect-tree-stats.h: No such 
file or directory
  #include "cmds-inspect-tree-stats.h"
                                      ^

$ LANG=C ls -l btrfs-progs-v4.12/cmds-inspect-tree-stats.h 
btrfs-progs-v4.13/cmds-inspect-tree-stats.h
ls: cannot access btrfs-progs-v4.13/cmds-inspect-tree-stats.h: No such 
file or directory
-rw-rw-r-- 1 uli uli 905 Jul 28 15:29 
btrfs-progs-v4.12/cmds-inspect-tree-stats.h

-- 
Uli Heller

