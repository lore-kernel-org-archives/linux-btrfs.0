From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Setting options permanently?
Date: Mon, 30 Jan 2012 15:49:27 +0800
Message-ID: <4F264B87.3090400@cn.fujitsu.com>
References: <4F22BCCC.5090800@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F22BCCC.5090800@danisch.de>
List-ID: <linux-btrfs.vger.kernel.org>

> Is there a way to set options like compression on a btrfs permanently to
> activate them even when mounted automatically by the desktop or manually
> by a third person?

Actually there is.

Btrfs supports per file compression flag, and if this flag is set to a
directory, all files in that directory will inherit the flag.

So you can mount the filesystem for the first time and set the flag for
the root dir, and that's it. There's a flaw that the compression method
is zlib, which should be changed to lzo (or lz4, or snappy..) in the
future.

chattr is used to set file flags, and there was a patchset to enable
compression flag for chattr, but was never merged:

http://www.spinics.net/lists/linux-btrfs/msg09604.html
http://www.spinics.net/lists/linux-btrfs/msg09605.html
