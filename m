Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42145 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755541AbdIHRhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:37:51 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA6E3AEE9
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 17:37:50 +0000 (UTC)
Date: Fri, 8 Sep 2017 19:36:22 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-progs task tracking on github
Message-ID: <20170908173622.GU31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

in order to make more visible which tasks for btrfs-progs are in
progress or desired, I've started to populate the github Projects [1]
some time ago. I haven't fleshed out the workflow so this hasn't been
announced yet.

The aim is to help contributors to join progs development and start from
one point with the tasks to choose from. Current practice is to either
ask on IRC or find something on the wiki, hoping that the projects are
still up to date. Not all of them are, wiki is not the best tool for
task tracking.

Using github issues and projects is diversion from the current model
similar to the kernel part of btrfs, ie. mailinglist for everything.
This does suite all the needs but I don't want to completely switch to
github-only workflow.  Leaving both options means that bug/patchset
discussions will not be visible to both audiences directly, but web
archives or publicly accessible github pages should be enough for
cross-references.

The exact workflow from a task to a merge is not yet defined, I hope
we'll be able to find out and document it once the first guinea pig
volunteers. The Projects use the kanban-style, I made a bit familiar
with that but have no prior experience with it.

There are categories for tasks and some brief descriptions. The rough
idea is to:

1. move a task from TODO to WIP
2. create issue from the task, for discussions etc
3. work on patches, review cycle
4. when finished, move to next stage on the project page, and ask for merge
5. task is done, code merged and released

Who does what and how exactly will have to be found on the way and
documented eventually.

[1] https://github.com/kdave/btrfs-progs/projects
