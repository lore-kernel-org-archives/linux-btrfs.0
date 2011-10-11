From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: defrag makes fragmentation worse
Date: Tue, 11 Oct 2011 14:19:44 +0800
Message-ID: <4E93E000.1000700@cn.fujitsu.com>
References: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chester wrote:
> Kernel 3.1-rc8
> btrfs-progs-0.19
> mount options: noatime,autodefrag (space_cache is enabled)
> There are snapshots present on the filesystem.
> 
> When I do a btrfs fi defrag on a file, the file becomes much more
> fragmented. The end result can be a file with 20k times more fragments
> than before. Initially I thought the extents were just smaller but
> were next to each other, so I checked with both 'filefrag' as well as
> 'filefrag -v'. Both reported the same number. I don't know if this has
> anything to do with having snapshots at all because files that haven't
> been snapshotted yet are affected by this. Disk space isn't an issue
> since my 1TB disk isn't even halfway filled, and moving the file
> around actually gives me fairly contiguous files.

Was any process doing heavy I/O work while you were defragging the file?

Could you try to remount the fs without autodefrag, and defrag
the file again? Firstly let's see if autodefrag makes things worse.
