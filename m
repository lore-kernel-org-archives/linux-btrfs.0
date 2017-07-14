Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36561 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753876AbdGNKhZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 06:37:25 -0400
Received: by mail-oi0-f67.google.com with SMTP id n2so9772579oig.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Jul 2017 03:37:25 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: "Oliver O." <oliver.o456i@gmail.com>
Subject: Btrfs cross-subvolume inode scheme not working as intended with
 snapshots?
Cc: josef@toxicpanda.com, bfields@fieldses.org, clm@fb.com
Message-ID: <d82a6d8a-d6d3-0942-ccd1-c81ff2f16056@gmail.com>
Date: Fri, 14 Jul 2017 12:37:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I think I've found a corner case where the current cross-subvolume inode scheme
does not work as intended:

Subvolumes are created as (sort-of) file system 'roots' with a fixed inode
number of 256 and a separate st_dev. So the st_dev/inode combination is unique
as usual.

The output below shows what happens with a snapshot of a subvolume "@parent"
containing two lower-level subvolumes "@child1" and "@child2". The lower-level
subvolumes are not part of the snapshot "@parent-snapshot", but appear as
empty 'mountpoint' directories.

However, stat returns a new common st_dev (example: 21), and an identical inode
(example: 2) for both. This is unusual in two aspects: Firstly, since there are
no subvolumes actually 'mounted' at these empty directories, why is there a new
st_dev popping up? Secondly, it's the same st_dev for each of those directories,
though they would be separate 'roots' if mounted.

This confuses file system tools, which expect unique st_dev/inode combinations
for separate files (which includes directories). In my case, a backup tool
developed internally complained on what seemed to be hard-linked directories (a
no-go) when it encountered a snapshot with docker-created lower-level
subvolumes.

Here is the output, followed by my little script, and a suggestion:

---

Ubuntu 4.8.0-58.63~16.04.1-generic 4.8.17
btrfs-progs v4.4
Create subvolume './@parent'
Create subvolume '@parent/@child1'
Create subvolume '@parent/@child2'
Create a snapshot of '@parent' in './@parent-snapshot'
# stat -c (st_dev=%d, st_ino=%i) %n @parent @parent/@child1 @parent/@child2
(st_dev=68, st_ino=256) @parent
(st_dev=124, st_ino=256) @parent/@child1
(st_dev=128, st_ino=256) @parent/@child2
# stat -c (st_dev=%d, st_ino=%i) %n @parent-snapshot @parent-snapshot/@child1 @parent-snapshot/@child2
(st_dev=129, st_ino=256) @parent-snapshot
(st_dev=21, st_ino=2) @parent-snapshot/@child1
(st_dev=21, st_ino=2) @parent-snapshot/@child2
Delete subvolume (no-commit): '/home/oliver/Downloads/Btrfs/@parent-snapshot'
Delete subvolume (no-commit): '/home/oliver/Downloads/Btrfs/@parent/@child2'
Delete subvolume (no-commit): '/home/oliver/Downloads/Btrfs/@parent/@child1'
Delete subvolume (no-commit): '/home/oliver/Downloads/Btrfs/@parent'

---

#!/usr/bin/env bash

set -e

cat /proc/version_signature
btrfs --version

sudo btrfs subvolume create @parent
sudo btrfs subvolume create @parent/@child1
sudo btrfs subvolume create @parent/@child2

sudo btrfs subvolume snapshot @parent @parent-snapshot

echo '#' stat -c '(st_dev=%d, st_ino=%i) %n' @parent @parent/@child1 @parent/@child2
stat -c '(st_dev=%d, st_ino=%i) %n' @parent @parent/@child1 @parent/@child2

echo '#' stat -c '(st_dev=%d, st_ino=%i) %n' @parent-snapshot @parent-snapshot/@child1 @parent-snapshot/@child2
stat -c '(st_dev=%d, st_ino=%i) %n' @parent-snapshot @parent-snapshot/@child1 @parent-snapshot/@child2

sudo btrfs subvolume delete @parent-snapshot
sudo btrfs subvolume delete @parent/@child2
sudo btrfs subvolume delete @parent/@child1
sudo btrfs subvolume delete @parent

---

What to do about it? One idea would be to hide the lower-level 'mount point'
directories entirely from the snapshot. The reason is that in a backup-restore
scenario, 'btrfs subvolume create' would fail if its 'mount point' was already
occupied by an empty directory.

Cheers,

Oliver

