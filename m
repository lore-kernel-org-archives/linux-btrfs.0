Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33171 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdBUXPA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Feb 2017 18:15:00 -0500
Received: by mail-it0-f68.google.com with SMTP id e137so18457531itc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Feb 2017 15:15:00 -0800 (PST)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH] btrfs-progs: docs: fix many typos, plus three edits for clarit
Date: Tue, 21 Feb 2017 18:14:37 -0500
Message-Id: <20170221231438.17539-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Please see attached a reasonably thorough patch for all the typos I
could find in btrfs-progs documentation.  The three edits are very
minor and look larger than they are because I had to reflow the
paragraphs.  I'm confident in the quality of the work, with the
exception of the following, where I'm not sure what to do:

Documentation/btrfs-receive.asciidoc
@@ -66,7 +66,7 @@ tell us where this filesystem is mounted.
 --dump::
 dump the stream metadata, one line per operation
 +
-Does not require the 'path' parameter. The filesystem chanded.
+Does not require the 'path' parameter. The filesystem changed.


Sincerely,
Nicholas

Nicholas D Steeves (1):
  btrfs-progs: docs: fix many typos, plus three edits for clarity

 Documentation/btrfs-balance.asciidoc          |  2 +-
 Documentation/btrfs-check.asciidoc            |  8 ++++----
 Documentation/btrfs-device.asciidoc           |  6 +++---
 Documentation/btrfs-filesystem.asciidoc       |  6 +++---
 Documentation/btrfs-inspect-internal.asciidoc |  6 +++---
 Documentation/btrfs-man5.asciidoc             | 15 ++++++++-------
 Documentation/btrfs-quota.asciidoc            |  8 ++++----
 Documentation/btrfs-receive.asciidoc          |  4 ++--
 Documentation/btrfs-restore.asciidoc          |  2 +-
 Documentation/btrfs-scrub.asciidoc            |  9 ++++-----
 Documentation/btrfs-send.asciidoc             |  6 +++---
 11 files changed, 36 insertions(+), 36 deletions(-)

-- 
2.11.0

