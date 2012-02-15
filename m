From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH V2] Btrfs-progs: add \"btrfs subvolume get-default\"
 subcommand
Date: Wed, 15 Feb 2012 18:35:58 +0200
Message-ID: <20120215163558.GA1974@zambezi.lan>
References: <1310374571-20811-1-git-send-email-xin.zhong@intel.com>
 <4F3B45E6.3000008@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xin.zhong@intel.com, Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F3B45E6.3000008@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2012 at 01:43:02PM +0800, Anand Jain wrote:
> 
> Hi Xin / Hugo,
>  I am referring to
>  git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
>  has miss match parameter list for list_subvols
>  ----------
>  # cd btrfs-progs
>  # egrep list_subvols *
>  btrfs_cmds.c:	ret = list_subvols(fd, print_parent, 0);
>  btrfs_cmds.c:	ret = list_subvols(fd, 0, 1);
>  btrfs_cmds.h:int list_subvols(int fd, int print_parent, int get_default);  <-----
>  btrfs-list.c:int list_subvols(int fd, int print_parent)  <-----
>  ----------
> 
>  ----------
>  # egrep -A 3 list_subvols btrfs-list.c
>  int list_subvols(int fd, int print_parent)
>  {
> 	struct root_lookup root_lookup;
> 	struct rb_node *n;
>  ----------
>  Looks like the following patch was checked in partially.
>    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg11103.html
> 
>  Could you pls take a look / comment.

I looked at this issue briefly when testing the new parser.  Looks like
Jan broke it with his split of list_subvols.  Jan's code was probably
based on the master branch of the old progs repo, whereas get-default
was based on one of the integration branches and the subsequent merge
missed it.  I'll fix it if nobody else steps up.

Thanks,

		Ilya
