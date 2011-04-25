From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v2 0/7] Btrfs: New inode number allocator
Date: Mon, 25 Apr 2011 16:44:20 -0400
Message-ID: <1303764241-sup-9810@think>
References: <4DB5378B.2070904@cn.fujitsu.com> <1303751742-sup-4551@think>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1303751742-sup-4551@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-04-25 13:15:58 -0400:
> Excerpts from Li Zefan's message of 2011-04-25 04:57:47 -0400:
> > Currently btrfs stores the highest objectid of the fs tree, and it always
> > returns (highest+1) inode number when we create a file, so inode numbers
> > won't be reclaimed when we delete files, so we'll run out of inode numbers
> > as we keep create/delete files in 32bits machines.
> > 
> > This patchset aims to fix this, and it works similar to free space caching
> > for block groups.
> > 
> > I've run xfstests, and I also tested it with snapshot, balance etc.
> > 
> > More testing is appreciated!
> > 
> > Changelog v2:
> > 
> > - Rebased against latest btrfs-unstable tree
> > - Fixed several small bugs.
> 
> Great, is this pullable from somewhere?

Sorry, you did send the link in a later email.  This is the first thing
in my .40 tree.

-chris
