Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:50576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbcEYI6W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 04:58:22 -0400
To: linux-btrfs@vger.kernel.org
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Copy on write of unmodified data
Message-ID: <ae68a6ae-8184-88b8-05e5-8bb369d906b5@zytor.com>
Date: Wed, 25 May 2016 01:58:15 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm looking at using a btrfs with snapshots to implement a generational
backup capacity.  However, doing it the naïve way would have the side
effect that for a file that has been partially modified, after
snapshotting the file would be written with *mostly* the same data.  How
does btrfs' COW algorithm deal with that?  If necessary I might want to
write some smarter user space utilities for this.

	-hpa
