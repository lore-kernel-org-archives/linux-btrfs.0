Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37202 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaGGOac (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 10:30:32 -0400
Date: Mon, 7 Jul 2014 23:29:57 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: dsterba@suse.cz, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs compression: merge inflate and deflate z_streams
Message-ID: <20140707142957.GB955@swordfish>
References: <1404142330-1621-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20140701144415.GJ1553@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140701144415.GJ1553@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On (07/01/14 16:44), David Sterba wrote:
> On Tue, Jul 01, 2014 at 12:32:10AM +0900, Sergey Senozhatsky wrote:
> > `struct workspace' used for zlib compression contains two zlib
> > z_stream-s: `def_strm' used in zlib_compress_pages(), and `inf_strm'
> > used in zlib_decompress/zlib_decompress_biovec(). None of these
> > functions use `inf_strm' and `def_strm' simultaniously, meaning that
> > for every compress/decompress operation we need only one z_stream
> > (out of two available).
> > 
> > `inf_strm' and `def_strm' are different in size of ->workspace. For
> > inflate stream we vmalloc() zlib_inflate_workspacesize() bytes, for
> > deflate stream - zlib_deflate_workspacesize() bytes. On my system zlib
> > returns the following workspace sizes, correspondingly: 42312 and 268104
> > (+ guard pages).
> > 
> > Keep only one `z_stream' in `struct workspace' and use it for both
> > compression and decompression. Hence, instead of vmalloc() of two
> > z_stream->worskpace-s, allocate only one of size:
> > 	max(zlib_deflate_workspacesize(), zlib_inflate_workspacesize())
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 

Hello,

the patch does not apply against linux-next rc4-20140707 due to 130d5b415a091e.
unhappy hunk is:

+		if (workspace->strm.total_in > 8192 &&
+		    workspace->strm.total_in <
+		    workspace->strm.total_out) {
 			ret = -EIO;

now it should be:
+		if (workspace->strm.total_in > 8192 &&
+		    workspace->strm.total_in <
+		    workspace->strm.total_out) {
 			ret = -E2BIG;


I'll rebase and resend.

	-ss
