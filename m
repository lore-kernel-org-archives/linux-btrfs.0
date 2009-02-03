From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: call mark_inode_dirty when i_size is updated
Date: Mon, 02 Feb 2009 20:04:52 -0500
Message-ID: <1233623092.20109.2.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20090202183710.06cdb8e0@172.19.0.2>
	 <1233583946.18113.6.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20090203092917.06abcde0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090203092917.06abcde0@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 09:36 +0900, Hisashi Hifumi wrote:
> At 23:12 09/02/02, Chris Mason wrote:
> >On Mon, 2009-02-02 at 20:00 +0900, Hisashi Hifumi wrote:
> >> Hi Chris.
> >> 
> >> I think it is needed to call mark_inode_dirty() when file size expands
> >> in order to flush metadata updates to HDD through sync() syscall or
> >> background_writeout().
> >> 
> >
> >Thanks for reading through this code and sending the patch.
> >
> >I find the I_DIRTY flags one of the more confusing parts of the generic
> >fs writeback cdoe.  But, I think what happens is the
> >btrfs_set_page_dirty function calls __set_page_dirty_nobuffers() which
> >does:
> >
> >if (mapping->host) {
> >     /* !PageAnon && !swapper_space */
> >      __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >}
> >
> >This should be enough to make sure the btrfs inodes are processed by
> >background writeout and sync().  Please let me know if I'm misreading
> >things.
> 
> Surely, as you pointed out, btrfs_set_page_dirty calls
> if (mapping->host) {
>      /* !PageAnon && !swapper_space */
>       __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> }
> through _set_page_dirty_nobuffers.
> But I_DIRTY_PAGES is not sufficient.
> To flush metadata update to HDD through sync(), I_DIRTY_SYNC or 
> I_DIRTY_DATASYNC flag is needed. see __sync_single_inode.

Since btrfs uses a dirty_inode callback, our inodes are never really
dirty. The btree metadata always has the same information as the in-core
inode does.

The extra transaction commit steps taken at sync time are enough to get
all the relevant metadata on disk.

So, I think what happens is that I_DIRTY_PAGES is enough to get the data
pages on disk and the transaction commit gets the metadata on disk.

-chris


