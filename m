Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42596 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab3BLIh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 03:37:57 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so696869ghb.5
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 00:37:57 -0800 (PST)
From: Filipe Brandenburger <filbranden@google.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Brandenburger <filbranden@google.com>
Subject: [RFC][PATCH 0/2] btrfs-progs: introduce kernelsrc directory to update it
Date: Tue, 12 Feb 2013 00:37:43 -0800
Message-Id: <1360658265-6987-1-git-send-email-filbranden@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is a proposal on a way to keep btrfs-progs in sync with kernel code.
https://btrfs.wiki.kernel.org/index.php/Cleanup_ideas#Use_the_kernel_code_in_user_mode

For now, the patch introduces a method to import and update the kernel source
files into the btrfs-progs tree. Further work will be needed to update the
kernel source code so to make it generic (i.e. add #define's and #ifdef's) so
that it can be compiled in both kernel and user space.

The Python script is just a draft, it's already functional but error handling
(and reporting) could definitely be improved, the code could be cleaned up, it
could cache the kernel source directory and allow a --force parameter to allow
moving to an tag that's not a descendant, but it's already fully functional and
it's probably a good start...

To see it in action, try this after applying the commits:

  $ kernelsrc/update_kernelsrc.py /path/to/linux v3.6
  $ git status
  $ git commit -m "btrfs-progs: initial checkout of kernelsrc v3.6"
  $ vim kernelsrc/update_kernelsrc.filelist (add/delete a line)
  $ kernelsrc/update_kernelsrc.py ../linux-btrfs/ v3.7
  $ git status
  $ git commit -m "btrfs-progs: upgrade kernelsrc from v3.6 to v3.7"

Let me know what you think and if you think it's worth to continue on this path.

Cheers,
Filipe


Filipe Brandenburger (2):
  btrfs-progs: anchor gitignore patterns on root
  btrfs-progs: introduce kernelsrc directory and script to update it

 .gitignore                          |  32 +++++---
 kernelsrc/README.kernelsrc          | 108 ++++++++++++++++++++++++
 kernelsrc/update_kernelsrc.filelist |  23 ++++++
 kernelsrc/update_kernelsrc.py       | 158 ++++++++++++++++++++++++++++++++++++
 4 files changed, 308 insertions(+), 13 deletions(-)
 create mode 100644 kernelsrc/README.kernelsrc
 create mode 100644 kernelsrc/update_kernelsrc.filelist
 create mode 100755 kernelsrc/update_kernelsrc.py

-- 
1.8.1.2

