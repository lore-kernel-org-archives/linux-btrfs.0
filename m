Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752096AbdFZQOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 12:14:16 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EB852AAC5
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jun 2017 16:14:08 +0000 (UTC)
Date: Mon, 26 Jun 2017 18:13:00 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Next btrfs development cycle open - 4.14
Message-ID: <20170626161300.GN2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a friendly reminder of the timetable and what's expected at this phase.

4.11 - current
4.12 - upcoming, urgent regression fixes only
4.13 - development closed, pull request pending, fixes or regressions only
4.14 - development open, until 4.13-rc5

(https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#Development_schedule)

Besides the the usual cleanups and fixes, you can now start sending any patches
that could be more intrusive and would benefit from a longer period of
testing, or development revisions.

The base of the patches should be the last pull request, which is
'for-4.13-part1' in my k.org tree. Reviewed patches will be collected in a
branch that's usually named 'misc-next' in my devel git repos and is part of
the for-next at k.org git repo.

k.org: https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
devel1: http://repo.or.cz/linux-2.6/btrfs-unstable.git
devel2: https://github.com/kdave/btrfs-devel

d.
