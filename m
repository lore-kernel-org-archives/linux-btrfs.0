From: sniper <s3c24xx@gmail.com>
Subject: Re: bug when removing device
Date: Fri, 30 Apr 2010 21:37:54 +0800
Message-ID: <k2i9bd6b5361004300637v6463b9f4w5e1348f74d2db06e@mail.gmail.com>
References: <j2x9bd6b5361004281111u565c16d7x24ea3d4640ca365@mail.gmail.com>
	 <p2u3d0408631004290158j40591c7coee8c6fc73c3d06d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <ukernel@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <p2u3d0408631004290158j40591c7coee8c6fc73c3d06d1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I have sent a set of patches that address bugs like this.
>

I applied the V2 patchset to kernel-v2.6.32 (actually, I applied them
to btrfs-unstalbe, took a kernel-v2.6.32 and replaced its btrfs with
the patched one in btrfs-unstable), and did the test, then got:

$ sudo btrfs device del /dev/loop1 /tmp/mnt0/
ERROR: error removing the device '/dev/loop1'
$ sudo btrfs device del /dev/loop0 /tmp/mnt0/
ERROR: error removing the device '/dev/loop0'

dmesg:
[ 3463.136786] btrfs: unable to remove the only writeable device
[ 3468.205188] btrfs: unable to remove the only writeable device


Is it something wrong?
