Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34023 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935098AbcIYB1A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 21:27:00 -0400
Received: by mail-qk0-f194.google.com with SMTP id b204so9455133qkc.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Sep 2016 18:27:00 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH] btrfs-progs: fix user-facing typos
Date: Sat, 24 Sep 2016 21:26:40 -0400
Message-Id: <20160925012641.24339-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I found these with lintian (analysis tool for Debian packages) this
evening, and hope this patch is well received :-)  The only bit I'm
unsure about is the deletion of what looks like extra whitespace on
the last changed line of the patch.

Cheers,
Nicholas

Nicholas D Steeves (1):
  Fix user-facing typos

 Documentation/btrfs-check.asciidoc  | 2 +-
 Documentation/btrfs-device.asciidoc | 2 +-
 Documentation/btrfs-man5.asciidoc   | 2 +-
 Documentation/btrfs-scrub.asciidoc  | 2 +-
 Documentation/btrfstune.asciidoc    | 2 +-
 btrfs-convert.c                     | 2 +-
 cmds-check.c                        | 6 +++---
 7 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.9.3

