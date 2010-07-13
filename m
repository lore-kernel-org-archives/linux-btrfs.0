From: Chris Mason <chris.mason@oracle.com>
Subject: Re: slow deletion of files
Date: Mon, 12 Jul 2010 21:12:46 -0400
Message-ID: <20100713011246.GM563@think>
References: <i1cm80$901$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i1cm80$901$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 11, 2010 at 02:59:12PM +0000, Lubos Kolouch wrote:
> Hello,
> 
> during my testing of btrfs I found out, 
> that deletion of directory with many files (many millions) takes veeeery 
> long (it is running two weeks now and did not finish).
> 
> But when instead of directory I create subvolume, it is deleted instantly.
> 
> Is it normal behaviour? (gentoo 2.6.34-r1, btrfs-progs-9999).
> Why the directory cannot be deleted instantly as well?

The subvolume deletion is able to walk much less metadata, and it is
able to walk it in a more efficient order than a file by file deletion.
Time to delete individual files depends mostly on metadata fragmentation
and is mostly limited by reading in the file extent pointers and crcs.

The bulk of this work can be pushed into the background, it is
definitely on my todo list.

-chris
