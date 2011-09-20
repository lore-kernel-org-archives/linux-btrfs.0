From: Sage Weil <sage@newdream.net>
Subject: Re: [GIT PULL] Btrfs fixes
Date: Tue, 20 Sep 2011 09:19:47 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1109200917500.7760@cobra.newdream.net>
References: <1316476217-sup-4802@shiny>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1316476217-sup-4802@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris-

This pull misses the clone reservation fix again... :)

	http://www.spinics.net/lists/linux-btrfs/msg11826.html

Thanks!
sage



On Mon, 19 Sep 2011, Chris Mason wrote:

> Hi everyone,
> 
> The for-linus branch of the btrfs tree on github:
> 
> Head commit: a66e7cc626f42de6c745963fe0d807518fa49d39
> git://github.com/chrismason/linux.git for-linus
> 
> Has the following fixes.  for-linus is against rc6, since some of these
> are regression fixes for earlier 3.1 btrfs commits.  The most important
> of the bunch is Josef's dentry fix, which avoids enoents if we race with
> multiple procs hitting on the same inode.  This bug is btrfs-specific,
> it came in with his optimization to cache the inode location during
> readdir.
> 
> Li Zefan (3) commits (+9/-5):
>     Btrfs: don't make a file partly checksummed through file clone (+5/-0)
>     Btrfs: don't change inode flag of the dest clone file (+0/-1)
>     Btrfs: fix pages truncation in btrfs_ioctl_clone() (+4/-4)
> 
> Josef Bacik (1) commits (+11/-2):
>     Btrfs: only clear the need lookup flag after the dentry is setup
> 
> Jeff Liu (1) commits (+7/-2):
>     BTRFS: Fix lseek return value for error
> 
> Hidetoshi Seto (1) commits (+3/-2):
>     btrfs: fix d_off in the first dirent
> 
> Total: (6) commits (+30/-11)
> 
>  fs/btrfs/file.c  |    9 +++++++--
>  fs/btrfs/inode.c |   18 ++++++++++++++----
>  fs/btrfs/ioctl.c |   14 +++++++++-----
>  3 files changed, 30 insertions(+), 11 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
