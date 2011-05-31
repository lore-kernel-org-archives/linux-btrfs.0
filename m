From: Chris Mason <chris.mason@oracle.com>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:5695 btrfs_alloc_free_block+0x22c/0x370 [btrfs]()
Date: Tue, 31 May 2011 04:18:33 -0400
Message-ID: <1306829753-sup-916@shiny>
References: <4DE4A30A.9010207@gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Sascha Biermanns <saschakb@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DE4A30A.9010207@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Sascha Biermanns's message of 2011-05-31 04:12:58 -0400:
> Yesterday, I compiled the new kernel 3.0rc1 from git, but I never
> successed to go over the point: "Removing old temporary files".
> Pressing control-c let me boot on, but the pc was the complete time on
> very high load. It took me minutes, just to reach the tty login - and
> again minutes after login in, that I had my shell and a prompt to enter
> something. The load was at that time beyond 10.
> 
> Now in my /var/log/messages, I found the following warning - and because
> it happens when "removing" temporary/old files, that might be why the
> computer has so much trouble:
> 

> May 30 23:25:17 localhost kernel: [17117.213589] Call Trace:

Do you have the very first full oops?  This has the call trace, but not
the beginning text that describes why we've crashed.

-chris
