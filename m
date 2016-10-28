Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933523AbcJ1PKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 11:10:17 -0400
Date: Fri, 28 Oct 2016 17:10:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: send: fix handling of multiple
 snapshots (-p option)
Message-ID: <20161028151014.GI12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
In-Reply-To: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 19, 2016 at 11:35:03AM +0900, Tsutomu Itoh wrote:
> We cannot send multiple snapshots at once by -p option.

We cannot like that it's broken, or we cannot because it's not supposed
to work that way. I guess it's the former, but the changelog text is a
bit confusing.
> 
> [before]
> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
> At subvol Snap1
> At subvol Snap2
> ERROR: parent determination failed for 0
> # 
> 
> [after]
> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
> At subvol Snap1
> At subvol Snap2
> # 

I'm not sure it's fixed, I wrote a simple test, attached, that triggers
the bug even with the patch applied.

--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="test.sh"

#!/bin/bash
#
# minimal test for the following syntax: btrfs send -p parent subvol1 subvol2

source $TOP/tests/common

check_prereq mkfs.btrfs
check_prereq btrfs

setup_root_helper
prepare_test_dev 2g

run_check $TOP/mkfs.btrfs -f $IMAGE
run_check_mount_test_dev

here=`pwd`
cd "$TEST_MNT" || _fail "cannot chdir to TEST_MNT"

run_check $SUDO_HELPER btrfs subvolume create subv-parent
run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent subv-snap1
run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent subv-snap2
run_check $SUDO_HELPER dd if=/dev/urandom of=subv-parent/file bs=1M count=10
run_check $SUDO_HELPER btrfs subvolume snapshot -r subv-parent subv-snap3

run_check truncate -s0 "$here"/send.stream
run_check chmod a+w "$here"/send.stream
run_check $SUDO_HELPER btrfs send -f "$here"/send.stream -p subv-snap1 subv-snap2 subv-snap3

cd "$here" || _fail "cannot chdir back to test directory"

run_check_umount_test_dev

--BOKacYhQ+x31HxR3--
