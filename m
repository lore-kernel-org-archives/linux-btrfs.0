From: Chris Mason <chris.mason@oracle.com>
Subject: Re: mini bug report
Date: Mon, 20 Dec 2010 11:12:09 -0500
Message-ID: <1292861507-sup-724@think>
References: <20101220155801.GF24127@jeru.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Xavier Nicollet <nicollet@jeru.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20101220155801.GF24127@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Xavier Nicollet's message of 2010-12-20 10:58:01 -0500:
> Hi,
> 
> I use btrfs on my laptop, 2.6.37-rc2 from kernel.org, under dm-crypt, as
> /. I use space_cache and compression (not forced).
> 
> Today, my computer froze. At reboot, the kernel could not mount.
> The dmesg output, which I haven't saved was speaking of a null
> dereference.
> 
> After that I rebooted on 2.6.34, which was not very happy: mount errors
> (space cache ?).
> 
> Now I am on 2.6.37-rc2 again, which seems to work.
> So I guess it might come from space_cache.
> 
> I would note on a paper if this comes back. However if anybody has any
> clue on what specific part of the dmesg should be reported, it would be
> very helpfull !

These sound like the free space caching bugs that josef fixed.  If you
pull down the latest I think we've got it nailed.

-chris
