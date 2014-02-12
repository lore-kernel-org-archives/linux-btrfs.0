Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30176 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbaBLCRd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 21:17:33 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1C2HThM014761
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2014 10:17:29 +0800
Message-ID: <52FAD9F2.6090001@cn.fujitsu.com>
Date: Wed, 12 Feb 2014 10:18:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] make 'btrfs fi show /mnt/point/' works with ending
 '/' character
References: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1392017310-19951-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore this patchset since adding a new option to find_mount_root
is not the best method to
solve the problem.

I'll send a better version patch to fix it.

Thanks
Qu

On mon, 10 Feb 2014 15:28:27 +0800, Qu Wenruo wrote:
> Before this patchset, 'btrfs fi show' can work with '/mnt/point' but not '/mnt/point/',
> which is very annoying since tab completion will add '/' to a directory.
>
> This patchset just reuse the find_mount_root function with some small modification to
> ignore the last '/' only when needed.
>
> Qu Wenruo (3):
>   btrfs-progs: move find_mount_root to utils.[ch]
>   btrfs-progs: Add path_is_mp option for find_mount_root.
>   btrfs-progs: reuse find_mount_root to determine arg type and so on.
>
>  cmds-filesystem.c |  7 +++++
>  cmds-receive.c    |  2 +-
>  cmds-send.c       | 53 ++-------------------------------
>  cmds-subvolume.c  |  2 +-
>  commands.h        |  1 -
>  utils.c           | 88 +++++++++++++++++++++++++++++++++++++++++++++----------
>  utils.h           |  1 +
>  7 files changed, 86 insertions(+), 68 deletions(-)
>

