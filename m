Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:44682 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbaLCFJv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 00:09:51 -0500
From: Ed Tomlinson <edt@aei.ca>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
Date: Wed, 03 Dec 2014 00:03:08 -0500
Message-ID: <2026580.dXZxrES2AW@grover>
In-Reply-To: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'd really like to see these patches included in btrfsck - they repaired my fs.   Once
Qu got them working they found additional corruptions.  This time there was no crash or stall
just an umount that left (chromium) files unlinked...  The bug with these files has been
hitting me for a while - just did not recognize what was causing it or notice the corruption.

The only objection I have seen to these patches is that they may create a "lost+found" 
directory.  I submit this is an expected behavior for a fsck utility.  When --repair is specified 
I expect a fsck to make changes to my fs one of which may be adding and populating a 
lost+found directory.

Thanks
Ed Tomlinson

PS. It would be very interesting to find out WHY these files are ending up unlinked.  Ideas?


On Wednesday 03 December 2014 12:18:26 you wrote:
> Update on patch 4 and 6, other is not changed.
> This nlink repair function is more generic than the original one.
> 
> The old one can only handle a specific case that the inode_ref is
> invalid, either point to a non-exist parent inode or point to a invalid
> inode(not dir or conflicting index/name).
> 
> The new one will reset all the backref, no matter it is valid or not,
> and re-add all the valid backref, this make the nlink handles more
> corrupt cases.
> 
> Qu Wenruo (6):
>   btrfs-progs: print root dir verbose error in fsck
>   btrfs-progs: Import btrfs_insert/del/lookup_extref() functions.
>   btrfs-progs: Import lookup/del_inode_ref() function.
>   btrfs-progs: Add btrfs_unlink() and btrfs_add_link() functions.
>   btrfs-progs: Add btrfs_mkdir() function for the incoming 'lost+found' 
>        fsck mechanism.
>   btrfs-progs: Add fixing function for inodes whose nlink dismatch
> 
>  Makefile     |   2 +-
>  cmds-check.c | 311 ++++++++++++++++++++++++++++++++++++--
>  ctree.c      |   6 +
>  ctree.h      |  38 +++++
>  inode-item.c | 318 +++++++++++++++++++++++++++++++++++++++
>  inode.c      | 484 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1148 insertions(+), 11 deletions(-)
>  create mode 100644 inode.c
> 
> 

