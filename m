Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:42974 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbeGZVxR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 17:53:17 -0400
Received: by mail-pl0-f46.google.com with SMTP id z7-v6so1308358plo.9
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 13:34:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/2] btrfs-progs: build improvements
Date: Thu, 26 Jul 2018 13:34:37 -0700
Message-Id: <cover.1532637115.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Hi, Dave,

Here's v2 of "btrfs-progs: make all programs and libraries optional",
this time much less overkill. Now, it's just --disable-programs,
--disable-shared, and --disable-static. Based on your devel branch.
Please consider these for the next progs release.

Thanks!

Omar Sandoval (2):
  btrfs-progs: add --disable-programs
  btrfs-progs: add --disable-shared and --disable-static

 Makefile        | 56 +++++++++++++++++++++++++++++++++----------------
 Makefile.inc.in |  3 +++
 configure.ac    | 28 +++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 20 deletions(-)

-- 
2.18.0

