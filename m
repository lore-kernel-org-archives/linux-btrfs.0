From: Akshat Aranya <aranya@nec-labs.com>
Subject: Possible bug in btrfs_file_aio_write()
Date: Wed, 02 Feb 2011 15:15:52 -0500
Message-ID: <4D49BB78.2000906@nec-labs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm looking at the code for btrfs_file_aio_write().  Specifically, the 
following lines:


	first_index = pos >> PAGE_CACHE_SHIFT;
	last_index = (pos + iov_iter_count(&i)) >> PAGE_CACHE_SHIFT;

	/*
	 * there are lots of better ways to do this, but this code
	 * makes sure the first and last page in the file range are
	 * up to date and ready for cow
	 */
	if ((pos & (PAGE_CACHE_SIZE - 1))) {
		pinned[0] = grab_cache_page(inode->i_mapping, first_index);
		if (!PageUptodate(pinned[0])) {
			ret = btrfs_readpage(NULL, pinned[0]);
			BUG_ON(ret);
			wait_on_page_locked(pinned[0]);
		} else {
			unlock_page(pinned[0]);
		}
	}
	if ((pos + iov_iter_count(&i)) & (PAGE_CACHE_SIZE - 1)) {
		pinned[1] = grab_cache_page(inode->i_mapping, last_index);
		if (!PageUptodate(pinned[1])) {
			ret = btrfs_readpage(NULL, pinned[1]);
			BUG_ON(ret);
			wait_on_page_locked(pinned[1]);
		} else {
			unlock_page(pinned[1]);
		}
	}


Am I missing something, or is there an off-by-one error over here?  The 
last byte in the written region would be "pos + iov_iter_count(&i) - 1", 
not "pos + iov_iter_count(&i)".  I verified this by writing 4096 bytes 
at offset 0. first_index evaluates to 0 and last_index evaluates to 1.

-Akshat
