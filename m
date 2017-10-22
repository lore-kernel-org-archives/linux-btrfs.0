Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:49525 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932256AbdJVAAz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Oct 2017 20:00:55 -0400
Received: by mail-qk0-f177.google.com with SMTP id q83so18213156qke.6
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Oct 2017 17:00:55 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 0/1] btrfs-progs: docs: annual typo, clarity, & grammar review & fixups
Date: Sat, 21 Oct 2017 20:00:45 -0400
Message-Id: <20171022000046.9000-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

I've marked the parts the require review like this: This paragraph
explains something ****but something is opaque**** (EDIT: reason why
it's unclear or needs to be updated).  Here is what I found this
year (@664dbbff6e72ffbdeb451b4f03f98dab3eabb1d1):

Nicholas D Steeves (1):
  btrfs-progs: docs: annual typo, clarity, & grammar review & fixups

 Documentation/btrfs-balance.asciidoc          | 12 ++++-----
 Documentation/btrfs-check.asciidoc            | 17 ++++++-------
 Documentation/btrfs-convert.asciidoc          | 21 ++++++++--------
 Documentation/btrfs-device.asciidoc           |  6 ++---
 Documentation/btrfs-filesystem.asciidoc       | 18 +++++++-------
 Documentation/btrfs-find-root.asciidoc        |  2 +-
 Documentation/btrfs-inspect-internal.asciidoc |  8 +++---
 Documentation/btrfs-man5.asciidoc             | 36 ++++++++++++++-------------
 Documentation/btrfs-map-logical.asciidoc      |  2 +-
 Documentation/btrfs-qgroup.asciidoc           |  8 +++---
 Documentation/btrfs-quota.asciidoc            | 18 +++++++-------
 Documentation/btrfs-receive.asciidoc          |  2 +-
 Documentation/btrfs-replace.asciidoc          |  6 ++---
 Documentation/btrfs-rescue.asciidoc           |  2 +-
 Documentation/btrfs-scrub.asciidoc            |  4 +--
 Documentation/btrfs-send.asciidoc             | 11 ++++----
 Documentation/btrfs-subvolume.asciidoc        | 15 +++++------
 Documentation/btrfs.asciidoc                  | 14 +++++------
 Documentation/btrfstune.asciidoc              | 13 +++++-----
 Documentation/fsck.btrfs.asciidoc             |  8 +++---
 Documentation/mkfs.btrfs.asciidoc             | 10 ++++----
 21 files changed, 119 insertions(+), 114 deletions(-)

-- 
2.11.0

