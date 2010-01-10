From: Chris Mason <chris.mason@oracle.com>
Subject: Re: snapshot/subvolume removal
Date: Sun, 10 Jan 2010 15:18:12 -0500
Message-ID: <20100110201812.GB32195@think>
References: <4B43AC9B.5030109@cs.bgu.ac.il>
 <4B43D9AB.1090606@jp.fujitsu.com>
 <4B444AD5.1060501@cs.bgu.ac.il>
 <4B46ECBA.2030402@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: piavka@cs.bgu.ac.il, linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B46ECBA.2030402@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 08, 2010 at 05:28:42PM +0900, TARUISI Hiroaki wrote:
> For now, subvolumes and snapshots look like just directories.
> If you want to distinguish them, there's only an unusual way,
> that is, analyzing with btrfs-debug-tree.
> 
> I posted patches for listing snapshots/subvolumes two months ago,
> and Josef Bacik posted its bugfix patch. This feature may be
> delivered in sooner or later.
> If you want to try it now, check these URLs.
>   http://patchwork.kernel.org/patch/60923/raw/
>   http://patchwork.kernel.org/patch/60920/raw/
>   http://patchwork.kernel.org/patch/67332/raw/
> Patches and requests are welcome.

Thanks again for the subvolume listing patch, it's going to be a great
feature.

I'm afraid I've had to make some small changes.  ioctls have
some very strict rules for the arguments, and pointers and list heads
should not be passed in ioctl structs.

We also need to change the patch to make the ioct args struct the same
size on both 32 bit and 64 bit machines, which usually just means
aligning and padding the fields as required.

I have started on this and hope to finish it on Tuesday.  But if you
have any additions to the patch please let me know.

-chris
