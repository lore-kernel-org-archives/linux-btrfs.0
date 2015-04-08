Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62165 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751362AbbDHGBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 02:01:32 -0400
Message-ID: <5524C356.4010601@cn.fujitsu.com>
Date: Wed, 8 Apr 2015 13:57:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Btrfs: show subvol= and subvolid= in /proc/mounts
References: <cover.1428471096.git.osandov@osandov.com> <213f0b6a4cffcc82688894b4edbaeb51f8e71137.1428471096.git.osandov@osandov.com>
In-Reply-To: <213f0b6a4cffcc82688894b4edbaeb51f8e71137.1428471096.git.osandov@osandov.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: [PATCH 3/3] Btrfs: show subvol= and subvolid= in /proc/mounts
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba 
<dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Date: 2015年04月08日 13:34

> Currently, userspace has no way to know which subvolume is mounted.But,
> now that we're guaranteed to have a meaningful root dentry, we can just
> export and use seq_dentry() in btrfs_show_options(). The subvolume ID is
> easy to get, so put that in there, too.
Oh, I sent patch like this long long ago but still not merged.

http://comments.gmane.org/gmane.comp.file-systems.btrfs/36997

My patch doesn't do it in mount options, but add it to /proc/self/mountinfo.

In fact, if you mount subvolume with "-o subvol=", then 
/proc/self/mountinfo should has the result like below:
73 33 0:35 / /mnt/test rw,relatime shared:57 - btrfs /dev/sdb rw,space_cache
75 33 0:35 /test /mnt/scratch rw,relatime shared:59 - btrfs /dev/sdb 
rw,space_cache

The only problem is, if you mount with "-o subvolid=" as the *FIRST* 
mount of the fs, then mountinfo can't show it.

My patch will fix the above problem but not merged yet...

Thanks,
Qu
>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
>   fs/btrfs/super.c | 4 ++++
>   fs/seq_file.c    | 1 +
>   2 files changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 5ab9801..5e14bb6 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1193,6 +1193,10 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
>   		seq_puts(seq, ",fatal_errors=panic");
>   	if (info->commit_interval != BTRFS_DEFAULT_COMMIT_INTERVAL)
>   		seq_printf(seq, ",commit=%d", info->commit_interval);
> +	seq_puts(seq, ",subvol=");
> +	seq_dentry(seq, dentry, " \t\n\\");
> +	seq_printf(seq, ",subvolid=%llu",
> +		  BTRFS_I(d_inode(dentry))->root->root_key.objectid);
>   	return 0;
>   }
>
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 555f821..52b4927 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -538,6 +538,7 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, const char *esc)
>
>   	return res;
>   }
> +EXPORT_SYMBOL(seq_dentry);
>
>   static void *single_start(struct seq_file *p, loff_t *pos)
>   {
>
