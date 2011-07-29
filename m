From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 1/4] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 29 Jul 2011 11:58:47 +0200
Message-ID: <4E328457.2000401@gmail.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	viro@ZenIV.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry maybe I'm a bit late? :)

Il 28/06/2011 17:33, Josef Bacik ha scritto:
>
>   loff_t default_llseek(struct file *file, loff_t offset, int origin)
>   {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>   	loff_t retval;
>
> -	mutex_lock(&file->f_dentry->d_inode->i_mutex);
> +	mutex_lock(&inode->i_mutex);
>   	switch (origin) {
>   		case SEEK_END:
> -			offset += i_size_read(file->f_path.dentry->d_inode);
> +			offset += i_size_read(inode);

Here we are under mutex, so I think we can use directly i_size without 
i_size_read.

Marco
