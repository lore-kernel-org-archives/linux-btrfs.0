Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:44129 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2HVWfz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 18:35:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by seven.medozas.de (Postfix) with ESMTP id C64E396A07CB
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2012 00:35:51 +0200 (CEST)
Date: Thu, 23 Aug 2012 00:35:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfsprogs: cases of snapshot failures
Message-ID: <alpine.LNX.2.01.1208230019270.21451@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Since btrfs does not do recursive atomic snapshots (which I am ok with),
I am doing this myself. A handful of suggestions/problems came up.

1. Maybe btrfsprogs could gain an option to do recursive non-atomic
snapshots at the userspace level, simply invoking low-level atomic
snapshots one by one?


For the following, the kernel is 3.4.4 with the too-overloaded "0.19"
version of btrfsprogs.

2. Subvolume directories are somewhat special, as you may know.
Only `btrfs sub create/snap` creates them, and they cannot be rmdird.

# btrfs sub list .
ID 256 top level 5 path HEAD
[...]
ID 450 top level 5 path HEAD/woven
ID 451 top level 5 path HEAD/leet

Attempting to snapshot a directory with further subvolumes in it
has the strange effect that directories get created, and do so
with the wrong inode info:

# ls -l HEAD
total 4
drwxr-xr-x 1 root root  18 Aug 18 01:04 .
dr-xr-xr-x 1 root root 218 Aug 23 00:25 ..
drwxr-xr-x 1 root root  66 Aug 17 23:04 leet
drwxrwx--- 1 root root 100 Aug 18 00:53 woven

# btrfs sub snap HEAD today
Create a snapshot of 'HEAD' in './today'
# ls -l today
total 4
drwxr-xr-x 1 root root  18 Aug 18 01:04 .
dr-xr-xr-x 1 root root 228 Aug 23 00:25 ..
drwxr-xr-x 1 root root   0 Aug 23 00:25 leet
drwxr-xr-x 1 root root   0 Aug 23 00:25 woven


3. The creation of these non-special directories in today/
is undesired, because now I need to rmdir them first before
creating the subsnapshots.

# btrfs sub snap HEAD today
Create a snapshot of 'HEAD' in './today'
# btrfs sub snap HEAD/leet today/
Create a snapshot of 'HEAD/leet' in 'today//leet'
ERROR: cannot snapshot 'HEAD/leet' - File exists


4. Because today/leet already exists as a non-subvolume root,
btrfsprogs defaults to creating another directory inside it
(unexpected, but ok). However, while doing so, it runs into
some unexplainable ENOTTY:

# btrfs sub snap HEAD today
Create a snapshot of 'HEAD' in './today'
# btrfs sub snap HEAD/leet today/leet
Create a snapshot of 'HEAD/leet' in 'today/leet/leet'
ERROR: cannot snapshot 'HEAD/leet' - Inappropriate ioctl for device
(^failure where success would have been expected)

Successes:
# rmdir today/leet/
# mkdir today/leet
# btrfs sub snap HEAD/leet today/leet
Create a snapshot of 'HEAD/leet' in 'today/leet/leet'

So today/leet as created by `sub snap HEAD` is also some weird
object.
