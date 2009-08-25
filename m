From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: snapshot/subvol deletion
Date: Tue, 25 Aug 2009 22:38:01 +0800
Message-ID: <4A93F749.3010708@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I will send a series patches that add snapshot/subvol deletion soon.
But the way to delete snapshot/subvol is far from people's expectancy.
To delete a snapshot/subvol, we need four steps: 1) snapshot/subvol
deletion ioctl or rmdir; 2) umount; 3) btrfsck; 4) mount the fs.

The reason for this is bug in root back & forward references. In simple
terms, the bug prevents us from knowing how many places a snapshot/subvol
is referenced. So it's unsafe delete corresponding fs tree immediately
after a link to snapshot/subvol is removed.

Regards
Yan, Zheng
