Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34767 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2GRMjP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 08:39:15 -0400
Received: by obbuo13 with SMTP id uo13so2080641obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jul 2012 05:39:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5006A5E8.4050907@cn.fujitsu.com>
References: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com>
	<CAHf9xvZmDPTqSHK3b2WLH1jhkQo4RqpMqPpX7i1wzh2CHuDZWg@mail.gmail.com>
	<5006A5E8.4050907@cn.fujitsu.com>
Date: Wed, 18 Jul 2012 15:39:14 +0300
Message-ID: <CAHf9xvYb8TAw3VMccRZzWuDF2N+arWvNuAXkApSxRmuRMUNexQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Btrfs: fix btrfs_is_free_space_inode to recognize
 btree inode
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2012 at 3:02 PM, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 07/18/2012 06:02 PM, Alex Lyakas wrote:
>
> More or less.
>
> As its name shows, a free space inode's data (you name it extents) consists of
> free space info, meanwhile, a free space inode is issued to a block group,
> so the free space info actually stands for free space in the block group:
>
> |<-    a block group len    ->|
> |----vvv----vvv-------vvv-----|
>
> 'v' : occupied.
> '-' : available. (free space)
>
> these free space info are indexed in a rbtree in memory, and each entry has [start, len].

Thanks, it makes sense with what I saw in the code, just could not
figure how this free-space inode's data is being read into memory.

>
>> Also, I don't see anywhere BTRFS_BTREE_INODE_OBJECTID in the tree root
>> tree. So what is this "btree inode" that you mention?
>>
>
>
> The code refers to disk_io.c, in the function 'open_ctree()' you can see the definition.
>

I saw it there, but not on disk. So now I see that it's kind of a
special "top" inode, used for ... something, and this inode is not
stored anywhere on-disk.

Thanks, now I understand your patch. Also, I understand now that
FREE_INO items sit in the subvolume file tree (and perhaps also in the
root tree), because they need to track free inos for distinct ino
spaces.

> Basically btree inode's data stands for btrfs's metadata, I think you can find something
> in btrfs's wiki page?

>
>
> And thanks for your energy on btrfs! :)

Thanks for helping.

Alex.
