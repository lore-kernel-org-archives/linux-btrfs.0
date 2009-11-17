From: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: [PATCH] btrfs-progs: Check mount status of multidevice  filesystems
Date: Tue, 17 Nov 2009 19:55:42 +0100
Message-ID: <200911171955.42502.lists-receive@programmierforen.de>
References: <200911141944.51824.lists-receive@programmierforen.de> <3d0408630911151811u55fdb6rf82a97a1ee620e43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630911151811u55fdb6rf82a97a1ee620e43@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
Thanks for the review.

> Would you please add mounted check for multiple devices FS to
> check_mounted instead of btrfs_open_devices.  It's easy to get the
> list of devices, see code at very beginning of open_ctree_fd().
The new patch is almost done, but it still needs some testing. I'll submit it as soon as all tests are fine.
Are we interested in automated tests? So far, I've written some very simple shell scripts. Do we have a place to put this kind of code? All I could find about that is an entry in the wiki, which says that a "QA Suite for automated regression testing" is planned for v1.0.

	Cheers,
		Andi
