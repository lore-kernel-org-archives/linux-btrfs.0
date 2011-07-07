From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Memory leak?
Date: Thu, 07 Jul 2011 16:20:20 +0800
Message-ID: <4E156C44.8080007@cn.fujitsu.com>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <chaz20110707080941.GA23450@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110707080941.GA23450@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Stephane Chazelas wrote:
> 2011-07-06 09:11:11 +0100, Stephane Chazelas:
> [...]
>>     extent_map delayed_node btrfs_inode_cache btrfs_free_space_cache
>> (in bytes)
> [...]
>> 01:00  267192640  668595744 2321646000    3418048
>> 01:10  267192640  668595744 2321646000    3418048
>> 01:20  267192640  668595744 2321646000    3418048
>> 01:30  267192640  668595744 2321646000    3418048
>> 01:40  267192640  668595744 2321646000    3418048
> [...]
> 
> I've just come accross
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=4b9465cb9e3859186eefa1ca3b990a5849386320
> 
> GIT> author	Chris Mason <chris.mason@oracle.com>	
> GIT> 	Fri, 3 Jun 2011 13:36:29 +0000 (09:36 -0400)
> GIT> committer	Chris Mason <chris.mason@oracle.com>	
> GIT> 	Sat, 4 Jun 2011 12:03:47 +0000 (08:03 -0400)
> GIT> commit	4b9465cb9e3859186eefa1ca3b990a5849386320
> GIT> tree	8fc06452fb75e52f6c1c2e2253c2ff6700e622fd	tree | snapshot
> GIT> parent	e7786c3ae517b2c433edc91714e86be770e9f1ce	commit | diff
> GIT> Btrfs: add mount -o inode_cache
> GIT> 
> GIT> This makes the inode map cache default to off until we
> GIT> fix the overflow problem when the free space crcs don't fit
> GIT> inside a single page.
> 
> I would have thought that would have disabled that
> btrfs_inode_cache. And I can see that patch is in 3.0.0-rc5 (I'm
> not mounting with -o inode_cache). So, why those 2.2GiB in
> btrfs_inode_cache above?
> 

This should be irrelevant to your problem..

btrfs_inode_cache is a slab cache for in memory inodes, which is of
struct btrfs_inode.

while the ino_cache is a cache in which the entries are ranges of free
inode numbers, and currently it won't be enabled unless you mount with
inode_cache option.
