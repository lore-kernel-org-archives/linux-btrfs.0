From: David Sterba <dave@jikos.cz>
Subject: Re: Create subvolume from a directory?
Date: Wed, 2 May 2012 18:33:37 +0200
Message-ID: <20120502163337.GH6740@twin.jikos.cz>
References: <loom.20120327T190041-268@post.gmane.org>
 <4F734250.5030009@libero.it>
 <4F73B9DC.3040402@cn.fujitsu.com>
 <8026880.aVIK1HJLHr@bursa01>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, kreijack@inwind.it,
	"Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <8026880.aVIK1HJLHr@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 01, 2012 at 07:09:21PM +0200, Hubert Kario wrote:
> Let me rephrase it:
> 
> People don't want to be able to do:
> 
> mount /dev/lvm/btrfs /mnt/a -t btrfs -o subvol=volA
> mount /dev/lvm/btrfs /mnt/b -t btrfs -o subvol=volB
> cp --reflink=always /mnt/a/file /mnt/b
> 
> Just like you can't do hardlinks over `mount --bind` mountpoints, you 
> shouldn't be able to cp reflink over mountpoints. That's expected as this 
> *does* break VFS semantics.

Proposed fix (incremental on top of the cross-subvol):

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2321,6 +2321,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
                goto out_drop_write;
        }

+       ret = -EXDEV;
+       if (src_file->f_path.mnt != file->f_path.mnt)
+               goto out_fput;
+
        src = src_file->f_dentry->d_inode;

        ret = -EINVAL;


david
