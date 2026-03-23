Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770FB27E1A1;
	Mon, 23 Mar 2026 15:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278730; cv=none; b=JUMi8rr2WVLMLFbvhUA8T1PefpFZetpZLpRnBkReK+nEZPM+um0GuR2IF8VqOzUf7aMY6UyYUjE7aix0AGpDPZnqxGtJTq4QnqKmLXTqXxIljYwtw0XJIZV2YtgaKE4mPJXCGvTzoqUyQiPEYVYbb96RN6O4ibfj95syWQfsMS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278730; c=relaxed/simple;
	bh=xQHmOvadmMHhXFbOorPOjMgthX+BusjItcTh20RTeZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8EY0lzNWasJEf4zTh3vhVdiixYXLJ0RBKTcB3AYcBcE3/w8jv71+DJNdbM5KdVWBUKQb1cWrFU9j3Lr1o7aDXrq2TmTC8GeQSExtUO/4ZVuprsojqeN4o3IrL+HI72BnCib8/4z763Cwhz9spsMV5sNgznhIVgYAzOAXjPb4Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyXCTe15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyXCTe15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77A4C4CEF7;
	Mon, 23 Mar 2026 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278730;
	bh=xQHmOvadmMHhXFbOorPOjMgthX+BusjItcTh20RTeZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyXCTe15jD+e4kLdd3IS5k7RJ6tQku7VM0z/VL+ylMXj0eMqh0LrG0ovkpg60dsjG
	 oe0MP0j78anm7ZL97kDv+Uq3ae+M7rJkiY0kVP/NK/2gcx2IY99up9prlYJEmQvkDt
	 kyXdNxQJG6/nXLEmmcc0rFiQ6IvnESq9i6hjI1X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 400/567] btrfs: always fallback to buffered write if the inode requires checksum
Date: Mon, 23 Mar 2026 14:45:20 +0100
Message-ID: <20260323134543.763511700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

commit 968f19c5b1b7d5595423b0ac0020cc18dfed8cb5 upstream.

[BUG]
It is a long known bug that VM image on btrfs can lead to data csum
mismatch, if the qemu is using direct-io for the image (this is commonly
known as cache mode 'none').

[CAUSE]
Inside the VM, if the fs is EXT4 or XFS, or even NTFS from Windows, the
fs is allowed to dirty/modify the folio even if the folio is under
writeback (as long as the address space doesn't have AS_STABLE_WRITES
flag inherited from the block device).

This is a valid optimization to improve the concurrency, and since these
filesystems have no extra checksum on data, the content change is not a
problem at all.

But the final write into the image file is handled by btrfs, which needs
the content not to be modified during writeback, or the checksum will
not match the data (checksum is calculated before submitting the bio).

So EXT4/XFS/NTRFS assume they can modify the folio under writeback, but
btrfs requires no modification, this leads to the false csum mismatch.

This is only a controlled example, there are even cases where
multi-thread programs can submit a direct IO write, then another thread
modifies the direct IO buffer for whatever reason.

For such cases, btrfs has no sane way to detect such cases and leads to
false data csum mismatch.

[FIX]
I have considered the following ideas to solve the problem:

- Make direct IO to always skip data checksum
  This not only requires a new incompatible flag, as it breaks the
  current per-inode NODATASUM flag.
  But also requires extra handling for no csum found cases.

  And this also reduces our checksum protection.

- Let hardware handle all the checksum
  AKA, just nodatasum mount option.
  That requires trust for hardware (which is not that trustful in a lot
  of cases), and it's not generic at all.

- Always fallback to buffered write if the inode requires checksum
  This was suggested by Christoph, and is the solution utilized by this
  patch.

  The cost is obvious, the extra buffer copying into page cache, thus it
  reduces the performance.
  But at least it's still user configurable, if the end user still wants
  the zero-copy performance, just set NODATASUM flag for the inode
  (which is a common practice for VM images on btrfs).

  Since we cannot trust user space programs to keep the buffer
  consistent during direct IO, we have no choice but always falling back
  to buffered IO.  At least by this, we avoid the more deadly false data
  checksum mismatch error.

Cc: stable@vger.kernel.org # 6.6
[ Conflicts caused by code extracted into direct-io.c ]
Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1514,6 +1514,22 @@ relock:
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
 		goto buffered;
 	}
+	/*
+	 * We can't control the folios being passed in, applications can write
+	 * to them while a direct IO write is in progress.  This means the
+	 * content might change after we calculated the data checksum.
+	 * Therefore we can end up storing a checksum that doesn't match the
+	 * persisted data.
+	 *
+	 * To be extra safe and avoid false data checksum mismatch, if the
+	 * inode requires data checksum, just fallback to buffered IO.
+	 * For buffered IO we have full control of page cache and can ensure
+	 * no one is modifying the content during writeback.
+	 */
+	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
+		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
+		goto buffered;
+	}
 
 	/*
 	 * The iov_iter can be mapped to the same file range we are writing to.


