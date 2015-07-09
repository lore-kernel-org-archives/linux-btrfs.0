Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:35448 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbGIBV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 21:21:28 -0400
Received: by labgy5 with SMTP id gy5so84241417lab.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 18:21:26 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 8 Jul 2015 21:21:26 -0400
Message-ID: <CA+X5Wn4nsbiG5=LgLq8zhS0X3SB3dGa28-9taABEpGFxQvX2kQ@mail.gmail.com>
Subject: btrfs subvolume tree (btrfs-progs feature request)
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Request for new btrfs subvolume subcommand:

tree <path>
   Display a depth indented listing of subvolumes present in the
filesystem <path>.

---or---

list ... --tree ...
   ...
   -tree
      display subvolumes in a depth indented listing.

Would (I think):
* Display each top-level subvolume
* Recursively display each subvolume under its parent (using top level
ID against ID)

In the format:
/
├── a
│   ├── 1
├── b
│   ├── 1
│   └── 2
└── c
/other
└── d

The actual program "tree" does not work for this application.  It
shows all directories and files, not just the subvolumes.  It has a
"-d" option that only shows directories, which is better, but it still
shows directories that are not subvolumes.

"btrfs subvolume list /" can show 10 lines, with "tree -d" on a
freshly installed system can show over 240,000 lines.

I think it's more likely for btrfs-progs to be able to implement this,
than asking tree to make btrfs-specific code.
