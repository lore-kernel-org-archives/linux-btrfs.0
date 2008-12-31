From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs for mainline
Date: Wed, 31 Dec 2008 06:28:55 -0500
Message-ID: <1230722935.4680.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've done some testing against Linus' git tree from last night and the
current btrfs trees still work well.

There are a few bug fixes that I need to include from while I was on
vacation but I haven't made any large changes since early in December:

Btrfs details and usage information can be found:

http://btrfs.wiki.kernel.org/

The btrfs kernel code is here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

And the utilities are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


