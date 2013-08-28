Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40319 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3H1FCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 01:02:13 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 664A53EE0BD
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 14:02:11 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 5061045DEB7
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 14:02:11 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3154945DEBA
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 14:02:11 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 170161DB8040
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 14:02:11 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id A84701DB803F
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 14:02:10 +0900 (JST)
Message-ID: <521D842D.6020100@jp.fujitsu.com>
Date: Wed, 28 Aug 2013 14:01:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 0/2] btrfs-progs: prevent mkfs from aborting with small
 volume
References: <52170114.7060604@jp.fujitsu.com> <521B64EA.2080106@redhat.com>
In-Reply-To: <521B64EA.2080106@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2013/08/26 23:23), Eric Sandeen wrote:
> Thanks for looking into this - how small of a device did you test?
> 
> I tried a 2MB device w/ these 2 patches and still got:
> 
> [btrfs-progs]# truncate --size=2m testfile
> [btrfs-progs]# ./mkfs.btrfs testfile
> 
> WARNING! - Btrfs v0.20-rc1-360-geeeb4e9 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
> 
> SMALL VOLUME: forcing mixed metadata/data groups
> mkfs.btrfs: volumes.c:857: btrfs_alloc_chunk: Assertion `!(ret)' failed.
> Aborted (core dumped)
> 
> which was at:
> 
>                 ret = btrfs_alloc_dev_extent(trans, device,
>                              info->chunk_root->root_key.objectid,
>                              BTRFS_FIRST_CHUNK_TREE_OBJECTID, key.offset,
>                              calc_size, &dev_offset);
>                 BUG_ON(ret);
> 
> :(

Wow...
It seems that this abort is different problem from the bug which
my patches are going to fix.  I'll try to make new patch to fix this
problem.

> 
> Also, I'm curious - I know the code existed before your patch 2/2,
> but I don't understand why it reserves 1MB for the first superblock 
> when the first superblock is actually at 64k.  Any idea?
> 
> -Eric

I'm not sure... According to the git-log, this 1M trick is in 
the following old commit by Chris:

  commit a6de0bd778475504f42a142c83b8077993cbddfe
  Author: Chris Mason <chris.mason@oracle.com>
  Date:   Thu Apr 3 16:35:48 2008 -0400

     Add mirroring support across multiple drives


Thanks,
H.Seto

