Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41754 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3FWDeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Jun 2013 23:34:21 -0400
Received: by mail-wi0-f170.google.com with SMTP id ey16so1738894wid.3
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Jun 2013 20:34:19 -0700 (PDT)
MIME-Version: 1.0
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Sun, 23 Jun 2013 05:33:59 +0200
Message-ID: <CAK-xaQaP7-wvzd62GyydjJO2qeW3u9HGjE4Q9f013YpSmMV5vA@mail.gmail.com>
Subject: help: btrfs bad tree block start
To: Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,
   and thanks a lot for your work.

   I have this problem.
   With latest 3.9 kernel and btrfs-next I was close to full my home.
   The system went read only mode while I was copying in some files.

   Everything was good. I can't write, but I can read and copy last files.

   Then I rebooted, but since that moment I cannot mount.

   The kernel complain is:

[ 1026.226883] device label 16K devid 1 transid 66906 /dev/mapper/glen-home
[ 1026.227452] btrfs: disk space caching is enabled
[ 1026.311650] Btrfs detected SSD devices, enabling SSD mode
[ 1026.311825] btrfs bad tree block start 4262492213953725727 591596257280
[ 1026.312000] btrfs bad tree block start 4262492213953725727 591596257280
[ 1026.312010] btrfs: failed to read log tree
[ 1026.332708] btrfs: open_ctree failed

   If I use btrfsck (Joseph one) I got this:

root@glen:/home/gelma/dev/prg/btrfs_josef# ./btrfsck --repair
/dev/mapper/glen-home enabling repair mode
Check tree block failed, want=591596257280, have=4262492213953725727
Check tree block failed, want=591596257280, have=4262492213953725727
Check tree block failed, want=591596257280, have=4262492213953725727
Check tree block failed, want=591596257280, have=4262492213953725727
Check tree block failed, want=591596257280, have=4262492213953725727
read block failed check_tree_block
Checking filesystem on /dev/mapper/glen-home
UUID: 920ae0b9-55da-4606-af40-b58493c7882b
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 127643191167 bytes used err is 0
total csum bytes: 355191196
total tree bytes: 2457419776
total fs tree bytes: 1832763392
total extent tree bytes: 195133440
btree space waste bytes: 472140292
file data blocks allocated: 1525241155584
 referenced 396208013312
Btrfs v0.20-rc1

   The home partition is 352,70 GiB.

   I've got backup, but I would like to recover it.

Thanks a lot,
Gelma
