From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix uninitialized variable warning
Date: Fri, 03 Jun 2011 10:56:18 -0400
Message-ID: <1307112880-sup-4802@shiny>
References: <20110603110011.77121203.sfr@canb.auug.org.au> <20110603145014.GU12709@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: dave <dave@jikos.cz>
Return-path: <linux-next-owner@vger.kernel.org>
In-reply-to: <20110603145014.GU12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-06-03 10:50:14 -0400:
> From: David Sterba <dsterba@suse.cz>
> 
> With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
> produced this warning:
> 
> fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
> fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
> uninitialized in this function
> 
> Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
> operation").
> 
> This fixes a bug in btrfs_update_inode(): if the returned value from
> btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
> updated and several call paths may hit a BUG_ON or fail with strange
> code.

Ugh, thanks!  It looks like the gcc uninit stuff isn't as verbose as it
used to be, but it does catch a bunch of allocated/set but not used
vars.

I have a nitems = 0 fix in my tree as well.

-chris
