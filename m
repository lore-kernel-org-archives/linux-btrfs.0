Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38705 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab3JKNng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 09:43:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8C0BD7C06AF
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 07:43:36 -0600 (MDT)
Date: Fri, 11 Oct 2013 09:43:33 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <linux-btrfs@vger.kernel.org>, <zab@redhat.com>
Subject: Re: [PATCH] Btrfs: init device stats for new devices
Message-ID: <20131011134333.GJ16461@localhost.localdomain>
References: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 03:20:42PM +0200, Stefan Behrens wrote:
> Device stats are only initialized (read from tree items) on mount.
> Trying to read device stats after adding or replacing new devices will
> return errors.
> 
> btrfs_init_new_device() and btrfs_init_dev_replace_tgtdev() are the two
> functions that allocate and initialize new btrfs_device structures after
> a filesystem is mounted. They set the device stats to zero by using
> kzalloc() which is correct for new devices. The only missing thing was
> to declare these stats as being valid (device->dev_stats_valid = 1) and
> this patch adds this missing code.
> 
> This is the reproducer:
> 
> TEST_DEV1=/dev/sdzzzzz1
> TEST_DEV2=/dev/sdzzzzz2
> TEST_DEV3=/dev/sdzzzzz3
> TEST_MNT=/mnt
> mkfs.btrfs $TEST_DEV1
> mount $TEST_DEV1 $TEST_MNT
> btrfs device add $TEST_DEV2 $TEST_MNT
> btrfs device stat $TEST_MNT
> btrfs replace start -B $TEST_DEV2 $TEST_DEV3 $TEST_MNT
> btrfs device stat $TEST_MNT
> umount $TEST_MNT
> 

Sounds like something that would look great in xfstests,

Josef
