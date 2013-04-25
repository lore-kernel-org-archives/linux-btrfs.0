Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:5264 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab3DYCA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 22:00:27 -0400
Message-ID: <51788EF1.4060401@cn.fujitsu.com>
Date: Thu, 25 Apr 2013 10:03:29 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: russell@coker.com.au
CC: linux-btrfs@vger.kernel.org
Subject: Re: Failed to lookup path for root 0
References: <201304251028.13714.russell@coker.com.au>
In-Reply-To: <201304251028.13714.russell@coker.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
This problem has been fixed.Would you please try the latest btrfs-progs,
and see it this problem happens again.

Btrfs-progs commitid: 64edc851da59c47b92ee6830101be0854add7f09 fix this problem.
The latest btrfs-progs url:
http://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git

Thanks,
Wang

> # btrfs subvol list /home
> ERROR: Failed to lookup path for root 0 - No such file or directory
> # btrfs subvol list /home
> ID 269 gen 449406 top level 5 path backup
> ...
> 
> I'm getting errors from the "btrfs subvol list" command as above, I'm running 
> the Debian 3.8.3 kernel.  The errors occur after deleting a snapshot, so if I 
> delete a snapshot and then immediately do a list of snapshots then the error 
> is likely to occur.  It's repeatable in my cron jobs to remove old backups, 
> they do a snapshot list, delete the hourly backups, then do another list to 
> find daily snapshots to delete which fails.
> 



