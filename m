Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:32775 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab2LQXJH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 18:09:07 -0500
Received: from localhost (unknown [192.168.242.141])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by tetsuo.zabbo.net (Postfix) with ESMTPSA id 2F7FA72001B7
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 15:09:07 -0800 (PST)
Date: Mon, 17 Dec 2012 15:09:07 -0800
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: getdents spinning on 0x7fffffff
Message-ID: <20121217230907.GI9195@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was flipping through the code recently and noticed that we still have
the double whammy of allocating dir entry positions with
parent_dir->counter++ and that weird setting of f_pos to 2^31-1.

So after enough creates (and deletes :)) in a directory we end up with
an entry item whose key is past that value.  f_pos gets rewound instead
of being set to that magical EOF.  readdir() gets stuck returning the
entries after INT_MAX over and over (just one in this strace):

getdents(3, {{d_ino=257, d_off=2147483647, d_reclen=32, d_name="file-54"}}, 32768) = 32
getdents(3, {{d_ino=257, d_off=2147483647, d_reclen=32, d_name="file-54"}}, 32768) = 32

It took around 10 hours on a workstationy box over here to reproduce
this with createmany.c from the lustre tests ("./createmany -m f- -u f-
0x8000000" mknod()s and unlink()s 2^31 files), but that's tedious.  It's
easier to force initialization of index_cnt in the kernel to test
things.

1) The fundamental fix is to re-use deleted entry positions.  Do we add
another cache to index unlinked positions?  Do we add an unreliable
best-effort walk of the tree looking for holes in the key space?  At the
very least test index_cnt in unlink to get the basically useless
index_cnt--? :)

2) Regardless of that, we have to deal with existing entry items with
giant keys.  If for no other reason than big jerks making corrupt images
and leaving them on usb keys in Josef's driveway.  Should we drop the
silly INT_MAX setting for 64bit callers and return -EOVERFLOW for 32bit
callers?  (That'd be gross, but not unheard of.  ext4 has grown htree
behaviour that depends on compat detection: see its is_32bit_api()
callers.)

I can make up some fixes but I'd love to hear strong opinions first, if
anyone's got 'em :).

- z
