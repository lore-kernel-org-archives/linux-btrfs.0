Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36810 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbdH3R1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 13:27:46 -0400
Received: by mail-pg0-f43.google.com with SMTP id r133so21650526pgr.3
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Aug 2017 10:27:46 -0700 (PDT)
From: Yingyi Luo <yingyil@google.com>
To: linux-btrfs@vger.kernel.org
Cc: drosen@google.com, yingyil <yingyil@google.com>
Subject: [PATCH 0/4 v2] add subvolume support to mkfs
Date: Wed, 30 Aug 2017 10:24:46 -0700
Message-Id: <20170830172450.27460-1-yingyil@google.com>
In-Reply-To: <20170825232101.10859-1-yingyil@google.com>
References: <20170825232101.10859-1-yingyil@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: yingyil <yingyil@google.com>

Hi all,

Thanks for all the comments you gave to me. I really appriciate it. I've
updated the patch, split it into small ones so that it may be easier
for you to see the changes and review.

One use case of this feature is that it allows easier operations on subvolumes,
such as migrating subvolumes across images. With the current btrfs tool, we have
to do this manually by creating an empty subvolume then moving the files over.
This feature which creates a subvolume for a given directory when making btrfs
images simplifies the process and makes the logic cleaner.

Goffredo: Thanks again for you comments and pointing out the bug. It happened
to be that I skipped the error code checking when I tested the functionality.
The error came from a duplicate call of btrfs_make_root_dir() from
make_root_dir() in mkfs/main.c and create_subvol() in convert/main.c.

strdup() is used to get a returnable copy of the literal string.
FYI, parse_label() used strdup() to parse the input string. I think using
strdup() would make it consistent with the current code.

Extending the feature would be a good idea. I'll try to work on it later.

Best regards,
Yingyi

yingyil (4):
  btrfs-progs: convert: move link_subvol out of main
  btrfs-progs: add a parameter to btrfs_link_subvol
  btrfs-progs: mkfs: refactor create_data_reloc_tree
  btrfs-progs: mkfs: add subvolume support to mkfs

 convert/main.c | 125 +------------------------------------------------------
 mkfs/main.c    |  82 ++++++++++++++++++++++++++++++++----
 utils.c        | 128 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h        |   3 ++
 4 files changed, 205 insertions(+), 133 deletions(-)

-- 
2.14.1.342.g6490525c54-goog

