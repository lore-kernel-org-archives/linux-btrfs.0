Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:37272 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3AXJYX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 04:24:23 -0500
Message-ID: <5100FDA3.3040907@giantdisaster.de>
Date: Thu, 24 Jan 2013 10:23:47 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 01/10] Btrfs-progs: move open_file_or_dir() to utils.c
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com> <1358928771-31960-2-git-send-email-anand.jain@oracle.com> <5100BB01.3030408@redhat.com>
In-Reply-To: <5100BB01.3030408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 23 Jan 2013 22:39:29 -0600, Eric Sandeen wrote:
> instead of renaming & keeping the btrfsctl.c copy

There is a new momentum to improve the Btrfs-progs quality :)

IMO, one step is to get rid of the legacy tools and sources. It wastes
time to maintain them and these old tools cause confusion. btrfsctl.c,
btrfs-vol.c and btrfs-show.c are not needed anymore. Please correct me
if there are plans to use these old tools in future Linux distributions.
The "btrfs" tool replaces the legacy "btrfsctl", "btrfs-vol" and
"btrfs-show" tools. Below, the usage text of the old tools is quoted.
All these tasks are also offered in the "btrfs" tool, and this tool is
the newer one.

Some time ago I sent a patch to remove these legacy tools from the
default build
<http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16919.html>.
We should also remove the sources. Any objections against this?

If we don't have btrfsctl.c anymore, we don't need to worry about
open_file_or_dir() in that file. We could either leave Anand's patch as
it is and afterwards remove btrfsctl.c, or remove the file first and
then the open_file_or_dir() patch can be shrunken.

usage: btrfsctl [ -d file|dir] [ -s snap_name subvol|tree ]
                [-r size] [-A device] [-a] [-c] [-D dir .]
        -d filename: defragments one file
        -d directory: defragments the entire Btree
        -s snap_name dir: creates a new snapshot of dir
        -S subvol_name dir: creates a new subvolume
        -r [+-]size[gkm]: resize the FS by size amount
        -A device: scans the device file for a Btrfs filesystem
        -a: scans all devices for Btrfs filesystems
        -c: forces a single FS sync
        -D: delete snapshot
        -m [tree id] directory: set the default mounted subvolume to the
[tree id] or the directory

usage: btrfs-vol [options] mount_point
        -a device add one device
        -b balance chunks across all devices
        -r device remove one device

usage: btrfs-show [search label or device]

