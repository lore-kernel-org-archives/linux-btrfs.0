From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Thu, 7 Jul 2011 09:37:12 +0100
Message-ID: <chaz20110707083712.GB23450@seebyte.com>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <chaz20110707080941.GA23450@seebyte.com> <4E156C44.8080007@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E156C44.8080007@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-07 16:20:20 +0800, Li Zefan:
[...]
> btrfs_inode_cache is a slab cache for in memory inodes, which is of
> struct btrfs_inode.
[...]

Thanks Li.

If that's a cache, the system should be able to reuse the space
there when it's low on memory, wouldn't it? What would be the
conditions where that couldn't be done? (like in my case, where
the oom killer was hired to free memory rather than reclaiming
that cache memory).

Best regards,
Stephane
