From: Chester <somethingsome2000@gmail.com>
Subject: Re: defrag makes fragmentation worse
Date: Tue, 11 Oct 2011 15:47:31 -0500
Message-ID: <CAAE6i0h6QZGmLoFUPgouHTeC0FYvHPgbODXHEthaL5p4mLruVQ@mail.gmail.com>
References: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com>
 <4E93E000.1000700@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E93E000.1000700@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2011 at 1:19 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Was any process doing heavy I/O work while you were defragging the file?
>
> Could you try to remount the fs without autodefrag, and defrag
> the file again? Firstly let's see if autodefrag makes things worse.
>

As far as I can tell, autodefrag seems to be making it worse.

I turned off autodefrag but btrfs fi defrag is still having some
trouble defragmenting highly fragmented files. For example, when I
defragment a ~400mb file with 3 extents, it does a nice job and turns
it into 1 extent.

However, for more fragmented files (of the same size) say with 1k-2k
extents, the defrag utility has a hard time. It either reduces the
number of extents by a very small amount or it doesn't change at all.
I decided to run btrfs fi defrag on the same file again just to make
sure nothing else can be done, but after running it again, the number
of extents in that file actually DOUBLED! But this isn't as bad as
when autodefrag is on, where extents can increase by 20x

tl;dr: with autodefrag off, btrfs fi defrag isn't nearly as
counter-productive as it is with autodefrag on.
