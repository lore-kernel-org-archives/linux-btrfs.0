Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38183 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753352AbdGXNP3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 09:15:29 -0400
Date: Mon, 24 Jul 2017 15:14:08 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/3] btrfs: fix readdir deadlock with pagefault
Message-ID: <20170724131408.GT2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
 <1500658149-20410-2-git-send-email-jbacik@fb.com>
 <20170724125050.GR2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170724125050.GR2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:50:50PM +0200, David Sterba wrote:
> On Fri, Jul 21, 2017 at 01:29:08PM -0400, josef@toxicpanda.com wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Readdir does dir_emit while under the btree lock.  dir_emit can trigger
> > the page fault which means we can deadlock.  Fix this by allocating a
> > buffer on opening a directory and copying the readdir into this buffer
> > and doing dir_emit from outside of the tree lock.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> > ---
> >  fs/btrfs/inode.c | 110 +++++++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 83 insertions(+), 27 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 9a4413a..61396e3 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -5877,6 +5877,56 @@ unsigned char btrfs_filetype_table[] = {
> >  	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
> >  };
> >  
> > +/*
> > + * All this infrastructure exists because dir_emit can fault, and we are holding
> > + * the tree lock when doing readdir.  For now just allocate a buffer and copy
> > + * our information into that, and then dir_emit from the buffer.  This is
> > + * similar to what NFS does, only we don't keep the buffer around in pagecache
> > + * because I'm afraid I'll fuck that up.

Can you please explain the concern in more detail?

> > Long term we need to make filldir do
> > + * copy_to_user_inatomic so we don't have to worry about page faulting under the
> > + * tree lock.
> > + */
> > +static int btrfs_opendir(struct inode *inode, struct file *file)
> > +{
> > +	struct page *page;
> > +
> > +	page = alloc_page(GFP_KERNEL);
> > +	if (!page)
> > +		return -ENOMEM;
> > +	file->private_data = page;
> > +	return 0;
> > +}
> > +
> > +static int btrfs_closedir(struct inode *inode, struct file *file)
> > +{
> > +	if (file->private_data) {
> > +		__free_page((struct page *)file->private_data);
> > +		file->private_data = NULL;
> > +	}
> > +	return 0;
> > +}
> > +
> > +struct dir_entry {
> > +	u64 ino;
> > +	u64 offset;
> > +	unsigned type;
> > +	int name_len;
> > +};
> > +
> > +static int btrfs_filldir(void *addr, int entries, struct dir_context *ctx)
> > +{
> > +	while (entries--) {
> > +		struct dir_entry *entry = addr;
> > +		char *name = (char *)(entry + 1);
> > +		ctx->pos = entry->offset;
> > +		if (!dir_emit(ctx, name, entry->name_len, entry->ino,
> > +			      entry->type))
> > +			return 1;
> > +		ctx->pos++;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  {
> >  	struct inode *inode = file_inode(file);
> > @@ -5886,16 +5936,17 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  	struct btrfs_key key;
> >  	struct btrfs_key found_key;
> >  	struct btrfs_path *path;
> > +	struct page *page = file->private_data;
> > +	void *addr, *start_addr;
> >  	struct list_head ins_list;
> >  	struct list_head del_list;
> >  	int ret;
> >  	struct extent_buffer *leaf;
> >  	int slot;
> > -	unsigned char d_type;
> > -	int over = 0;
> > -	char tmp_name[32];
> >  	char *name_ptr;
> >  	int name_len;
> > +	int entries = 0;
> > +	int total_len = 0;
> >  	bool put = false;
> >  	struct btrfs_key location;
> >  
> > @@ -5906,6 +5957,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  	if (!path)
> >  		return -ENOMEM;
> >  
> > +	start_addr = addr = kmap(page);
> >  	path->reada = READA_FORWARD;
> >  
> >  	INIT_LIST_HEAD(&ins_list);
> > @@ -5921,6 +5973,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  		goto err;
> >  
> >  	while (1) {
> > +		struct dir_entry *entry;
> >  		leaf = path->nodes[0];
> >  		slot = path->slots[0];
> >  		if (slot >= btrfs_header_nritems(leaf)) {
> > @@ -5942,41 +5995,42 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
> >  			goto next;
> >  		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
> >  			goto next;
> > -
> > -		ctx->pos = found_key.offset;
> > -
> >  		di = btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
> >  		if (verify_dir_item(fs_info, leaf, slot, di))
> >  			goto next;
> >  
> >  		name_len = btrfs_dir_name_len(leaf, di);
> > -		if (name_len <= sizeof(tmp_name)) {
> > -			name_ptr = tmp_name;
> > -		} else {
> > -			name_ptr = kmalloc(name_len, GFP_KERNEL);
> > -			if (!name_ptr) {
> > -				ret = -ENOMEM;
> > -				goto err;
> > -			}
> > +		if ((total_len + sizeof(struct dir_entry) + name_len) >=
> > +		    PAGE_SIZE) {
> 
> How does this work for filenames that of PATH_MAX length? Regardless of
> total_len size, the rest will always overflow PAGE_SIZE if it's 4k.

Ah no, it's filename, so the buffer will be always sufficient. So the
overall approach looks ok to me.
