From: dclist@gmail.com
Subject: Why does fsck returns "unresolved ref root"
Date: Sun, 07 Aug 2011 19:38:47 -0400
Message-ID: <877h6okd14.fsf@invalid.clx>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


On my system btrfsck runs periodically at boot. When it is run I get the
error message "unresolved ref root" in reference to a snapshot I
created. Consequently the fsck gets re-run during the following boot
repeating a time consuming process. I can disable fsck but I would like
to fix any issues with my filesystem.

How do I diagnose the problem? The snapshot seems to function correctly
when the filesystem is mounted. I do not remember the details of how I
created the snapshot.

I appreciate any advice.

