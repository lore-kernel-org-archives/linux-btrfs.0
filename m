Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41691 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752572AbeEUPsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 11:48:15 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3AA04AEDF
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 15:48:14 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: Next btrfs development cycle open - 4.19
Date: Mon, 21 May 2018 17:45:29 +0200
Message-Id: <20180521154529.12620-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.16 - current
4.17 - upcoming, urgent regression fixes only
4.18 - development closed, pull request in prep, fixes or regressions only
4.19 - development open, until 4.18-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)


Current status
--------------

What's in misc-next is going to be merged to 4.18, unless something really
serious pops out.

Branches that have been part of for-next are eligible but may need some
last reviews and testing, because the for-next is mainly meant for early
warnings and fstests report way more failures compared to master or
misc-next.


List of things with earlier ack for 4.18
----------------------------------------

* ioctl for listing subvolumes -- probably ok, the security review is
  still open
* ioctl CLEAR_FREE -- probably yes
* patchsets sent until about last week that have been reviewed

I want to focus on stabilization of misc-next in the upcoming weeks so
patches that are not going make things better may be postponed. We can
do some cleanup rounds, update messages or do other obviously low-risk
changes.


List of things pushed to 4.19 or later
--------------------------------------

* send v2 updates
* in-band dedupe
* the rest not mentioned above


Workflow
--------

Let's see how many people actually read these mails: if you have a
public git repository, please send a link to the branch with your
patchset in the cover letter when you send the patches to mailinglist.
If you already do, great.

The branch will not be pulled, but it can help me integrate the branch
faster to for-next which in turn improves testing and tracking of
pending patchsets.

Note that mailinglist is still the primary source of patches, the git is
optional.


The usual points
----------------

* the current patch queue (as is in misc-next) looks stable, so no big
  changes are going to be applied at this time. The usual exceptions are
  bugfixes or obvious cleanups.

* the base of the patches should be the last announced pull request,
  which is going to be named 'for-4.18' in my k.org tree.  Reviewed
  patches will be collected in a branch that's usually named 'misc-next'
  in my devel git repos and is part of the for-next at k.org git repo.

* repositories
  k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
  devel1: http://repo.or.cz/linux-2.6/btrfs-unstable.git
  devel2: https://github.com/kdave/btrfs-devel

* merging of new patches to misc-next will be slow during the
  merge window, also because there's a btrfs-progs release scheduled

* everybody is encouraged to review or test other's patches
