From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Patch] btrfs: use file_remove_suid() after i_mutex is held
Date: Sun, 5 Jul 2009 22:48:23 -0700
Message-ID: <20090705224823.5679075f@infradead.org>
References: <20090706053128.6318.16410.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
	Yan Zheng <zheng.yan@oracle.com>,
	Josef Bacik <jbacik@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org,
	Sven Wegener <sven.wegener@stealer.net>
To: Amerigo Wang <amwang@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090706053128.6318.16410.sendpatchset@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Jul 2009 01:29:14 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> file_remove_suid() should be called with i_mutex held,
> file_update_time() too. So move them after mutex_lock().
> 
> Plus, check the return value of kmalloc().
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7c3cd24..cd36301 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -944,14 +944,17 @@ static ssize_t btrfs_file_write(struct file
> *file, const char __user *buf, if (count == 0)
>  		goto out_nolock;
>  
> +	mutex_lock(&inode->i_mutex);
> +
>  	err = file_remove_suid(file);
>  	if (err)
> -		goto out_nolock;
> +		goto out;
>  	file_update_time(file);
>  
>  	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		goto out;
>  
Hi,

I don't think you can keep this at GFP_KERNEL once you hold i_mutex....
very likely this needs to now turn into GFP_NOFS!



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
