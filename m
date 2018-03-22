Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbeCVQdY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Mar 2018 12:33:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A3FA8AF2F
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Mar 2018 16:33:23 +0000 (UTC)
Date: Thu, 22 Mar 2018 17:30:58 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Next btrfs development cycle open - 4.18
Message-ID: <20180322163057.GH6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.15 - current
4.16 - upcoming, urgent regression fixes only
4.17 - development closed, pull request in prep, fixes or regressions only
4.18 - development open, until 4.17-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)

The 4.16 forecast says that there's unlikely to be another rc so we can
expect the release next week. The development branch is based on
4.16-rc6 and will stay like that.

The current patch queue (as is in misc-next) looks stable, so no big
changes are going to be applied at this time. The usual exceptions are
bugfixes or obvious cleanups.

The base of the patches should be the last announced pull request, which
is going to be named 'for-4.17' in my k.org tree.  Reviewed patches will
be collected in a branch that's usually named 'misc-next' in my devel
git repos and is part of the for-next at k.org git repo.

k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
devel1: http://repo.or.cz/linux-2.6/btrfs-unstable.git
devel2: https://github.com/kdave/btrfs-devel

There are some new ioctls proposed so a tentative plan for 4.18 is to
review the usecase and merge them. The qgroup-types patchset did not
make it to 4.17 yet, but it was really close this time so it's the hot
candidate for 4.18 early merge.

Otherwise, merging of new patches to misc-next will be slow during the
merge window, also because there's btrfs-progs release scheduled.

d.
