From: Arun Bhanu <btrfs@arunbhanu.com>
Subject: Problem with building btrfs into the kernel instead of module
Date: Wed, 8 Oct 2008 02:22:30 +0800
Message-ID: <20081007182230.GA19219@deepthought>
Reply-To: Arun Bhanu <btrfs@arunbhanu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have compiled btrfs into the kernel instead of building as module.
Then I create a btrfs filesystem on a partition and try to mount it and
I get the following error.

# mkfs.btrfs /dev/sda1
fs created label (null) on /dev/sda1
        nodesize 4096 leafsize 4096 sectorsize 4096 size 4.88GB
Btrfs v0.16-8-g09ab036

# mount -t btrfs /dev/sda1 /mnt/sda1/
mount: unknown filesystem type 'btrfs'

If I perform the above steps with btrfs built as a module I don't get
any error.

Is this a known issue or am I doing something wrong?

-Arun
