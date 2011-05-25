From: Arne Jansen <sensille@gmx.net>
Subject: Re: Integration branch pushed out to btrfs-unstable
Date: Wed, 25 May 2011 14:35:43 +0200
Message-ID: <4DDCF79F.80405@gmx.net>
References: <1306179381-sup-443@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Li Zefan <lizf@cn.fujitsu.com>,
	Miao Xie <miaox@cn.fujitsu.com>, slyfox@gentoo.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306179381-sup-443@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.05.2011 21:54, Chris Mason wrote:
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

The commit

commit c4f675cd40d955d539180506c09515c90169b15b
Author: Sergei Trofimovich <slyfox@gentoo.org>
Date:   Fri May 20 20:20:30 2011 +0000

    btrfs: don't spin in shrink_delalloc if there is nothing to free

gives me very early ENOSPC in my tests on a small volume (7GB).

-Arne
