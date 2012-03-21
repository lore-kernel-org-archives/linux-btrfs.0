From: Justin Sharp <sharp@sharpone.net>
Subject: Re: bcache with SSD instead of battery powered raid cards
Date: Tue, 20 Mar 2012 22:47:44 -0600
Message-ID: <4F695D70.8030106@sharpone.net>
References: <CANT588ujRWQtreA07dPK9ynj7dXVGykRMXjcQy_kFd3mFimZ6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Kiran Patil <kirantpatil@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANT588ujRWQtreA07dPK9ynj7dXVGykRMXjcQy_kFd3mFimZ6w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/13/2012 04:06 AM, Kiran Patil wrote:
> Hi,
>
> Is anybody using bcache with SSD instead of battery powered raid cards
> with Btrfs ?
>
> Hard drives are cheap and big, SSDs are fast but small and expensive.
> Wouldn't it be nice if you could transparently get the advantages of
> both? With Bcache, you can have your cake and eat it too.
>
> Bcache is a patch for the Linux kernel to use SSDs to cache other
> block devices. It's analogous to L2Arc for ZFS, but Bcache also does
> writeback caching, and it's filesystem agnostic. It's designed to be
> switched on with a minimum of effort, and to work well without
> configuration on any setup. By default it won't cache sequential IO,
> just the random reads and writes that SSDs excel at. It's meant to be
> suitable for desktops, servers, high end storage arrays, and perhaps
> even embedded.
>
> http://bcache.evilpiepirate.org/
Did you ever experiment with this? What results did you find?

There is also something similar called flashcache developed by some 
facebook engineer that I'm interested in trying. They are supposedly 
using this to speed up mysql+innodb. It is out of mainline tree code 
though, and I don't think there is much of an effort to get it in. It 
supports writeback, writethrough and writearound (blocks are never 
cached on write, only on read) caching. It uses dm-mapper to combine 
your 'cache block' with your 'slow spinning block' and then you put your 
filesystem on top of that dm device. https://github.com/facebook/flashcache

Regards,
--Justin
