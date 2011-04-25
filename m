From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v2 0/7] Btrfs: New inode number allocator
Date: Mon, 25 Apr 2011 17:02:21 +0800
Message-ID: <4DB5389D.6040006@cn.fujitsu.com>
References: <4DB5378B.2070904@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB5378B.2070904@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote:
> Currently btrfs stores the highest objectid of the fs tree, and it always
> returns (highest+1) inode number when we create a file, so inode numbers
> won't be reclaimed when we delete files, so we'll run out of inode numbers
> as we keep create/delete files in 32bits machines.
> 
> This patchset aims to fix this, and it works similar to free space caching
> for block groups.
> 
> I've run xfstests, and I also tested it with snapshot, balance etc.
> 
> More testing is appreciated!
> 
> Changelog v2:
> 
> - Rebased against latest btrfs-unstable tree
> - Fixed several small bugs.
> 

This patchset is also available here:

	git://repo.or.cz/linux-btrfs-devel.git ino-alloc
