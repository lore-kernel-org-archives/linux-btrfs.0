From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Integration branch pushed out to btrfs-unstable
Date: Tue, 24 May 2011 17:50:20 +0800
Message-ID: <4DDB7F5C.8050004@cn.fujitsu.com>
References: <1306179381-sup-443@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>, Arne Jansen <sensille@gmx.net>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306179381-sup-443@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Hi everyone,
> 
> I've pushed out my current kernel git tree to a new branch called
> integration-test.  This is meant for integration testing only and should
> not be run by anyone who doesn't love crashes.
> 
> I've pulled together a lot of important work from a lot of different
> people.  It includes:
> 
> The new inode number allocator
> Delayed inode and directory item updates
> Scrub, chunk allocator fixes
> Races in device addition and removal
> Josef's performance fixes
> A large series of cleanups and fixes
> 
> Most of the integration work was just pushing the cleanups into the new
> code bits.  I still want to integrate Hugo Mills' balance progress
> ioctls (really nice).  But it was a lot of work to get this all working
> together and I wanted to let everyone retest the result.
> 
> Miao, I didn't include your patch to delay inode item insertion because
> I was worried about interactions with the caching thread of the new
> inode number allocator.  I did have to make a small change to make sure
> the inode-map cache didn't go through the delayed item routines.
> 
> Li, one thing I haven't done yet is a lot of benchmarking on the
> performance hit from waiting for the cache to fill on large existing
> filesystems.  Was there any particular reason you didn't setup the
> caching to pre-cache the from root->highest_objectid to
> BTRFS_LAST_FREE_OBJECTID?
> 

I'll cook up a patch for this kind of pre-cache.
