Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46376 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbbCWFGZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 01:06:25 -0400
Received: from gardel-login.0pointer.net (gardel.0pointer.net [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
	by gardel.0pointer.net (Postfix) with ESMTP id 7F888E80EA8
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2015 05:57:18 +0100 (CET)
Date: Mon, 23 Mar 2015 05:57:18 +0100
From: Lennart Poettering <mzerqung@0pointer.de>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Recursive subvolume snapshots and deletion?
Message-ID: <20150323045718.GE19498@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Heya!

So what's the story on recursive btrfs snapshotting and snapshot
removal? Since a while systemd has now by default creating btrfs
subvolumes for /var/lib/machines for example. Now, if that code is run
inside a container, and the container itself already is stored in a
subvolume we end up with a subvolume inside a subvolume, which
currently breaks snapshotting and deletion of the outer container
subvolume.

What's the plan regarding recursive versions of the operations? Any
plan to add this? We could work around this in userspace, of course,
but it would not be atomic, and I'd much prefer if the kernel could do
this on its own!

Lennart
