From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 0/5] btrfs-progs: Create libbtrfs and package it up
Date: Fri, 13 Jun 2008 16:09:06 -0400
Message-ID: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris -

Here's the patch set I mentioned earlier.

It consists of 4 patches and a script. Otherwise it'd be a lot more patches
that only move files around. The end result after running the script
is a directory tree that looks like this:

 btrfs-progs/lib
 btrfs-progs/src/debug
 btrfs-progs/src/fsck
 btrfs-progs/src/test
 btrfs-progs/src/util
 btrfs-progs/src/convert
 btrfs-progs/src/mkfs

lib contains the objects that used to be $(COMMON_OBJS), but are now
a full-fledged shared library with supporting includes to be installed
in /usr/include/btrfs. Headers are also placed in lib so that patches
indended for the kernel can also apply to the library without a lot of
effort.

* Patch 1: Converts to autotools
* Patch 2: Adds check for sparse support
* Patch 3: Creates libbtrfs and reshuffle programs to use it
* Patch 4: Creates a spec file

I know there are a lot of people out there who hate autotools. I'm not
a fan myself, but it does make the checking for optional libraries and
the generation of new ones really easy.

The spec file expects the library to exist and will create three packages:
btrfs-progs, libbtrfs, and libbtrfs-devel.

This all works for me.

-Jeff

-- 
Jeff Mahoney
SUSE Labs

