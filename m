Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:56496 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdDAXvs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Apr 2017 19:51:48 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 6473760061
        for <linux-btrfs@vger.kernel.org>; Sun,  2 Apr 2017 01:51:46 +0200 (CEST)
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: python-btrfs v6: python 3 only + what now?
To: linux-btrfs@vger.kernel.org
Message-ID: <899638fe-0aeb-74f0-aa7e-0360e32faa77@mendix.com>
Date: Sun, 2 Apr 2017 01:51:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A few days ago, I tagged v6 of the python btrfs library:

https://github.com/knorrie/python-btrfs

== CHANGES ==

python-btrfs v6, Mar 24 2017
  * Only Python 3 supported from now on
  * IOCTLs: INO_LOOKUP, LOGICAL_INO, TREE_SEARCH_V2, IOC_BALANCE_V2,
    IOC_BALANCE_CTL, BALANCE_PROGRESS
  * Data structures: InodeRef, DirItem, DirIndex, XAttrItem,
    FileExtentItem, InodeExtref
  * Add a helper to retrieve free space tree extents
  * Check device error counters in the nagios plugin
  * Fixes:
    - Not loading backreferences for extents was broken
    - Handle IOCTL differences for different architectures
  * Examples added:
    - Show directory contents (both the index and namehash list)
    - Try to show a filename for data extents
    - Show file information (inode, xattrs, etc, and list of extents)
    - Show subvolumes

As usual, there's a wealth of information about everything that has been
added or changed in the git commit messages.

The biggest change this time is going python 3 only. Doing this really
improved the quality of my life. Trying to be 2 and 3 compatible was a
nice experiment, but having to test everything twice, playing whack a
mole schmack a mole all the time and living in the worst of both worlds
is not the best place to be. It was actually the reason that there was
no february release of python-btrfs. After making the decision I got the
thing going on again.

My favourites:
 * The SEARCH V2 IOCTL
https://github.com/knorrie/python-btrfs/commit/28e10d2495bde44805c1e09393bd4ea82b018409
 * Holy sh*t over 9000 faster OMG wheee yolo!!!
https://github.com/knorrie/python-btrfs/commit/9b6407d164eaa79ffe0494fa0ec82632128c783f
 * The balance IOCTL family
https://github.com/knorrie/python-btrfs/commit/f37eebcda1d4a52b58868007fc09099198177135

== Debian packages! ==

And... the debian packages are currently in the NEW queue of Debian!
    https://ftp-master.debian.org/new/python-btrfs_6-2.html
Big thanks to kilobyte for acting as mentor for my uploads! This means
that if accepted, we'll have it in unstable, and after the Stretch
release RSN, we can probably mirror all new versions in stretch-backports.

== What now? ==

Currently, I'm still researching free space fragmentation and how well
(*ehrm* how bad) btrfs handles reusing free space in allocated chunks.
Some progress is being made, many eyebrows were raised about ssd,nossd
mount options and I'll be adding an example soon that shows how to use
the new balance functions to feed block groups with bad free space
fragmentation patterns to balance in an effective way.

Besides that...

One of the things I learned when working on this project for the past
year is that development of features only gets done quick and properly
when there's an actual use case that needs solving using it. The
btrfs-heatmap tool is a very good example of this.

Now, I'm wondering what the next thing to do will be:

* Learning how to build C extensions for python, to integrate
btrfs-progs C code and be able to do crazy things really easily from python?
* Starting implementation of offline access to filesystems, to be able
to explore an unmountable or quite unusable filesystem (bad leaf! bad
node! bad key order!) and be able to interactively repairing things that
btrfschk cannot repair right now, or, which cannot easily be repaired by
an automated program because it needs some human reasoning to get the
bytes back in the right place...
* Or, start writing documentation. I tend to be able to write quite good
documentation, but it's a really time consuming thing to do. Usually
when I write documentation and ask for feedback, there's none, which
either means it's perfect, or it's not being read by anyone. :D

Actually, starting to write documentation is the one I think I'd like to
work on first. This page keeps being one of my favourites:
http://lartc.org/howto/lartc.iproute2.explore.html -> "ip shows us our
links"... this page made me learn networking many years ago. I'd like to
write documentation about btrfs in this way. Just start somewhere, start
exploring and show the reader what metadata trees are, how they're
organized, where you can find back your subvolumes and files, etc... And
of course show working code that can display everything using only a few
lines of python.

I'm not perfectly sure about the target audience, but it would probably
be the curious sysadmin user, who's also a bit of a programmer, and who
wants to learn more about the inner workings of his/her btrfs
filesystem. And... of course the ones that just want to do something
instead of getting sick of building regexes to parse human readable
output of other tools!

And when the reader gets more interested and starts reading kernel
source code, all of the struct names, constants etc will make instant
sense, because I'm keeping them as similar as possible as the C code.

What would you think/want?

Wait, is anyone actually using this besides myself? (I have no idea...)

Moo,

-- 
Hans van Kranenburg
