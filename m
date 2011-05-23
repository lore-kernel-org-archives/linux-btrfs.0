From: Arne Jansen <sensille@gmx.net>
Subject: Re: Backref walking utilities
Date: Mon, 23 May 2011 12:02:21 +0200
Message-ID: <4DDA30AD.2020409@gmx.net>
References: <4DDA2EA7.9080305@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DDA2EA7.9080305@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi liubo,

On 23.05.2011 11:53, liubo wrote:
> As one of my plans, I'm going to take this project over unless someone has been working on it.

Jan Schmidt has a patch for scrub nearly ready, that does some
ref-walking to report affected files to the user. While this is
kernel code and you're planning to add user-space code, it might
still be possible to share some of it. Maybe the efforts can be
coordinated.

Thanks
Arne

> 
>>From wiki, quote:
>     Backref walking utilities
> 
>     Given a block number on a disk, the Btrfs metadata can find all the files and directories
>     that use or care about that block.  Some utilities to walk these back refs and print the
>     results would help debug corruptions.
> 
>     Given an inode, the Btrfs metadata can find all the directories that point to the inode.
>     We should have utils to walk these back refs as well. 
> end quote.
> 
> And I have some thoughts to share with you:
> 
>     - Clearly, this is going to be another command.  Just like the command "btrfs-debug-tree",
>       btrfs-walk-backref also needs to be able to track btrfs's metadata in
>           a) the offline situation (at a umount state), or
>           b) the corrupted situation.
> 
>     - For block number, the main goal is to find relative extent backrefs.  When it comes to
>       those shared blocks, maybe things will be more complex.
> 
>     - For inode, the main goal is to find relative inode refs.  And we should be cautious about
>       a) an inode with hard links, b) snapshot.
> 
> Did I miss or misunderstand something?  Any comments are welcomed. :)
> 
> thanks,
> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

