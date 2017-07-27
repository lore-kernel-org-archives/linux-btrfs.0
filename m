Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35189 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751444AbdG0OCs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 10:02:48 -0400
Received: by mail-wm0-f48.google.com with SMTP id c184so106133762wmd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 07:02:47 -0700 (PDT)
MIME-Version: 1.0
From: Ivan Sizov <sivan606@gmail.com>
Date: Thu, 27 Jul 2017 17:02:26 +0300
Message-ID: <CAMG9ccwAaWtK=VqNcB9z9Q2qLNHr3q0QmWR0hg=RoG1ynZB-ng@mail.gmail.com>
Subject: What are the typical usecase of "btrfs check --init-extent-tree"?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My RAID-1 FS have multiple "backpointer mismatch" errors. "btrfs check
--repair" doesn't help but only increases the number of errors.
Initially, only 2 roots were affected (uncleanly deleted snapshots I
suppose). But after I ran "check --repair" new "check --readonly"
returns such errors on almost every root!
You can read a small prehistory in this mailing list thread:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg64640.html
Recently I decided to resume my attempts to recover the FS and, at
some point I booted into my system (Fedora 25 with 4.11.3-200 kernel
with patch from the thread mentioned above). A Snapper daemon tried to
remove some corrupted snapshot and, as result, triggered btrfs-cleaner
bug. Now I can neither RW-mount the FS nor run scrub (scrub is
"aborted" in 00:00:00 after start).

How does "--init-extent-tree" deal with backref problems? Will those
backrefs completely reconstructed?

Can similar "backref not found" and "backpointer mismatched" errors
have very different causes and different fix scenarios?

-- 
Ivan Sizov
