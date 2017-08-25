Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:37187 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932550AbdHYXZZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 19:25:25 -0400
Received: by mail-pg0-f54.google.com with SMTP id 83so6213732pgb.4
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 16:25:25 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: yingyil <yingyil@google.com>
Subject: [PATCH 0/1] btrfs-progs: mkfs: add subvolume support to mkfs
Date: Fri, 25 Aug 2017 16:21:00 -0700
Message-Id: <20170825232101.10859-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

Add -S/--subvol [NAME] option to configure. It enables users to create a
subvolume under the toplevel volume and populate the created subvolume
with files from the rootdir specified by -r/--rootdir option.

Two functions link_subvol() and create_subvol() are moved from
convert/main.c to utils.c to enable code reuse.

yingyil (1):
  btrfs-progs: mkfs: add subvolume support to mkfs

 convert/main.c | 161 ---------------------------------------------------------
 mkfs/main.c    |  73 ++++++++++++++++++++++++--
 utils.c        | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |   5 ++
 4 files changed, 234 insertions(+), 166 deletions(-)

-- 
2.14.1.342.g6490525c54-goog

