Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57073 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbaKZDGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 22:06:23 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so1907955pab.20
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 19:06:23 -0800 (PST)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH 3/3] Btrfs-progs, fsck: move root items repair after root rebuilding
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1416970736-26623-8-git-send-email-wangshilong1991@gmail.com>
Date: Wed, 26 Nov 2014 11:06:14 +0800
Cc: dsterba@suse.cz
Message-Id: <2DF70D89-E2DA-4017-A469-0A670DAEBD8A@gmail.com>
References: <1416970736-26623-1-git-send-email-wangshilong1991@gmail.com> <1416970736-26623-8-git-send-email-wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oops, sorry for sending this twice, just entered one more *.patch¡­


> 
> I did send these patches a long while ago, but due to some reasons,
> they were not merged, these are important fixes for fsck, without
> these patches, extent tree rebuilding did not work with snapshots.
> 
> Also, /tests/fsck-tests.sh's extent tree rebuild test could always
> detect failure without these patches, unluckily, it need extra
> enviroment setting, so i supposed it was always 'NOTRUN'!
> 
> last patch fix a regression for root rebuilding, root rebuilding
> should be at first, because if root(extent root eg) corrupted,
> root items also won't succeed.
> 
> patches are based on David's integration-20141125
> 
> Wang Shilong (3):
>  Btrfs-progs: fsck: deal with snapshot one by one when rebuilding
>    extent tree
>  Btrfs-progs: fsck: add ability to rebuild extent tree with snapshots
>  Btrfs-progs, fsck: move root items repair after root rebuilding
> 
> cmds-check.c | 412 +++++++++++++++++++++++++++++++++++++++++++----------------
> 1 file changed, 303 insertions(+), 109 deletions(-)
> 
> -- 
> 2.1.0
> 

Best Regards,
Wang Shilong

