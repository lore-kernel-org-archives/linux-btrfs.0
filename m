From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: call mark_inode_dirty when i_size is updated
Date: Mon, 02 Feb 2009 09:12:26 -0500
Message-ID: <1233583946.18113.6.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20090202183710.06cdb8e0@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6.0.0.20.2.20090202183710.06cdb8e0@172.19.0.2>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-02-02 at 20:00 +0900, Hisashi Hifumi wrote:
> Hi Chris.
> 
> I think it is needed to call mark_inode_dirty() when file size expands
> in order to flush metadata updates to HDD through sync() syscall or
> background_writeout().
> 

Thanks for reading through this code and sending the patch.

I find the I_DIRTY flags one of the more confusing parts of the generic
fs writeback cdoe.  But, I think what happens is the
btrfs_set_page_dirty function calls __set_page_dirty_nobuffers() which
does:

if (mapping->host) {
     /* !PageAnon && !swapper_space */
      __mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
}

This should be enough to make sure the btrfs inodes are processed by
background writeout and sync().  Please let me know if I'm misreading
things.

-chris


