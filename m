From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs trees for linux-next
Date: Thu, 20 Nov 2008 07:18:04 -0500
Message-ID: <1227183484.6161.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, sfr@canb.auug.org.au
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've updated the btrfs git trees to 2.6.28-rc5 and tested against
linux-next.

We've knocked a bunch of things off the todo list since I last posted,
including compression (mount -o compress) and the ability to create
subvols and snapshots anywhere in the FS.

There are a small number of disk format changes pending, which I put off
in favor of making compression stable/fast.  We'll hammer these out
shortly.

The btrfs kernel code is here:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=summary

And the utilities are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=summary

-chris


