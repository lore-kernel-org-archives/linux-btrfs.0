Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaFLGXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 02:23:22 -0400
Message-ID: <5399474A.3040003@oracle.com>
Date: Thu, 12 Jun 2014 14:23:06 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: fix race condition between btrfs and udev
References: <1402488698-12518-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1402488698-12518-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Wang,

> Futher, a easy way to trigger this problem is by running the following
> c codes repeatedly:
>
>   int main(int argc, char **argv)
>   {
>   	/* pass a btrfs block device */
>   	int fd = open(argv[1], O_RDWR | O_EXCL);
> 	if (fd < 0) {
> 		perror("fail to open: %s", strerror(errno));
> 		exit(1);
> 	}
> 	close(fd);
> 	return 0;
>   }
>
> So the problem is RW opening would trigger udev event which will
> call btrfs_scan_one_device().


> In btrfs_scan_one_device(), it
> would open the block device with EXCL flag..meanwhile if another
> program try to open that device with O_EXCL, it would fail with
> EBUSY.

  Expected. But do we need O_EXCL in kernel:btrfs_scan_one_device()
  at all ?

> This happen seldomly in the real world, but if we use loop device
> for test, we may hit this annoying problem.

> A walkaround way to solve this problem is to wait kernel scanning
> finished and then try it again.

  I agree this happens seldom in production. But I don't agree on
  something to fix as workaround.

  Just sent out the patch:
      btrfs: looping mkfs.btrfs -f <dev> may fail with EBUSY

  which I believe can be a final fix. Your review / tests appreciated.


Thanks, Anand

