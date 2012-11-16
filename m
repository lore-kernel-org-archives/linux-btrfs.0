Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8654 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2KPBeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 20:34:25 -0500
Message-ID: <50A59832.1020306@cn.fujitsu.com>
Date: Fri, 16 Nov 2012 09:34:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Cannot list subvolumes with latest git
References: <CALJXSJosaiU+pGHaUhh9OokdgOpPgDf385x2Q9BH7qhVKnZowg@mail.gmail.com> <50A512D5.6070706@jan-o-sch.net>
In-Reply-To: <50A512D5.6070706@jan-o-sch.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 15 Nov 2012 17:05:41 +0100, Jan Schmidt wrote:
> On Wed, November 14, 2012 at 19:26 (+0100), Jérôme Poulin wrote:
>> Using Debian experimental kernel, 3.6.4-1~experimental.1, and latest
>> btrfs tools from git master, I am not able to execute btrfs subvolume
>> list.
>>
>> # ./btrfs sub li /mnt/data0/
>> ERROR: Failed to lookup path for root 0 - No such file or directory
>>
>> After bisecting with git, I was able to confirm that commit
>> 162df1e30c7c0492ae9fb551d74452e643f5fea2 breaks btrfs subvolume list
>> on my current kernel.
> 
> I can confirm this. Steps to reproduce:
> 
> - create subvolume
> - put some data in
> - delete subvolume
> - call "btrfs subvol list" immediately
> 
> If you give it some time, listing of subvolumes eventually works. Calling "sync"
> doesn't help, surprisingly, while umount/mount does.

When we delete a subvolume, we just delete its ref and backref, don't delete the tree
at once, it will be done by the cleaner thread, which is woke up after the transaction
thread commits a transaction, that is the deletion of the tree may not be done in the
current transaction. It is the reason why "sync" doesn't help.

> Some add_root get's called with ref_tree = 0, which in turn makes
> lookup_ino_path call BTRFS_IOC_INO_LOOKUP with a treeid of 0, which looks wrong
> to me. I haven't looked any closer.

Right.

> Miao, as that was your patch, can you probably check if you can reproduce the
> problem?

This problem was fixed by the following patch several days ago, but the patch have not
been applied into Chris's btrfs-progs tree.

  Btrfs-progs: filter the deleted subvolumes when listing snapshots

You can pull it from the URL:

  git://github.com/miaoxie/btrfs-progs.git master

Thanks
Miao
