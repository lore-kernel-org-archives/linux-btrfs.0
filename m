Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:40934 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932501AbeCPAj2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 20:39:28 -0400
Received: by mail-qk0-f195.google.com with SMTP id o25so9388452qkl.7
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:39:27 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 0/1] btrfs-progs: Fix typos in docs and user-facing strings
Date: Thu, 15 Mar 2018 20:39:08 -0400
Message-Id: <20180316003909.28800-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Found with lintian and Emacs' writegood-mode.

Cheers!

Nicholas D Steeves (1):
  Fix typos in docs and user-facing strings

 Documentation/btrfs-balance.asciidoc | 2 +-
 Documentation/btrfs-check.asciidoc   | 2 +-
 Documentation/btrfs-man5.asciidoc    | 8 ++++----
 cmds-subvolume.c                     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.14.2

