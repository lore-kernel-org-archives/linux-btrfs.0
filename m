Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38724 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab3JKNrg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 09:47:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D3FE57C068B
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 07:47:35 -0600 (MDT)
Date: Fri, 11 Oct 2013 09:47:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fail device statistic reset on read-only
 filesystem
Message-ID: <20131011134733.GA5095@localhost.localdomain>
References: <2a649d6a51055ac36352a73add403037acc537ef.1381493768.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2a649d6a51055ac36352a73add403037acc537ef.1381493768.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 02:18:23PM +0200, Stefan Behrens wrote:
> Currently the attempt to reset the device statistics with
> 'btrfs device stat -z ...' on read-only filesystems does not return an
> error. The statistics that are hold in main memory are reset but the
> statistics that are stored in the filesystem are not reset.
> 
> Fix it by returning EROFS in this case.
> 
> This is the reproducer:
> 
>  #!/bin/sh
> TEST_DEV1=/dev/sdzzzzz1
> TEST_DEV2=/dev/sdzzzzz2
> TEST_MNT=/mnt
> echo 0 25165824 linear $TEST_DEV1 0 | dmsetup create foom
> echo 0 25165824 linear $TEST_DEV2 0 | dmsetup create foon
> mkfs.btrfs -f -d raid1 -m raid1 /dev/mapper/foom /dev/mapper/foon
> mount /dev/mapper/foom $TEST_MNT
>  # switch to I/O error mode:
> echo 0 25165824 error | dmsetup reload foon
> dmsetup resume foon
>  # cause I/O errors:
> touch ${TEST_MNT}/foo
> sync
>  # switch dm back to I/O good mode:
> echo 0 25165824 linear $TEST_DEV1 0 | dmsetup reload foon
> dmsetup resume foon
> umount ${TEST_MNT}
> btrfs dev scan
> mount /dev/mapper/foom ${TEST_MNT} -o ro
>  # will report counters != 0, should fail with EROFS
> btrfs device stat -z ${TEST_MNT}
>  # will report counters == 0:
> btrfs device stat ${TEST_MNT}
> umount ${TEST_MNT}
> mount /dev/mapper/foom ${TEST_MNT} -o ro
>  # will report counters != 0, i.e., the 'btrfs device stat -z' failed to
>  # clear the counters on disk, only the counters in main memory had been
>  # cleared:
> btrfs device stat ${TEST_MNT}
> umount ${TEST_MNT}
> dmsetup remove foom; dmsetup remove foon
> 

Hey look something else that should go into xfstests,

Josef
