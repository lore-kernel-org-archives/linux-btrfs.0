Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966606Ab3HHVZ1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 17:25:27 -0400
Date: Thu, 8 Aug 2013 14:25:16 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Why does btrfs benchmark so badly in this case?
Message-ID: <20130808212516.GY12314@lenny.home.zabbo.net>
References: <CAJBj3vcfSrWC3sxxxin93GYYPZY_z_MJnAHoMxB45MFqEXYXkA@mail.gmail.com>
 <20130808194015.GH16712@localhost.localdomain>
 <CAJBj3vfrHPDhM579JZDhUQgmyd2PnUtrgwYX0718tOrK8MzNCA@mail.gmail.com>
 <2A60AA23-4496-4C0F-9B4A-22DF5DB3884F@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2A60AA23-4496-4C0F-9B4A-22DF5DB3884F@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I also don't know if any common use fs has an optimization whereby
> just the modified sector(s) is overwritten, rather than all sectors
> making up the file system block being modified.

Most of them do.  The generic direct io path allows sector sized dio.
The very first bit of do_blockdev_direct_IO() is testing first for file
system block size alignment then for block device sector size alignment.

You can see this easily with dd conv=notrunc oflags=direct and blktrace.

# blockdev --getss /dev/sda
512
# blockdev --getbsz /dev/sda
4096

# blktrace -d /dev/sda -a issue -o - | blkparse -i - &

$ dd if=/dev/zero of=file bs=4096 count=1 oflag=direct conv=notrunc
  8,0    3       14    35.957320002 17941  D  WS 137297704 + 8 [dd]

$ dd if=/dev/zero of=file bs=512 count=1 oflag=direct conv=notrunc
  8,0    1        4    31.405641362 17940  D  WS 137297704 + 1 [dd]

- z
