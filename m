Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53097 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934187AbeAHPx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 10:53:56 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D8497AC9E
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 15:53:54 +0000 (UTC)
Date: Mon, 8 Jan 2018 16:51:48 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Next btrfs development cycle open - 4.17
Message-ID: <20180108155148.GB13726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.14 - current
4.15 - upcoming, urgent regression fixes only
4.16 - development closed, pull request in prep, fixes or regressions only
4.17 - development open, until 4.16-rc5 (at least)

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)

There's going to be 4.15-rc8 at least, the current patch queue for 4.16
will likely get rebased on top of that. Unless there's something urgent
in late 4.15, this will be the last rebase and thus should be a stable
base for new development.

The current patch queue (as is in misc-next) looks stable, so no big
changes are going to be applied at this time. The usual exceptions are
bugfixes or obvious cleanups.

The base of the patches should be the last announced pull request, which
is going to be named 'for-4.16' in my k.org tree.  Reviewed patches will
be collected in a branch that's usually named 'misc-next' in my devel
git repos and is part of the for-next at k.org git repo.

k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
devel1: http://repo.or.cz/linux-2.6/btrfs-unstable.git
devel2: https://github.com/kdave/btrfs-devel

d.
