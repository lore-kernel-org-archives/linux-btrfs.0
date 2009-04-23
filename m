From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [REVIEW] Btrfs: Introduce ioctl for compressed size of file
Date: Thu, 23 Apr 2009 15:20:06 -0400
Message-ID: <1240514406.28015.18.camel@think.oraclecorp.com>
References: <e6ac15e50904052332h2ca9b0e3ube8ceb89ca25d0f1@mail.gmail.com>
	 <1239074313.17426.1.camel@think.oraclecorp.com>
	 <m37i1h47qc.fsf_-_@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: mp3geek <mp3geek@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m37i1h47qc.fsf_-_@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-04-18 at 23:56 -0400, Chris Ball wrote:
> Hi,
> 
>    > We need to add an ioctl that reports on the actual size of the
>    > compressed file.
> 
> Here's an attempt at that ioctl, please review.  The search code is
> based on the clone ioctl.  Some specific questions:
> 

Thanks for doing this.

> * Is the first while() loop necessary?

Not really, you could just do:

btrfs_wait_ordered_range(inode, 0, (u64)-1);

> * Are the semantics of returning -EINVAL when called on an FS with
>   compression disabled desirable?
> 

Instead of calling it the compressed size, I'd call it the size used on
disk.  For a compressed file, this will be smaller than the size in ram,
otherwise it'll be the same.

But, the ioctl is returning an unsigned long, which isn't quite big
enough to hold the total possible size of the file on disk.  I'd have it
return the answer in a u64 instead.

-chris


