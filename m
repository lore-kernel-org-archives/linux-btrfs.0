Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab3JVQjP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:39:15 -0400
Date: Tue, 22 Oct 2013 18:39:13 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
Message-ID: <20131022163913.GZ1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com>
 <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382421202-18494-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Somewhere among the updates 'btrfs fi show LABEL' stopped working and
xfstests/btrfs/006 fails. I did not know that this functionality exists so I
haven't paid attention to it during reviews.

btrfs/006 5s ...        [18:10:35] [18:10:40] - output mismatch (see /root/xfstests/results//btrfs/006.out.bad)
    --- tests/btrfs/006.out     2013-08-29 11:58:37.000000000 +0200
    +++ /root/xfstests/results//btrfs/006.out.bad       2013-10-22 18:10:40.000000000 +0200
    @@ -4,15 +4,44 @@
     TestLabel.006
     == Mount.
     == Show filesystem by label
    -Label: 'TestLabel.006'  uuid: <UUID>
    -   Total devices <EXACTNUM> FS bytes used <SIZE>
    -   devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
    +ERROR: arg type unknown
    +usage: btrfs filesystem show [options|<path>|<uuid>]
    +
    +    Show the structure of a filesystem
    +
    +    -d|--all-devices   show only disks under /dev containing btrfs filesystem
    +    -m|--mounted       show only mounted btrfs
    +    If no argument is given, structure of all present filesystems is shown.
    +
    +ERROR: arg type unknown
    +usage: btrfs filesystem show [options|<path>|<uuid>]
    +
    +    Show the structure of a filesystem
    +
    +    -d|--all-devices   show only disks under /dev containing btrfs filesystem
    +    -m|--mounted       show only mounted btrfs
    +    If no argument is given, structure of all present filesystems is shown.

     == Show filesystem by UUID
    -Label: 'TestLabel.006'  uuid: <EXACTUUID>
    +Label: none  uuid: <UUID>
    +   Total devices 4 FS bytes used <SIZE>
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sda5
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sda6
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sda7
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sda8
    +
    +Label: TestLabel.006  uuid: <UUID>
        Total devices <EXACTNUM> FS bytes used <SIZE>
        devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV

    +Label: none  uuid: <UUID>
    +   Total devices 1 FS bytes used <SIZE>
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sdb
    +
    +Label: none  uuid: <UUID>
    +   Total devices 1 FS bytes used <SIZE>
    +   devid <DEVID> size <SIZE> used <SIZE> path /dev/sda15
    +
     == Sync filesystem
     FSSync 'SCRATCH_MNT'
     == Show device stats by mountpoint

I did a quick tested with some older integration branch with
"btrfs-progs: btrfs_list_find_updated_files: Fix memory leak" on top and it
worked.

david
