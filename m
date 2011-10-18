From: Tomasz Chmielewski <tch@wpkg.org>
Subject: btrfs defragment: ioctl failed, ret -1 errno 28
Date: Tue, 18 Oct 2011 12:50:02 +0200
Message-ID: <4E9D59DA.4000403@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I'm trying to defragment a 280 GB file when running 3.1.0-rc9 kernel:

# filefrag /mnt/btrfs/images/srv1-backup.qcow2
/mnt/btrfs/images/srv1-backup.qcow2: 1139699 extents found


# btrfs filesystem defragment /mnt/btrfs/images/srv1-backup.qcow2
ioctl failed on /mnt/btrfs/images/srv1-backup.qcow2 ret -1 errno 28
total 1 failures


Some files fail to defragment like this; some are defragmented correctly.

Why does it fail?


-- 
Tomasz Chmielewski
http://wpkg.org
