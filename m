From: Joe Peterson <lavajoe@gentoo.org>
Subject: Stable btrfs available for kernel 2.6.28?
Date: Mon, 15 Dec 2008 15:54:50 -0700
Message-ID: <4946E03A.2000505@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, and sorry if this has been answered...

Starting with kernel 2.6.28, the btrfs stable kernel module, version
0.16, does not compile.  I maintain the Gentoo Linux ebuilds for btrfs,
and I would very much like to retain a working stable btrfs as well as
unstable (which is not a problem, of course).

I have applied a variant of Yan's patch to fix calls to
__pagevec_lru_add(&pvec), but there are still numerous compile errors.
I don't feel comfortable patching myself given the critical nature of btrfs.

So, is there either a new stable version available now (or soon), or is
there a patch I can apply to 0.16 to get it working with 2.6.28?

					Thanks!
