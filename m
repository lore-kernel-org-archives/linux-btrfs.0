Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:49093 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaCKQmx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 12:42:53 -0400
Date: Tue, 11 Mar 2014 09:37:00 -0700
From: Zach Brown <zab@zabbo.net>
To: Saul Wold <sgw@linux.intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Building a brtfs filesystem < 70M?
Message-ID: <20140311163700.GQ2069@lenny.home.zabbo.net>
References: <531E4A02.5010404@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <531E4A02.5010404@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> There seems to be an issue if we try to build a btrfs based FS that
> is less than 70M, we get the following assertion failure:
> 
> mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion
> `!(ret)' failed.

> mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs

Honestly, the path of least resistance is probably to avoid the -r
option all together.  As you've found, it's not reliable.

I'd take the time to roll the infrastrcture to populate the image by
writing to a mounted image with the kernel code.

- z
