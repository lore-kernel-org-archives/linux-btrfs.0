Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbdCAN2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 08:28:49 -0500
Date: Wed, 1 Mar 2017 14:26:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs cleanups for 4.11, part 2
Message-ID: <20170301132657.GC4662@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1488289094.git.dsterba@suse.com>
 <32c50d9d-7b59-718b-7e95-43bef27b9b91@fb.com>
 <319756cf-e9f8-d904-dbf1-6b6fdceca291@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <319756cf-e9f8-d904-dbf1-6b6fdceca291@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 01, 2017 at 09:36:38AM +0200, Nikolay Borisov wrote:
> Kbuild reported the following warning: 
> 
>  fs/btrfs/scrub.c: In function 'check_extent_to_block':
> >> fs/btrfs/scrub.c:4259:24: error: passing argument 1 of 'btrfs_get_extent' from incompatible pointer type [-Werror=incompatible-pointer-types]
>      em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
>                            ^~~~~
>    In file included from fs/btrfs/scrub.c:21:0:
>    fs/btrfs/ctree.h:3169:20: note: expected 'struct inode *' but argument is of type 'struct btrfs_inode *'
>     struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
>                        ^~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/btrfs_get_extent +4259 fs/btrfs/scrub.c
> 
> 32159242 Gui Hecheng 2014-11-10  4253  	if (ordered) {
> 32159242 Gui Hecheng 2014-11-10  4254  		btrfs_put_ordered_extent(ordered);
> 32159242 Gui Hecheng 2014-11-10  4255  		ret = 1;
> 32159242 Gui Hecheng 2014-11-10  4256  		goto out_unlock;
> 32159242 Gui Hecheng 2014-11-10  4257  	}
> 32159242 Gui Hecheng 2014-11-10  4258  
> 32159242 Gui Hecheng 2014-11-10 @4259  	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
> 32159242 Gui Hecheng 2014-11-10  4260  	if (IS_ERR(em)) {
> 32159242 Gui Hecheng 2014-11-10  4261  		ret = PTR_ERR(em);
> 32159242 Gui Hecheng 2014-11-10  4262  		goto out_unlock;
> 
> I guess changing the definition of btrfs_get_extent in ctree.h got missed to 
> being converted to struct btrfs_inode. Could you be able to fix it up?

Seems the problem got fixed by some following patch. The exact commit
1c8c9c5216295711c79 fails to build but the whole branch is ok. As it's a
minor annoyance I'd rather skip redoing the pull request.
