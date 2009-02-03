From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: call mark_inode_dirty when i_size is updated
Date: Tue, 03 Feb 2009 11:22:34 -0500
Message-ID: <1233678154.7246.23.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20090202183710.06cdb8e0@172.19.0.2>
	 <1233583946.18113.6.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20090203092917.06abcde0@172.19.0.2>
	 <1233623092.20109.2.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20090203113346.0419ef98@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090203113346.0419ef98@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 11:43 +0900, Hisashi Hifumi wrote:
> At 10:04 09/02/03, Chris Mason wrote:
> >On Tue, 2009-02-03 at 09:36 +0900, Hisashi Hifumi wrote:
> >> At 23:12 09/02/02, Chris Mason wrote:
> >> >On Mon, 2009-02-02 at 20:00 +0900, Hisashi Hifumi wrote:
> >> >> Hi Chris.
> >> >> 
> >> >> I think it is needed to call mark_inode_dirty() when file size expands
> >> >> in order to flush metadata updates to HDD through sync() syscall or
> >> >> background_writeout().
> >> >> 
> >> >
> >> >Thanks for reading through this code and sending the patch.
> >> >
> >> >I find the I_DIRTY flags one of the more confusing parts of the generic
> >> >fs writeback cdoe.  But, I think what happens is the
> >> >btrfs_set_page_dirty function calls __set_page_dirty_nobuffers() which
> >> >does:
> >> >
> >> >if (mapping->host) {
> >> >     /* !PageAnon && !swapper_space */
> >> >      __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >> >}
> >> >
> >> >This should be enough to make sure the btrfs inodes are processed by
> >> >background writeout and sync().  Please let me know if I'm misreading
> >> >things.
> >> 
> >> Surely, as you pointed out, btrfs_set_page_dirty calls
> >> if (mapping->host) {
> >>      /* !PageAnon && !swapper_space */
> >>       __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
> >> }
> >> through _set_page_dirty_nobuffers.
> >> But I_DIRTY_PAGES is not sufficient.
> >> To flush metadata update to HDD through sync(), I_DIRTY_SYNC or 
> >> I_DIRTY_DATASYNC flag is needed. see __sync_single_inode.
> >
> >Since btrfs uses a dirty_inode callback, our inodes are never really
> >dirty. The btree metadata always has the same information as the in-core
> >inode does.
> >
> >The extra transaction commit steps taken at sync time are enough to get
> >all the relevant metadata on disk.
> >
> >So, I think what happens is that I_DIRTY_PAGES is enough to get the data
> >pages on disk and the transaction commit gets the metadata on disk.
> 
> 
> metadata update transaction is made through dirty_inode call back, but
> to run dirty_inode callback I_DIRTY_SYNC or  I_DIRTY_DATASYNC flag is needed.
> (see __mark_inode_dirty).

Btrfs is using btrfs_update_inode to get inode updates into the btree
when it changes things.  The only places that trigger the dirty_inode
callback are the generic code that do atime/mtime/ctime updates and a
few other generic VFS operations.

>
> Also, to commit transaction to disk through write_inode callback, I_DIRTY_SYNC 
> or  I_DIRTY_DATASYNC flag is needed.(see _sync_single_inode)
> 
> So I think my patch fixes this issue.

I think I don't fully understand which caller of write_inode (or
__sync_single_inode) we're missing.

For O_DIRECT and O_SYNC, btrfs_file_write is responsible for getting the
metadata on disk.

For sync(), the btrfs super operations do a full transaction commit.

In all of the above cases, the btree is always up to date with the
contents of the vfs inode.  We just need to make sure a transaction
commit (or log operation) is done for the file.

-chris


