Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3CLRhk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 13:37:40 -0400
Date: Tue, 12 Mar 2013 18:37:39 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, sensille@gmx.net,
        sbehrens@giantdisaster.de
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130312173738.GQ7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130312170312.GO7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130312170312.GO7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 06:03:12PM +0100, David Sterba wrote:
> while testing the userspace scrub updates, I've found lots of parent
> transid verify failures (see below) that are likely unrelated to the
> userspace patches.

Reproduced, now with

[  293.442196] btrfs bad fsid on block 1462738944
[  293.996306] btrfs bad fsid on block 1463144448
[  294.005770] btrfs bad fsid on block 1463222272
[  303.764105] btrfs bad fsid on block 1467568128
[  303.797632] btrfs bad fsid on block 1467973632
[  303.989611] btrfs bad fsid on block 1472954368
[  303.996121] btrfs bad fsid on block 1472966656
[  304.002925] btrfs bad fsid on block 1472970752
[  304.024547] btrfs bad fsid on block 1472974848
[  304.032450] btrfs bad fsid on block 1472983040
[  304.038529] btrfs bad fsid on block 1473355776
[  304.044298] btrfs bad fsid on block 1473327104
[  304.113243] btrfs bad fsid on block 1473867776
[  342.543104] btrfs bad fsid on block 1473372160
[  342.888828] btrfs bad fsid on block 1475330048
[  342.911393] parent transid verify failed on 1421537280 wanted 12 found 7
[  342.931673] parent transid verify failed on 1421537280 wanted 12 found 7
[  342.935211] parent transid verify failed on 1422024704 wanted 12 found 7
[  342.948243] parent transid verify failed on 1422024704 wanted 12 found 7

and the rest of stacktraces was the same.

Reproducer, for the record:

---
#!/bin/sh

dir=${1:-`pwd`}

for i in `seq 16`; do
        mkdir -p $dir/scratch/$i
done

fs_mark  -D  5000  -S0  -n  100000 -s  0  -L  200 \
         -d $dir/scratch/0  -d $dir/scratch/1 \
         -d $dir/scratch/2  -d $dir/scratch/3 \
         -d $dir/scratch/4  -d $dir/scratch/5 \
         -d $dir/scratch/6  -d $dir/scratch/7 \
         -d $dir/scratch/8  -d $dir/scratch/9 \
         -d $dir/scratch/10  -d $dir/scratch/11 \
         -d $dir/scratch/12  -d $dir/scratch/13 \
         -d $dir/scratch/14  -d $dir/scratch/15 \
         -d $dir/scratch/15  -d $dir/scratch/16
---

shell 1:
mkfs.btrfs -d raid10 -m raid10 /dev/sda[5678]
mount /dev/sda5 /mnt/a1
[fs_mark]

shell 2:
wait a few minutes
btrfs scrub start /mnt/a1
btrfs scrub status /mnt/a1

scrub status for f47ea685-06e8-4c1c-960b-61d7940ed370
        scrub started at Tue Mar 12 18:25:25 2013, running for 55 seconds
        total bytes scrubbed: 0.00 with 0 errors

# (strange that it's 0 bytes ...)
# so far nothing in the syslog

btrfs scrub cancel /mnt/a1

# check dmesg, filesystem turns RO
---
