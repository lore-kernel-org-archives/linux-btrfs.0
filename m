From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] fs: push file_update_time into ->page_mkwrite
Date: Tue, 29 Nov 2011 16:50:20 +0100
Message-ID: <20111129155020.GQ5635@quack.suse.cz>
References: <1322581259-14409-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@ZenIV.linux.org.uk, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1322581259-14409-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 29-11-11 10:40:59, Josef Bacik wrote:
> The fault code has been calling file_update_time after ->page_mkwrite after it
> drops the page lock, but this is annoying because this calls mark_inode_dirty
> which can fail in Btrfs, so we want to be able to do these updates in
> ->page_mkwrite so we can get an error back to the user.  So get rid of the
> file_update_time calls in the fault code and push it into everybody who has a
> ->page_mkwrite.  I didn't do this for ubifs because it appears that ubifs
> already updates the time itself in ->page_mkwrite, presumebly for the same
> reasons as btrfs, so I left it as is.  Thanks,
  But this effectively disables atime updates on mmaped writes for ext2,
ext3, and similar filesystems which is a no-go IMHO.

									Honza
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/9p/vfs_file.c             |    1 +
>  fs/btrfs/inode.c             |    1 +
>  fs/buffer.c                  |    1 +
>  fs/ceph/addr.c               |    1 +
>  fs/cifs/file.c               |    1 +
>  fs/ext4/inode.c              |    1 +
>  fs/fuse/file.c               |    1 +
>  fs/gfs2/file.c               |    1 +
>  fs/nfs/file.c                |    1 +
>  fs/nilfs2/file.c             |    1 +
>  fs/ocfs2/mmap.c              |    1 +
>  fs/sysfs/bin.c               |    1 +
>  kernel/events/core.c         |    1 +
>  mm/memory.c                  |    8 --------
>  security/selinux/selinuxfs.c |    1 +
>  15 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index 62857a8..ae2968f 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -610,6 +610,7 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	P9_DPRINTK(P9_DEBUG_VFS, "page %p fid %lx\n",
>  		   page, (unsigned long)filp->private_data);
>  
> +	file_update_time(filp);
>  	v9inode = V9FS_I(inode);
>  	/* make sure the cache has finished storing the page */
>  	v9fs_fscache_wait_on_page_write(inode, page);
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e16215f..c272b91 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6313,6 +6313,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	}
>  
>  	ret = VM_FAULT_NOPAGE; /* make the VM retry the fault */
> +	file_update_time(vma->vm_file);
>  again:
>  	lock_page(page);
>  	size = i_size_read(inode);
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 1a80b04..c949a11 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2347,6 +2347,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	loff_t size;
>  	int ret;
>  
> +	file_update_time(vma->vm_file);
>  	lock_page(page);
>  	size = i_size_read(inode);
>  	if ((page->mapping != inode->i_mapping) ||
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 5a3953d..1cf89aa 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1137,6 +1137,7 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	dout("page_mkwrite %p %llu~%llu page %p idx %lu\n", inode,
>  	     off, len, page, page->index);
>  
> +	file_update_time(vma->vm_file);
>  	lock_page(page);
>  
>  	ret = VM_FAULT_NOPAGE;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9f41a10..410b11c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1910,6 +1910,7 @@ cifs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct page *page = vmf->page;
>  
> +	file_update_time(vma->vm_file);
>  	lock_page(page);
>  	return VM_FAULT_LOCKED;
>  }
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 986e238..e995f2c 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4372,6 +4372,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		goto out_ret;
>  	}
>  
> +	file_update_time(vma->vm_file);
>  	lock_page(page);
>  	size = i_size_read(inode);
>  	/* Page got truncated from under us? */
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 594f07a..4f92651 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1323,6 +1323,7 @@ static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	 */
>  	struct inode *inode = vma->vm_file->f_mapping->host;
>  
> +	file_update_time(vma->vm_file);
>  	fuse_wait_on_page_writeback(inode, page->index);
>  	return 0;
>  }
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index edeb9e8..ba22704 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -359,6 +359,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	struct gfs2_alloc *al;
>  	int ret;
>  
> +	file_update_time(vma->vm_file);
>  	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
>  	ret = gfs2_glock_nq(&gh);
>  	if (ret)
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 28b8c3f..bfa0c48 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -571,6 +571,7 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  		filp->f_mapping->host->i_ino,
>  		(long long)page_offset(page));
>  
> +	file_update_time(filp);
>  	/* make sure the cache has finished storing the page */
>  	nfs_fscache_wait_on_page_write(NFS_I(dentry->d_inode), page);
>  
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 2660152..d1ab350 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -70,6 +70,7 @@ static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (unlikely(nilfs_near_disk_full(inode->i_sb->s_fs_info)))
>  		return VM_FAULT_SIGBUS; /* -ENOSPC */
>  
> +	file_update_time(vma->vm_file);
>  	lock_page(page);
>  	if (page->mapping != inode->i_mapping ||
>  	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page)) {
> diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
> index 3e9393c..27c59e5 100644
> --- a/fs/ocfs2/mmap.c
> +++ b/fs/ocfs2/mmap.c
> @@ -141,6 +141,7 @@ static int ocfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  
>  	ocfs2_block_signals(&oldset);
>  
> +	file_update_time(vma->vm_file);
>  	/*
>  	 * The cluster locks taken will block a truncate from another
>  	 * node. Taking the data lock will also ensure that we don't
> diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
> index a475983..4879bfb 100644
> --- a/fs/sysfs/bin.c
> +++ b/fs/sysfs/bin.c
> @@ -225,6 +225,7 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	if (!sysfs_get_active(attr_sd))
>  		return VM_FAULT_SIGBUS;
>  
> +	file_update_time(file);
>  	ret = 0;
>  	if (bb->vm_ops->page_mkwrite)
>  		ret = bb->vm_ops->page_mkwrite(vma, vmf);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0f85778..abbaee4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3466,6 +3466,7 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  	struct ring_buffer *rb;
>  	int ret = VM_FAULT_SIGBUS;
>  
> +	file_update_time(vma->vm_file);
>  	if (vmf->flags & FAULT_FLAG_MKWRITE) {
>  		if (vmf->pgoff == 0)
>  			ret = 0;
> diff --git a/mm/memory.c b/mm/memory.c
> index a56e3ba..8e4686f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2619,10 +2619,6 @@ reuse:
>  			}
>  		}
>  
> -		/* file_update_time outside page_lock */
> -		if (vma->vm_file)
> -			file_update_time(vma->vm_file);
> -
>  		return ret;
>  	}
>  
> @@ -3303,10 +3299,6 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  			 */
>  			balance_dirty_pages_ratelimited(mapping);
>  		}
> -
> -		/* file_update_time outside page_lock */
> -		if (vma->vm_file)
> -			file_update_time(vma->vm_file);
>  	} else {
>  		unlock_page(vmf.page);
>  		if (anon)
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 55d92cb..e5f4be1 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -458,6 +458,7 @@ static int sel_mmap_policy_fault(struct vm_area_struct *vma,
>  	unsigned long offset;
>  	struct page *page;
>  
> +	file_update_time(vma->vm_file);
>  	if (vmf->flags & (FAULT_FLAG_MKWRITE | FAULT_FLAG_WRITE))
>  		return VM_FAULT_SIGBUS;
>  
> -- 
> 1.7.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
