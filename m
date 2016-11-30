Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36083 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754245AbcK3MMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 07:12:42 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.8.5
Date: Wed, 30 Nov 2016 13:12:31 +0100
Message-Id: <20161130121231.11380-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

btrfs-progs version 4.8.5 have been released, contains an urgent bugfix for
receive that mistakenly reports error on valid streams.  Bug introduced in
4.8.4 by me, my appologies.

Changes:
  * receive: fix detection of end of stream (error reported even for valid
    streams)
  * other:
    * added test for the receive bug
    * fix linking of library-test

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git

Shortlog:

David Sterba (7):
      btrfs-progs: docs: fix typo in btrfs-man5
      btrfs-progs: receive: properly detect end of stream conditions
      btrfs-progs: tests: end of stream conditions
      btrfs-progs: tests: add correct rpath to library-test
      btrfs-progs: test: fix static build of library-test
      btrfs-progs: update CHANGES for v4.8.5
      Btrfs progs v4.8.5
