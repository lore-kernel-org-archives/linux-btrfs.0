From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Thu, 7 Jul 2011 09:09:41 +0100
Message-ID: <chaz20110707080941.GA23450@seebyte.com>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110706081111.GA6931@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-06 09:11:11 +0100, Stephane Chazelas:
[...]
>     extent_map delayed_node btrfs_inode_cache btrfs_free_space_cache
> (in bytes)
[...]
> 01:00  267192640  668595744 2321646000    3418048
> 01:10  267192640  668595744 2321646000    3418048
> 01:20  267192640  668595744 2321646000    3418048
> 01:30  267192640  668595744 2321646000    3418048
> 01:40  267192640  668595744 2321646000    3418048
[...]

I've just come accross
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=4b9465cb9e3859186eefa1ca3b990a5849386320

GIT> author	Chris Mason <chris.mason@oracle.com>	
GIT> 	Fri, 3 Jun 2011 13:36:29 +0000 (09:36 -0400)
GIT> committer	Chris Mason <chris.mason@oracle.com>	
GIT> 	Sat, 4 Jun 2011 12:03:47 +0000 (08:03 -0400)
GIT> commit	4b9465cb9e3859186eefa1ca3b990a5849386320
GIT> tree	8fc06452fb75e52f6c1c2e2253c2ff6700e622fd	tree | snapshot
GIT> parent	e7786c3ae517b2c433edc91714e86be770e9f1ce	commit | diff
GIT> Btrfs: add mount -o inode_cache
GIT> 
GIT> This makes the inode map cache default to off until we
GIT> fix the overflow problem when the free space crcs don't fit
GIT> inside a single page.

I would have thought that would have disabled that
btrfs_inode_cache. And I can see that patch is in 3.0.0-rc5 (I'm
not mounting with -o inode_cache). So, why those 2.2GiB in
btrfs_inode_cache above?

-- 
Stephane
