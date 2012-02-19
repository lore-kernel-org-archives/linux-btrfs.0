From: andrew henry <adhenry.9@gmail.com>
Subject: online snapshots of subvolumes?
Date: Sun, 19 Feb 2012 13:47:27 +0100
Message-ID: <4F40EF5F.1010404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Can I create a snapshot of a subvolume whilst that subvolume is mounted?
If so can you explain how?

I read the sysadmin guide and it details one management setup where you
leave the initial fs empty, create a subvol, then mount that, and for
subsequent subvol operations you need to first unmount the subvol and
remount the original empty fs.

--Andrew

