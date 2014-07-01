Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036AbaGAOoR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 10:44:17 -0400
Date: Tue, 1 Jul 2014 16:44:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs compression: merge inflate and deflate z_streams
Message-ID: <20140701144415.GJ1553@suse.cz>
Reply-To: dsterba@suse.cz
References: <1404142330-1621-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404142330-1621-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 12:32:10AM +0900, Sergey Senozhatsky wrote:
> `struct workspace' used for zlib compression contains two zlib
> z_stream-s: `def_strm' used in zlib_compress_pages(), and `inf_strm'
> used in zlib_decompress/zlib_decompress_biovec(). None of these
> functions use `inf_strm' and `def_strm' simultaniously, meaning that
> for every compress/decompress operation we need only one z_stream
> (out of two available).
> 
> `inf_strm' and `def_strm' are different in size of ->workspace. For
> inflate stream we vmalloc() zlib_inflate_workspacesize() bytes, for
> deflate stream - zlib_deflate_workspacesize() bytes. On my system zlib
> returns the following workspace sizes, correspondingly: 42312 and 268104
> (+ guard pages).
> 
> Keep only one `z_stream' in `struct workspace' and use it for both
> compression and decompression. Hence, instead of vmalloc() of two
> z_stream->worskpace-s, allocate only one of size:
> 	max(zlib_deflate_workspacesize(), zlib_inflate_workspacesize())
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
