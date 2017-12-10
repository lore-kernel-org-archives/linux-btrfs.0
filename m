Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:49100 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751281AbdLJXpl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Dec 2017 18:45:41 -0500
Received: from [192.168.2.168] (ip-2-204-9-41.web.vodafone.de [2.204.9.41])
        by pim.lukas-pirl.de (Postfix) with ESMTPSA id BBF106EA8A87
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 00:45:39 +0100 (CET)
From: Lukas Pirl <btrfs@lukas-pirl.de>
Subject: btrfs-progs: replace: error message can be improved when other
 operation is running
To: linux-btrfs@vger.kernel.org
Message-ID: <4ca6dcdd-7920-4943-376a-19bc6ecc43b3@lukas-pirl.de>
Date: Mon, 11 Dec 2017 00:45:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear all,

when trying to replace a device of a file system for which a balance is
running, btrfs-progs fails with the error message:

ERROR: ioctl(DEV_REPLACE_START) on '/mnt/xyz' returns error: <illegal
result value>

This might also be true for alike operations, such as "add", "delete"
and "resize", since those cases do not seem to be considered in
cmds-replace.c [0].

Apparently, this is not very helpful to the user (if not scary).
In contrast, other commands give very helpful output in similar
situations (e.g., "add/delete/… operation in progress" [1]).

Other users' confusions might also be related to this potential issue [2].

This is probably very easy to fix for someone into ioctl return values
and all this.

Thanks and cheers,

Lukas

GNU/Linux
4.13.0-0.bpo.1-amd64 #1 SMP Debian 4.13.13-1~bpo9+1 (2017-11-22) x86_64
btrfs-progs v4.13.3

[0]
https://github.com/kdave/btrfs-progs/blob/11c83cefb8b4a03b1835efaf603ddc95430a0c9e/cmds-replace.c#L48
[1]
https://github.com/kdave/btrfs-progs/blob/9fe889ac02b9c49b885c8999f5dd4e192697fa83/ioctl.h#L709
[2] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=866734
