From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] Btrfs: fix defragmentation regression
Date: Fri, 2 Sep 2011 04:42:08 -0400
Message-ID: <20110902084208.GA28209@infradead.org>
References: <4E608C29.10307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E608C29.10307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 02, 2011 at 03:56:25PM +0800, Li Zefan wrote:
> There's an off-by-one bug:
> 
>   # create a file with lots of 4K file extents
>   # btrfs fi defrag /mnt/file
>   # sync
>   # filefrag -v /mnt/file
>   Filesystem type is: 9123683e
>   File size of /mnt/file is 1228800 (300 blocks, blocksize 4096)
>    ext logical physical expected length flags
>      0       0     3372              64
>      1      64     3136     3435      1
>      2      65     3436     3136     64
>      3     129     3201     3499      1
>      4     130     3500     3201     64
>      5     194     3266     3563      1
>      6     195     3564     3266     64
>      7     259     3331     3627      1
>      8     260     3628     3331     40 eof
> 
> After this patch:

Can you please create an xfstests testcase for this?

