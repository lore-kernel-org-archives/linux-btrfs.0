Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab3LILPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Dec 2013 06:15:31 -0500
Message-ID: <52A5A268.3030302@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 18:58:48 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: vikigoyal@gmail.com
CC: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: scub neither running nor canceling nor can be restarted.
References: <20131209095133.GA6579@mail2.smcindiaonline.com>
In-Reply-To: <20131209095133.GA6579@mail2.smcindiaonline.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Vikram,

On 12/09/2013 05:51 PM, Vikram Goyal wrote:
> Hello,
>
> I am having a problem where a stuck scrub on root FS cannot be
> cancelled or restsrted.
>
> Please See:
> [root@mail2 ~]# btrfs filesystem show
> Label: fedora_mail2  uuid: d2b3420c-99c1-44cc-a922-ac266072c7fb
> Total devices 2 FS bytes used 58.88GiB
> devid    2 size 73.51GiB used 31.03GiB path /dev/sdb6
> devid    3 size 73.30GiB used 32.03GiB path /dev/sda2
>
> Label: Vikram  uuid: 0809b072-35f3-4866-92b8-af4772b23ed6
> Total devices 2 FS bytes used 98.05GiB
> devid    1 size 158.03GiB used 99.04GiB path /dev/mapper/sda3
> devid    2 size 157.00GiB used 99.03GiB path /dev/dm-1
>
> Btrfs v3.12
> [root@mail2 ~]# btrfs scrub status -d /
> scrub status for d2b3420c-99c1-44cc-a922-ac266072c7fb
> scrub device /dev/sdb6 (id 2) status
> scrub started at Thu Apr 18 13:51:13 2013, running for 105 seconds
> total bytes scrubbed: 3.81GiB with 0 errors
> scrub device /dev/sda2 (id 3) status
> scrub started at Thu Apr 18 13:51:13 2013, running for 105 seconds
> total bytes scrubbed: 4.34GiB with 0 errors
>
> [root@mail2 ~]# btrfs scrub cancel /
> ERROR: scrub cancel failed on /: not running
>
> [root@mail2 ~]# btrfs scrub start -Bd /
> ERROR: scrub is already running.
> To cancel use 'btrfs scrub cancel /'.
> To see the status use 'btrfs scrub status [-d] /'.

I came the same issue before and i sent a patch for this:
https://patchwork.kernel.org/patch/3264051/

This patch has been merged into David's integration branch.
You can pull from:

https://github.com/kdave/btrfs-progs.git integration-20131206

you can use:
# btrfs scrub start -f /

This should help, -f will force us to skip check in userspace.

Thanks,
Wang
> Thanks!

