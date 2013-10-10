Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:56221 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab3JJKUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 06:20:44 -0400
Received: from mailout-us.gmx.com ([172.19.198.45]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0LlV7D-1W2ASx1QXf-00bLEm for
 <linux-btrfs@vger.kernel.org>; Thu, 10 Oct 2013 12:20:44 +0200
Content-Type: text/plain; charset="utf-8"
Date: Thu, 10 Oct 2013 06:20:42 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20131010102043.74230@gmx.com>
MIME-Version: 1.0
Subject: BUG relating to fstrim on btrfs partitions
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think I found a bug affecting btrfs filesystems and users invoking fstrim to discard unused blocks: if I execute a `fstrim -v /` twice, the amount trimmed does not change on the 2nd invocation AND it takes just as long as the first.  Why do I think this is a bug?  When I do the same on an ext4 partition I get different behavior: the output shows 0 B trimmed and it does is instantaneously when I run it a 2nd time.  After contacting the fstrim developer, he stated that the userspace part (fstrim) does only one thing and it is invoke an ioctl (FITRIM); it is the job of the filesystem to properly implement this.

Supporting data
----------------
Example on a btrfs partition:
The 1st time:
% time sudo fstrim -v /
/: 5.2 GiB (5575192576 bytes) trimmed
sudo fstrim -v /  0.00s user 0.05s system 2% cpu 2.084 total

The 2nd time:
% time sudo fstrim -v /
/: 5.2 GiB (5575192576 bytes) trimmed
sudo fstrim -v /  0.00s user 0.06s system 2% cpu 2.107 total

If I run the command twice on an ext4 filesystem, it does go to zero and the 2nd invocation is instantaneous:
The 1st time:
% time sudo fstrim -v /                   
/: 15.4 GiB (16481087488 bytes) trimmed
sudo fstrim -v /  0.00s user 0.08s system 1% cpu 6.268 total

The 2nd time:
% time sudo fstrim -v /
/: 0 B (0 bytes) trimmed
sudo fstrim -v /  0.00s user 0.00s system 48% cpu 0.007 total
