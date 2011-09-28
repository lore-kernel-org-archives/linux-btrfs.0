From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: File compression control, again.
Date: Wed, 28 Sep 2011 09:45:37 +0800
Message-ID: <4E827C41.1000805@cn.fujitsu.com>
References: <loom.20110927T185853-434@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Artem <artemciy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110927T185853-434@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

01:17, Artem worte:
> Hi!
> 
> So, it makes sense to keep the compression on by default
> and with LZO many people are going there.
> 
> But, I want to create a database on a compressed btrfs filesystem
> which is seek-heavy rather than throughput-heavy
> and I really want to turn the compression off just for that database
> (smaller I/O reads, more precise cache usage).
> 
> Maintenance nightmare that Miguel mentioned
> ( http://thread.gmane.org/gmane.comp.file-systems.btrfs/1665/focus=1669 )
> isn't really a problem as I'm going to automatically set the flags
> from the program, just before opening the database.
> 
> Looking at "fs/btrfs/ioctl.h" I don't see any way to to this.
> Subvolume compression control isn't working either from what I heard
> (cf. https://bbs.archlinux.org/viewtopic.php?id=126635
>      http://thread.gmane.org/gmane.comp.file-systems.btrfs/6237/ ).
> 
> Am I right that fine-grained compression control is no longer supported by btrfs?
> If so, I would like to vote for it to be added.
> 

See this "Per file/directory controls for COW and compression":

	http://marc.info/?l=linux-btrfs&m=130078867208491&w=2

And the user tool patch (which got no reply):

	http://marc.info/?l=linux-btrfs&m=130311215721242&w=2

So you can create a directory, and set the no-compress flag for it, and
then any file created in that dir will inherit the flag.
