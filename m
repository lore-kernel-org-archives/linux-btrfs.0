Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:50383 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757689Ab2GFPhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 11:37:04 -0400
Date: Fri, 6 Jul 2012 11:37:01 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: Zach Brown <zab@zabbo.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] Btrfs: use radix tree for checksum
Message-ID: <20120706153701.GP7159@shiny>
References: <1339582751-32029-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1339582751-32029-2-git-send-email-liubo2009@cn.fujitsu.com>
 <4FD8BAC9.2020108@zabbo.net>
 <4FD9437C.3070009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FD9437C.3070009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 07:50:52PM -0600, Liu Bo wrote:
> On 06/14/2012 12:07 AM, Zach Brown wrote:
> 
> > 
> >>   int set_state_private(struct extent_io_tree *tree, u64 start, u64
> >> private)
> >>   {
> > [...]
> >> +    ret = radix_tree_insert(&tree->csum, (unsigned long)start,
> >> +                   (void *)((unsigned long)private<<  1));
> > 
> > Will this fail for 64bit files on 32bit hosts?
> 
> 
> In theory it will fail, but crc32c return u32, so private will be originally u32,
> and it'd be ok on 32bit hosts.

The (unsigned long)start part looks wrong though.  This is the byte offset
from 0, so on a 32 bit machine you won't be able to have large files.

The page cache also has this limitation, but it gains extra bits
counting page indexes instead of byte indexes.

I've made that change here and I'm benchmarking it on my big flash ;)

-chris
