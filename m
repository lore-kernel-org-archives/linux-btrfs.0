Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39931 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbaHAXMs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:48 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/12] disk-io.c / open_ctree cleanup & refactoring
Date: Fri,  1 Aug 2014 18:12:34 -0500
Message-Id: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is mostly to refactor open_ctree(); at the end of the series
it's "only" around 600 lines instead of 900.

The first 2 patches are just little cleanups I saw while doing this;
the 3rd actually is something of a bugfix.

The rest are refactoring - this is a bit of an RFC still; some
seem like clear groups of code to move out of the way, others
are a bit more gratuitous.  Perhaps after these 300 lines are
moved out of the way, folks who are familiar with the code
can spot other reasonable groupings or functionality which could
also be factored out.

There are still large swaths of random initializations; I though
about "btrfs_initialize_locks_and_stuff()" but decided against it.
:)

Anyway, it builds & passes default xfstests "-g auto" runs, so it
can't be all bad.  Let me know what you think.  Different function
names might be better, better symmetry with close_ctree() might be good,
but it's a start.

Thanks,
-Eric

