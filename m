Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36085 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755428AbcEQBkh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 21:40:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b2Tzr-00005T-6t
	for linux-btrfs@vger.kernel.org; Tue, 17 May 2016 03:40:31 +0200
Received: from 87-127-16-100.static.enta.net ([87.127.16.100])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 03:40:31 +0200
Received: from 6401e46d by 87-127-16-100.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 May 2016 03:40:31 +0200
To: linux-btrfs@vger.kernel.org
From: al <6401e46d@opayq.com>
Subject: Scrub status regression (repost kinda)
Date: Tue, 17 May 2016 01:40:19 +0000 (UTC)
Message-ID: <loom.20160517T032830-349@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I'm still getting this regression on scrub. Scrub status no longer reports
the progress of the scrub. It always used to.

Anyone else experiencing the same regression?

Only quirky part of my setup which may throw btrfs off is that I create and
mount the first subvol as the root of the install. I repeat it is only
recently 3m that it has started to cease reporting.

The scrub itself proceeds normally and using '-B' returns the usual and
complete output.

# btrfs scrub start /                                                           
scrub started on /, fsid fdd6a335-6edf-4a74-a909-03c8102cc8f5 (pid=4111)

<reasonable time passes>

# btrfs scrub status /                                                          
scrub status for fdd6a335-6edf-4a74-a909-03c8102cc8f5
	no stats available
	total bytes scrubbed: 0.00B with 0 errors


