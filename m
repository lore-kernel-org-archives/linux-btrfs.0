Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:49960 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbcJJPzJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 11:55:09 -0400
Date: Mon, 10 Oct 2016 16:55:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161010155503.GZ19539@ZenIV.linux.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
 <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
 <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
 <20161010034356.GY19539@ZenIV.linux.org.uk>
 <20161010131122.cjmoof6yblwl7tak@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161010131122.cjmoof6yblwl7tak@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 09:11:22AM -0400, Dave Jones wrote:

> My compiler choked on that, but I fixed it up. The printk didn't
> trigger though..
> 
> idx = 0, offset = 0
> curbuf = 0, nrbufs = 1, buffers = 16
> [ffffffffb9a21100 ffffea00126019c0 0 4096]
> [          (null) ffffea0013746440 0 0]
> [          (null) ffffea00132956c0 0 0]
> [          (null) ffffea0013295700 0 0]
> [          (null) ffffea0013295740 0 0]
> [          (null) ffffea0013295780 0 0]
> [          (null) ffffea00132957c0 0 0]
> [          (null) ffffea0013595c00 0 0]
> [          (null) ffffea0012b1b6c0 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> [          (null)           (null) 0 0]
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 13581 at lib/iov_iter.c:327 sanity+0x102/0x150
> CPU: 1 PID: 13581 Comm: trinity-c17 Not tainted 4.8.0-think+ #9 
>  ffffc90000963ae8
>  ffffffffb93e22d1
>  0000000000000000
>  0000000000000000
> 
>  ffffffffb9c1e1cb
>  ffffffffb93fa5b2
>  ffffc90000963b28
>  ffffffffb908b010
> 
>  00000147d43c0e7f
>  ffffffffb9c1e1cb
>  0000000000000147
>  0000000000000010

What are these from?  Confused...

> Call Trace:

[via splice_direct_to_actor()]

Hmmm...  I think I see it.  Could you try the following (on top of debugging
in lib/iov_iter.c) and see if anything triggers?

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index bfc2aa7..b63d8c5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -319,7 +319,7 @@ xfs_file_dio_aio_read(
 	data = *to;
 	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
 			xfs_get_blocks_direct, NULL, NULL, 0);
-	if (ret > 0) {
+	if (ret >= 0) {
 		iocb->ki_pos += ret;
 		iov_iter_advance(to, ret);
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 68f1813..88e5ddd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1935,7 +1935,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		file_accessed(file);
 
 		retval = mapping->a_ops->direct_IO(iocb, &data);
-		if (retval > 0) {
+		if (retval >= 0) {
 			iocb->ki_pos += retval;
 			iov_iter_advance(iter, retval);
 		}
