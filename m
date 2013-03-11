Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:51252 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754764Ab3CKWNa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:13:30 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] smalle cleanup + get_fs_info rework
Date: Mon, 11 Mar 2013 18:12:57 -0500
Message-Id: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The first patch is a trival close of fd on function returns, somehow
missed that last go-round.

The next 3 are a little more substantial, working to avoid the nasty
behavior of get_fs_info, closing & re-opening the callers' filehandle
out of scope, if it needs to switch from device node to mountpoint.

(I suppose we could pass in *fd by reference, but this behavior just
seems like a wrong, magical side effect for get_fs_info).

So instead, the callers use a helper to *always* wind up with the
mountpoint opened, and get_fs_info() now *only* - well - only gets
fs info.  The previous behavior of "if given a device act only on
that device; if given a mountpoint act on all devices" should persist;
I guess that's the original intent.

It's really only lightly tested; it should mostly affect:

* btrfs device stats
* btrfs replace start
* btrfs scrub start
* btrfs scrub status

so any independent sanity testing of that would be great.  It'l be
nice if/when we get xfstests coverage of some of this to make it easier. :)

Thanks,
-Eric

