Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:44196
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab3BRHwY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 02:52:24 -0500
Message-ID: <5121DC0D.8060305@gmail.com>
Date: Sun, 17 Feb 2013 23:45:17 -0800
From: Bob McGowan <ramjr0915@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "Fixing" mount points
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First, apologies if this is "well known", I'm totally new here, and
haven't figured out yet how to search the archives.

Also, I'm not a subscriber, so please respond to me as well as the list.

I've had a number of issues with distribution installations (separate
and unrelated issues, but history and context).  I had a system set up,
with a separate /home (brtfs, sda1), when it crashed (badly) while
updating and rebuilding the kernel.

I installed again (different window system, same distribution) and to be
"completely safe", I left the /home out of the new setup.  I want (need)
to keep it because it has a very large of digital photos and I'd rather
not have to restore them again (between audio, video, the photos, DVD
images, about 800GB).

So, I now have a volume/subvolume on one disk, where the subvolume is
/home (brtfs, sde2), and I want to change fstab to mount sda1 as /home
instead.

For any other FS I've worked with, simple edits of fstab would be
enough, but doing so doesn't appear to be enough for btrfs.

Even though things look OK from the command line, logging in through the
window system fails (actually, just hangs).

I assume this means I should be doing something to "clean up" the
subvolume?  Or maybe there's something in the Window system
configuration to change?

I'm running Linux Mint 14 KDE.  My fstab for the parts in question looks
like:

# / was on /dev/sde2 during installation
UUID=1a...9 /     btrfs   defaults,subvol=@     0       1
# /home was on /dev/sde2 during installation
UUID=1a...9 /home btrfs   defaults,subvol=@home 0       2

What I want is something like:
# / was on /dev/sde2 during installation
UUID=1a...9 /     btrfs   defaults              0       1
# /home is on /dev/sda1
UUID=7f...3 /home btrfs   defaults              0       2

Thanks for bearing with me as I learn this new environment. ;-)

Bob
