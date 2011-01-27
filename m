From: Chris Mason <chris.mason@oracle.com>
Subject: Re: version
Date: Thu, 27 Jan 2011 02:45:11 -0500
Message-ID: <1296114256-sup-4788@think>
References: <BeXoKKFD1uB@helmut.hullen.de>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Chris Samuel" <chris@csamuel.org>
To: Helmut Hullen <hullen@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <BeXoKKFD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Helmut Hullen's message of 2011-01-25 09:37:00 -0500:
> crashes with the "dmesg" lines
> 
> --------------------- dmesg -------------------
> 
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> bio too big device sdc (256 > 240)
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/volumes.c:2097!

Ugh, this one is an old friend I thought I had fixed up.  The two
devices have different limits on the max size of the bio, and we're
using one that is too large.

I'll get it fixed for the next rc.

-chris
