Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:61880 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768293Ab2KOQFu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 11:05:50 -0500
Message-ID: <50A512D5.6070706@jan-o-sch.net>
Date: Thu, 15 Nov 2012 17:05:41 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: Cannot list subvolumes with latest git
References: <CALJXSJosaiU+pGHaUhh9OokdgOpPgDf385x2Q9BH7qhVKnZowg@mail.gmail.com>
In-Reply-To: <CALJXSJosaiU+pGHaUhh9OokdgOpPgDf385x2Q9BH7qhVKnZowg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, November 14, 2012 at 19:26 (+0100), Jérôme Poulin wrote:
> Using Debian experimental kernel, 3.6.4-1~experimental.1, and latest
> btrfs tools from git master, I am not able to execute btrfs subvolume
> list.
> 
> # ./btrfs sub li /mnt/data0/
> ERROR: Failed to lookup path for root 0 - No such file or directory
> 
> After bisecting with git, I was able to confirm that commit
> 162df1e30c7c0492ae9fb551d74452e643f5fea2 breaks btrfs subvolume list
> on my current kernel.

I can confirm this. Steps to reproduce:

- create subvolume
- put some data in
- delete subvolume
- call "btrfs subvol list" immediately

If you give it some time, listing of subvolumes eventually works. Calling "sync"
doesn't help, surprisingly, while umount/mount does.

Some add_root get's called with ref_tree = 0, which in turn makes
lookup_ino_path call BTRFS_IOC_INO_LOOKUP with a treeid of 0, which looks wrong
to me. I haven't looked any closer.

Miao, as that was your patch, can you probably check if you can reproduce the
problem?

Thanks,
-Jan
