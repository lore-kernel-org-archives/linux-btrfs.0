From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH V6 3/3] btrfs: delay to insert the initial inode
Date: Mon, 25 Apr 2011 16:50:43 -0400
Message-ID: <1303764553-sup-8007@think>
References: <4DB15488.50005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DB15488.50005@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Miao Xie's message of 2011-04-22 06:12:24 -0400:
> Since we have implemented the delayed update of the inode, we can also
> delayed to insert the initial inode, then we can merge the inode update
> and the initial inode insertions to one insertion.

Awesome.  With things separate from the inode this should solve our oom
problems.  We might need to register a shrinker for the delayed inode
operations too, but that shouldn't be a problem.

-chris
