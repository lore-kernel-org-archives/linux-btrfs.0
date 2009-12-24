From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: btrfs-progs: New utility to swap subvolumes
Date: Thu, 24 Dec 2009 11:17:49 +0900
Message-ID: <4B32CF4D.90406@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

New utility(btrfsrevert) added to swap subvolumes.

With this utility, a subvolume (Source Subvolume) takes place of
another subvolume (Target Subvolume), and target subvolume goes
under hidden directory(".old_trees") in filesystem root(fs tree,
tree id=5), and its name is expanded with random UUID.

This utility cannot operate mounted filesystem. This is only for
unmounted device.
And this utility also cannot operate filesystem root. For now,
if we want to swap filesystem root, we can use btrfsctl with
Josef Bacik's patch. I wonder which is better, integrating 'root swap'
ioctl or not supporting 'root swap' as for this utility...

A patch follows this mail.


man-page-like description and examples are as follows.

NAME
       btrfsrevert - swap subvolumes.

SYNOPSIS
       btrfsrevert -s source_subvolume -t target_subvolume device

OPTIONS
       -s source subvolume
            Specify subvolume number which replace target
            subvolume.
       -t target subvolume
            Specify subvolume number which is replaced by
            source subvolume.

       device
            Specify target device which is not mounted.

SAMPLES
       Consider two subvolumes 'target'(id=256) and 'source'(id=300)
       exist in filesystem root.
           / +
             +- 'target' (id=256)
             +- 'source' (id=300)

       In this case, following command swaps subvolume,

          # btrfsrevert -s 300 -t 256 /dev/hda1

       like this.
           / +
             +- 'target' (id=300)
             |
             +- '.old_tree'
                 +- 'target_[random uuid]' (id=256)

            A subvolume(id:256) is replaced with a subvolume(id:300),
            and replaced subvolume(id:256) goes to .old_trees directory.

Regards,
taruisi

