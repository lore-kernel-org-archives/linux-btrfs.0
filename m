From: Craig Sanders <cas@taz.net.au>
Subject: convert raid-10 to raid-0?
Date: Sun, 5 Jun 2011 11:36:45 +1000
Message-ID: <20110605013645.GD8111@taz.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Please CC me on any replies as I am not subscribed to this list. Thanks.

Is it possible to convert an existing 4-disk btrfs volume created as
raid-10 to a btrfs raid-0/striped volume?

i've got a btrfs raid-10 volume made with 4x1TB drives that's running
out of space, and i'd prefer not to reformat it if i don't have to.

craig

-- 
craig sanders <cas@taz.net.au>

BOFH excuse #372:

Forced to support NT servers; sysadmins quit.
