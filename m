Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from peace.netnation.com ([204.174.223.2]:39508 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758862Ab2EQA5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 20:57:38 -0400
Received: from sim by peace.netnation.com with local (Exim 4.72)
	(envelope-from <sim@netnation.com>)
	id 1SUp29-0006xA-LI
	for linux-btrfs@vger.kernel.org; Wed, 16 May 2012 17:57:37 -0700
Date: Wed, 16 May 2012 17:57:37 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-btrfs@vger.kernel.org
Subject: btrfsck failures on old backup volumes
Message-ID: <20120517005737.GC12958@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

We have some btrfs rsync-snapshot backup servers which have been running
since about mid-2009, with a pretty good record so far. We've been
following the development kernels and hitting some bugs here an there,
but we still haven't managed to lose anything yet. The main problems we
have ran in to relate to ENOSPC and reporting full when "df" only shows
74% used, etc.

Recently, with some newer kernels (currently 3.4-rc6), we have some cases
where we can no longer write to some volumes -- they report out of space
even when trying to rm, or hang forever. Most volumes are 3TB carved from
some LVM'd attached storage.

Since btrfsck seems to exist now in git btrfs-progs, and this data is
already elsewhere, I figured it'd be worthwhile to try. On this one FS,
btrfsck in check mode reported thousands of errors. The --repair mode
did as well, and then exited with "failed to repair damaged filesystem,
aborting". Output logs (huge) are here: http://0x.ca/sim/ref/3.4-rc6/

I'm not sure how long these consistency issues have been on disk, since
these file systems have been around for many years. Is this useful data?
Would it be useful to try to reproduce these issues on smaller devices,
or are the current results helpful in any way for improving btrfsck?

Mount options for these are "noacl,noatime,nodiratime,compress-force",
and they were mkfs'd with no special options.

Cheers,

Simon-
