From: Randy Barlow <randy@electronsweatshop.com>
Subject: Sparse files and block devices
Date: Mon, 08 Aug 2011 01:55:25 -0400
Message-ID: <4E3F7A4D.50702@electronsweatshop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I started playing with btrfs last night, and I must say that I am very
excited! I do have one question so far. Since I was learning, I created
a sparse file, and then used mkfs to get a btrfs filesystem. I
entertained myself with that for a while, and then decided that I wanted
to try out the multi device support. I found that the device add command
requires the device to be a block device, and wouldn't accept another
sparse file that I had created. Is there a workaround, or is that just
the way it is?

I ended up just making a logical volume to get the second block device.

Thanks for making such a cool fs!
