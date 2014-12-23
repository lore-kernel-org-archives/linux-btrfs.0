Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:53827 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaLWVq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 16:46:57 -0500
Received: by mail-yk0-f175.google.com with SMTP id 200so3437295ykr.34
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Dec 2014 13:46:56 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 23 Dec 2014 14:46:56 -0700
Message-ID: <CAJCQCtQWS9j0g44c5VKp0Cv=PRC=GAJwpspF5eeRk0siibGXKg@mail.gmail.com>
Subject: 3.19rc1, extent_io.c:2193:13: warning: cast to pointer from integer
 of different size
From: Chris Murphy <chris@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get this when building on i686:

  CC [M]  fs/btrfs/extent_io.o
fs/btrfs/extent_io.c: In function ‘btrfs_free_io_failure_record’:
fs/btrfs/extent_io.c:2193:13: warning: cast to pointer from integer of
different size [-Wint-to-pointer-cast]
   failrec = (struct io_failure_record *)state->private;


.config contains the following
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y

-- 
Chris Murphy
