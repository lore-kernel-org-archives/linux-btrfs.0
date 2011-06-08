From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] scrub fixes for -rc3
Date: Wed, 08 Jun 2011 13:54:16 -0400
Message-ID: <1307555576-sup-582@shiny>
References: <4DEF39C0.8040405@gmx.net> <4DEF7865.5070403@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DEF7865.5070403@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-06-08 09:25:57 -0400:
> On 06/08/2011 04:58 AM, Arne Jansen wrote:
> > Hi Chris,
> > 
> > please pull from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git
> > for-chris
> > 
> > It contains the 2 commits
> > 
> > Arne Jansen (1):
> >       btrfs: scrub: errors in tree enumeration
> > 
> > Li Zefan (1):
> >       Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()

Please leave off commits from others unless you somehow depend on
them ;)  I'll pull in the stack bloat patch separately.

re: the revert, it sounds like the lack of locking is causing trouble.
We'll have to figure something else out.

-chris
