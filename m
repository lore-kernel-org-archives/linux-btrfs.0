From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: defrag makes fragmentation worse
Date: Wed, 12 Oct 2011 10:37:41 +0800
Message-ID: <4E94FD75.6040307@cn.fujitsu.com>
References: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com> <4E93E000.1000700@cn.fujitsu.com> <CAAE6i0h6QZGmLoFUPgouHTeC0FYvHPgbODXHEthaL5p4mLruVQ@mail.gmail.com> <CAAE6i0j=7ZoYnXsmNdWewmszSpaq4HLcy+M7--3s2hiy2p4TBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0j=7ZoYnXsmNdWewmszSpaq4HLcy+M7--3s2hiy2p4TBA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

05:15, Chester wrote:
> Okay, this pretty much confirms that autodefrag makes defrag totally
> useless.. The above email was with autodefrag turned off..
> 
> With autodefrag on:
> 339 MB file
> initially 4 extents
> 
> btrfs fi defrag filename
> filefrag filename
> 
> about 900 extents
> 
> I did btrfs defrag two more times and ended up with 2048 extents
> 
> I attached the output of filefrag -v, which shows a pretty peculiar pattern.

This confirmed my speculation. I've fixed this bug a month ago, but
the patch hasn't hitted mainline.

You can try it out:

http://marc.info/?l=linux-btrfs&m=131495014823121&w=2

With this bug fixed, I think autodefrag won't be problematic.

--
Li Zefan
