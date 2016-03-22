Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:37046 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149AbcCVIrV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 04:47:21 -0400
Subject: Re: csum errors in VirtualBox VDI files
To: Kai Krakow <hurikhan77@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56F1068E.6050806@cn.fujitsu.com>
Date: Tue, 22 Mar 2016 16:47:10 +0800
MIME-Version: 1.0
In-Reply-To: <20160322090342.595fefac@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Kai Krakow wrote on 2016/03/22 09:03 +0100:
> Hello!
>
> Since one of the last kernel updates (I don't know which exactly), I'm
> experiencing csum errors within VDI files when running VirtualBox. A
> side effect of this is, as soon as dmesg shows these errors, commands
> like "du" and "df" hang until reboot.
>
> I've now restored the file from backup but it happens over and over
> again.
>
> On another machine I'm also seeing errors with big files in the
> following scenario (apparently an older kernel, 4.1.x I afair):
>
> # ntfsclone --save /dev/md126p2 -o rescue.ntfs.img
>                     ^ big NTFS partition   ^ file on btrfs
>
> results in a write error and the file system goes read-only.

When it goes RO, it must have some warning in kernel log.
Would you please paste the kernel log?

>
> Both systems have in common they are using btrfs on bcache with
> compress=lzo,autodefrag,nossd,discard (mraid=1,draid=0 and
> mraid=1,draid=single).
>
> The system mentioned first is running Kernel 4.5.0 with Gentoo
> patch-set. I upgraded from the last 4.4.x kernel when I first
> experienced this problem. The first time the problem resulted in a
> duplicate extent which btrfsck wasn't able to fix, that's when I first
> restored from backup. But now I'm getting csum errors in this file over
> a over again, plus when rsync has run for backup, the system no longer
> responds to "du" and "df" commands - it just hangs.
>
> Known problem? Does it help if I send debug info? If so, please
> instruct.
>
Does btrfs check report anything wrong?

Thanks,
Qu


