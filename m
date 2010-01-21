From: Sander <sander@humilis.net>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000008
Date: Thu, 21 Jan 2010 09:57:36 +0100
Message-ID: <20100121085736.GB20543@cumulus>
References: <20100121060710.GA5301@cumulus>
 <20100121083849.GA7790@mother.pipebreaker.pl>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100121083849.GA7790@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomasz,

Tomasz Torcz wrote (ao):
> On Thu, Jan 21, 2010 at 07:07:10AM +0100, Sander wrote:
> > [26678.568532] [<c026c294>] (btrfs_get_acl+0x60/0x250) from [<c026c494>] (btrfs_xattr_get_acl+0x10/0x70)
> > [26678.577802] [<c026c494>] (btrfs_xattr_get_acl+0x10/0x70) from [<c019bb20>] (generic_getxattr+0x78/0x7c)
> > [26678.587243] [<c019bb20>] (generic_getxattr+0x78/0x7c) from [<c019c01c>] (vfs_getxattr+0x58/0x5c)
> > [26678.596074] [<c019c01c>] (vfs_getxattr+0x58/0x5c) from [<c019c0c4>] (getxattr+0xa4/0x11c)
> > [26678.604298] [<c019c0c4>] (getxattr+0xa4/0x11c) from [<c019c220>] (sys_getxattr+0x44/0x58)
> > [26678.612525] [<c019c220>] (sys_getxattr+0x44/0x58) from [<c0122e20>] (ret_fast_syscall+0x0/0x28)
> 
>   Although your oops is in btrfs_get_acl(), you may need similar fix
> as done for btrfs_set_acl() in this commit:
> 
>   http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commitdiff;h=a9cc71a60c29a09174bee2fcef8f924c529fd4b7

Thanks, that makes sense.

Unfortunately I'm no kernel hacker so I can't provide a patch. I'm more
than happy to test patches of course.

	With kind regards, Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
