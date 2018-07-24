Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50534 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726857AbeGXQap (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 12:30:45 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 447C9AE7B
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2018 15:23:45 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Next btrfs development cycle open - 4.20
Date: Tue, 24 Jul 2018 17:23:34 +0200
Message-Id: <20180724152334.24294-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

Besides the recurring stuff, there's an update about development git repos.

4.17 - current
4.18 - upcoming, urgent regression fixes only
4.19 - development closed, pull request in prep, fixes or regressions only
4.20 - development open, until 4.19-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)


Current status
--------------

What's in misc-next is going to be merged to 4.19, unless something really
serious pops out.

Branches that have been part of for-next are eligible but may need some
last reviews and testing, because the for-next is mainly meant for early
warnings and fstests report way more failures compared to master or
misc-next.


Git development repos udpate
----------------------------

I'm going to phase out the git mirror at repo.or.cz. It served me well over the
years, but with recent changes to github, I'm going to use gitlab.com more
extensively and it's a good opportunity to switch the mirror. I'm now managing
2 devel repos plus the k.org and want to keep it sane.

  k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
  devel1: https://gitlab.com/kdave/btrfs-devel
  devel2: https://github.com/kdave/btrfs-devel

The devel repos should be identical regarding the main development branches
like misc-next or for-next-YYYYMMDD. The mirror at repo.or.cz will be still
updated for a few weeks.


List of things with earlier ack for 4.19
----------------------------------------

* patchsets sent until this week that have been reviewed

I want to focus on stabilization of misc-next in the upcoming weeks so
patches that are not going make things better may be postponed. We can
do some cleanup rounds, update messages or do other obviously low-risk
changes.


List of things pushed to 4.20 or later
--------------------------------------

* ioctl CLEAR_FREE
* send v2 updates
* in-band dedupe
* the rest not mentioned above


Usual points
------------

* the current patch queue (as is in misc-next) looks stable, so no big
  changes are going to be applied at this time. The usual exceptions are
  bugfixes or obvious cleanups.

* the base of the patches should be the last announced pull request,
  which is going to be named 'for-4.19' in my k.org tree.  Reviewed
  patches will be collected in a branch that's usually named 'misc-next'
  in my devel git repos and is part of the for-next at k.org git repo.

* merging of new patches to misc-next will be slow during the
  merge window, also because there's a btrfs-progs release scheduled and it's
  summer

* everybody is encouraged to review or test other's patches
