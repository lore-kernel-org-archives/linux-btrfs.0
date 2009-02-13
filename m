From: Chris Mason <chris.mason@oracle.com>
Subject: New experimental branch on the btrfs-unstable repo
Date: Fri, 13 Feb 2009 15:08:15 -0500
Message-ID: <1234555695.17533.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've added an experimental branch to the unstable repo, which is kind of
a really-really-really unstable flag.

It has all of my current performance and stack saving fixes, which
haven't yet made it through heavy stress testing, but do actually
improve performance.

More details will come on these later, but if you want to take a look,
the commits are here:

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=shortlog;h=experimental

And you get them by:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git experimental

-chris


