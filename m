From: "Michael Niederle" <mniederle@gmx.at>
Subject: /dev/btrfs-control
Date: Fri, 8 Jan 2010 17:37:20 +0100
Message-ID: <20100108173720.07a6de69@simplux>
References: <4B4727F5.1080803@fs.ei.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4727F5.1080803@fs.ei.tum.de>
List-ID: <linux-btrfs.vger.kernel.org>

Some btrfs-tools make use of "/dev/btrfs-control".

How should I create this node? Is this a block or a character device (I suppose
it should be a character device), which major and minor numbers should be
assigned?

I do not use udev, so I have to create all device nodes "by hand" or "by
script".

I started using btrfs with the arrival of kernel 2.6.32 - no problems until
now! :-) I'm very interested in using its snapshot feature. Currently I'm not
able to mount a snapshot (subvolume), but this might be connected to the
missing device-node.

Thanks in advance for any help,

Michael
