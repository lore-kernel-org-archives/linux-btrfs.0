From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Mon, 12 Dec 2011 15:41:29 -0600 (CST)
Message-ID: <dc6ccf7d-261b-487c-966f-a7bcdd0439cc@mail.placs.net>
References: <20111208200524.GT8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Phillip Susi <psusi@cfl.rr.com>,
	Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208200524.GT8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

>You can't change the uuid of an existing btrfs partition. Well, you 
>can, but you have to rewrite all the metadata blocks. 

Is there a tool that would allow me to rewrite all the metadata blocks with a new UUID?  At this point, it can't possibly take longer than the way I'm trying to do it now...

Someone once said "Resetting the UUID on btrfs isn't a quick-and-easy thing - you have to walk the entire tree and change every object. We've got a bad-hack in meego that uses btrfs-debug-tree and changes the UUID while it runs the entire tree, but it's ugly as hell."

Ok, I'll take the bad-hack.  How would I actually go about using said bad-hack?

-BJ
