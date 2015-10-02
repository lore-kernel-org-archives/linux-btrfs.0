Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.digint.ch ([92.42.190.51]:42467 "EHLO mail.digint.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbbJBQuE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Oct 2015 12:50:04 -0400
From: axel@tty0.ch
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [PATCH 0/4] btrfs-progs: improve output of btrfs subvolume list command
Date: Fri,  2 Oct 2015 18:41:19 +0200
Message-Id: <1443804083-876-1-git-send-email-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Improvements to "subvolume list" command, with the goal to improve
machine-readability. While the first three patches simply add new
options (-A and --time-format), the last patch [PATCH 4/4] is more
intrusive and changes the output format of the '-t' option. Consider
it "my view of how tabular output of a linux command should look
like" (see also comments on the commit).

Axel Burri (4):
  btrfs-progs: add -A option for subvolume list (print all available
    information)
  btrfs-progs: add "flags" column for subvolume list (shows "readonly"
    flag with -A)
  btrfs-progs: add option "--time-format=short|iso|unix|locale" to
    subvolume list
  btrfs-progs: change -t option for subvolume list to print a simple
    space-separated table (making it machine-readable)

 Documentation/btrfs-subvolume.asciidoc |   5 ++
 btrfs-list.c                           | 119 +++++++++++++++++++++++----------
 btrfs-list.h                           |   2 +
 cmds-subvolume.c                       |  16 ++++-
 4 files changed, 104 insertions(+), 38 deletions(-)

-- 
2.4.9

