From: redneb@gmx.com
Subject: File cloning across subvolumes with BTRFS_IOC_CLONE ioctl
Date: Tue, 20 Jul 2010 01:39:35 -0400
Message-ID: <20100720053934.GA14402@epicurus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

It seems that the BTRFS_IOC_CLONE ioctl fails when trying to do a 
cross-subvolume clone of a file. Chris Mason suggested in the past ([1]) 
that this should be possible. Am I missing something?

[1] http://kerneltrap.org/mailarchive/linux-btrfs/2010/6/10/6884911
