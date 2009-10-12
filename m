From: Chris Mason <chris.mason@oracle.com>
Subject: Re: soft lockup when leaf and node bigger than 4KB
Date: Mon, 12 Oct 2009 08:50:35 -0400
Message-ID: <20091012125035.GM2632@think>
References: <4486336c0910120255p6388cc5dl3bf7154a418d068e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Zhang Jingwang <yyalone@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4486336c0910120255p6388cc5dl3bf7154a418d068e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2009 at 05:55:47PM +0800, Zhang Jingwang wrote:
> I make a btrfs use 'mkfs.btrfs -m single -l 16384 -n 16384 /dev/xxx'.
> After mount it, I run a test script to create lots of files, then soft
> lockup occurs.
> 
> After digging into the source code, I think there is a problem with
> bio->bi_end_io.

Unfortunately, the larger sizes are not supported right now at all, as
there are a number of problems to handle.

In my queue of btrfs-progs updates, I have it limited to the page size
for all of these options.

-chris
