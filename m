Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab3HZOXm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 10:23:42 -0400
Message-ID: <521B64EA.2080106@redhat.com>
Date: Mon, 26 Aug 2013 09:23:38 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 0/2] btrfs-progs: prevent mkfs from aborting with small
 volume
References: <52170114.7060604@jp.fujitsu.com>
In-Reply-To: <52170114.7060604@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/23/13 1:28 AM, Hidetoshi Seto wrote:
> I found that mkfs.btrfs aborts when one of assigned volume is too small.
> Here are 2 patches to fix 2 independent problems.
> Both are based on top of Chris's btrfs-progs.git:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> Thanks,
> H.Seto
> 

Thanks for looking into this - how small of a device did you test?

I tried a 2MB device w/ these 2 patches and still got:

[btrfs-progs]# truncate --size=2m testfile
[btrfs-progs]# ./mkfs.btrfs testfile

WARNING! - Btrfs v0.20-rc1-360-geeeb4e9 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

SMALL VOLUME: forcing mixed metadata/data groups
mkfs.btrfs: volumes.c:857: btrfs_alloc_chunk: Assertion `!(ret)' failed.
Aborted (core dumped)

which was at:

                ret = btrfs_alloc_dev_extent(trans, device,
                             info->chunk_root->root_key.objectid,
                             BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
                             calc_size, &dev_offset);
                BUG_ON(ret);

:(

Also, I'm curious - I know the code existed before your patch 2/2,
but I don't understand why it reserves 1MB for the first superblock 
when the first superblock is actually at 64k.  Any idea?

-Eric


> Hidetoshi Seto (2):
>       btrfs-progs: treat reserved 1MB for superblock properly
>       btrfs-progs: exit if there is not enough free space for mkfs
> 
>  ctree.h   |    3 +++
>  mkfs.c    |    4 ++++
>  volumes.c |    7 ++++++-
>  3 files changed, 13 insertions(+), 1 deletions(-)
> 

