Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37848 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbcCUGhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 02:37:31 -0400
Received: by mail-ig0-f178.google.com with SMTP id kc10so61487214igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 23:37:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Mar 2016 07:37:30 +0100
Message-ID: <CAM1AHpQgH=Zn_k_pHMTpYfdY_xdrOZxo=x8R=Wd7nZ3gcsVX3w@mail.gmail.com>
Subject: btrfs fi du ERROR
From: Martin Volf <martin.volf.42@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have just tried the new "btrfs fi du" command from btrfs-progs 4.5
on 4.4.6 linux kernel, and it gave me:

# btrfs fi du /bin
     Total   Exclusive  Set shared  Filename
(many lines of output for individual files, probably OK)
...
ERROR: cannot check space of '/bin': Unknown error -1

The -1 is ETXTBSY in this case:

# strace -o log btrfs fi du /bin &>/dev/null; tail log

newfstatat(3, "login", {st_mode=S_IFREG|0755, st_size=44784, ...}, 0) = 0
stat("/bin/login", {st_mode=S_IFREG|0755, st_size=44784, ...}) = 0
open("/bin/login", O_RDWR)              = -1 ETXTBSY (Text file busy)
close(3)                                = 0
write(2, "ERROR: ", 7)                  = 7
write(2, "cannot check space of '/bin': Un"..., 46) = 46
write(2, "\n", 1)                       = 1
write(1, "     Total   Exclusive  Set shar"..., 3161) = 3161
exit_group(1)                           = ?
+++ exited with 1 +++

Read-only snapshots give Unknown error -1 too, this time EROFS.

Is it expected?

-- 
Martin Volf
