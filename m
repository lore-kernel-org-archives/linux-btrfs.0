From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Setting options permanently?
Date: Mon, 30 Jan 2012 13:57:49 +0800
Message-ID: <4F26315D.30905@cn.fujitsu.com>
References: <4F22BCCC.5090800@danisch.de>	<CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>	<4F234616.6020407@danisch.de> <pan.2012.01.28.03.32.23@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.28.03.32.23@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

>> I currently don't see how to repair this afterwards without removing the
>> uncompressed files and writing new ones, which on the other hand spoils
>> hte memory saving effect of using snapshots instead of copies.
> 
> A rebalance is the usual way of handling such things, since that rewrites 
> every chunk, taking account of current mount options, etc.  If I've been 
> reading correctly, a defrag should handle it now as well, altho that used 
> to break snapshots/cow/reflink-copies, but I /think/ I read that with 3.2 
> (or was it 3.3-rc1) it doesn't, any more.
> 

Rebalance won't do the trick, but defrag can. And defrag still breaks
snapshots, which I'm working on.
