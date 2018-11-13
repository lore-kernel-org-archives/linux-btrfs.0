Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF01EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9BB8223AE
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 14:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9BB8223AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731119AbeKNATL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 19:19:11 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:37785 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731109AbeKNATL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 19:19:11 -0500
Received: from router-fw.i.net-space.pl ([192.168.52.1]:43954 "EHLO
        tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
        id S1875156AbeKMOTA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 15:19:00 +0100
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:   Tue, 13 Nov 2018 15:18:58 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org
Subject: Re: [PATCH v5 2/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181113141858.3ckjgn4nkywwhs4m@tomti.i.net-space.pl>
References: <20181112221446.2154944-1-terrelln@fb.com>
 <20181112221446.2154944-3-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112221446.2154944-3-terrelln@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 02:14:46PM -0800, Nick Terrell wrote:
> - Adds zstd support to the btrfs module.
> - Adds a test case for btrfs zstd support.
> - Changes top_srcdir to srcdir in the btrfs module's lzo include
>   following comments from Daniel Kiper about the zstd include.
>
> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zstd
> compression. A test case was also added to the test suite that fails before
> the patch, and passes after.
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>

Code mostly LGTM. However, coding style in grub-core/fs/btrfs.c is
largely incorrect. Please take a look below.

> ---
> v1 -> v2:
> - Fix comments from Daniel Kiper.
>
> v2 -> v3:
> - Use grub_error() to set grub_errno in grub_btrfs_zstd_decompress().
> - Fix style and formatting comments.
>
> v3 -> v4:
> - Use attribute unused.
>
> v4 -> v5:
> - Add zstd's module.c to Makefile.util.def.
> - Clarify some error logging.
> - Explain why I changed lzo's include.
>
>  Makefile.util.def            |  11 +++-
>  grub-core/Makefile.core.def  |   2 +-
>  grub-core/fs/btrfs.c         | 108 ++++++++++++++++++++++++++++++++++-
>  tests/btrfs_test.in          |   1 +
>  tests/util/grub-fs-tester.in |   2 +-
>  5 files changed, 120 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile.util.def b/Makefile.util.def
> index 9ae45f351..a0495a87f 100644
> --- a/Makefile.util.def
> +++ b/Makefile.util.def
> @@ -54,7 +54,7 @@ library = {
>  library = {
>    name = libgrubmods.a;
>    cflags = '-fno-builtin -Wno-undef';
> -  cppflags = '-I$(top_srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -DMINILZO_HAVE_CONFIG_H';
> +  cppflags = '-I$(srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -I$(srcdir)/grub-core/lib/zstd -DMINILZO_HAVE_CONFIG_H';
>
>    common_nodist = grub_script.tab.c;
>    common_nodist = grub_script.yy.c;
> @@ -165,6 +165,15 @@ library = {
>    common = grub-core/lib/xzembed/xz_dec_bcj.c;
>    common = grub-core/lib/xzembed/xz_dec_lzma2.c;
>    common = grub-core/lib/xzembed/xz_dec_stream.c;
> +  common = grub-core/lib/zstd/debug.c;
> +  common = grub-core/lib/zstd/entropy_common.c;
> +  common = grub-core/lib/zstd/error_private.c;
> +  common = grub-core/lib/zstd/fse_decompress.c;
> +  common = grub-core/lib/zstd/huf_decompress.c;
> +  common = grub-core/lib/zstd/module.c;
> +  common = grub-core/lib/zstd/xxhash.c;
> +  common = grub-core/lib/zstd/zstd_common.c;
> +  common = grub-core/lib/zstd/zstd_decompress.c;
>  };
>
>  program = {
> diff --git a/grub-core/Makefile.core.def b/grub-core/Makefile.core.def
> index 829e7bb57..2d75c4daf 100644
> --- a/grub-core/Makefile.core.def
> +++ b/grub-core/Makefile.core.def
> @@ -1291,7 +1291,7 @@ module = {
>    common = fs/btrfs.c;
>    common = lib/crc.c;
>    cflags = '$(CFLAGS_POSIX) -Wno-undef';
> -  cppflags = '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -DMINILZO_HAVE_CONFIG_H';
> +  cppflags = '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -I$(srcdir)/lib/zstd -DMINILZO_HAVE_CONFIG_H';
>  };
>
>  module = {
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index cac9ef588..59198f17a 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -17,6 +17,8 @@
>   *  along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
>   */
>
> +#define ZSTD_STATIC_LINKING_ONLY

Hmmm... AIUI this disables some external references but the name of
constant is confusing. Could you add a comment before it? Just what
it does here.

> +
>  #include <grub/err.h>
>  #include <grub/file.h>
>  #include <grub/mm.h>
> @@ -27,6 +29,7 @@
>  #include <grub/lib/crc.h>
>  #include <grub/deflate.h>
>  #include <minilzo.h>
> +#include <zstd.h>
>  #include <grub/i18n.h>
>  #include <grub/btrfs.h>
>  #include <grub/crypto.h>
> @@ -47,6 +50,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  #define GRUB_BTRFS_LZO_BLOCK_MAX_CSIZE (GRUB_BTRFS_LZO_BLOCK_SIZE + \
>  				     (GRUB_BTRFS_LZO_BLOCK_SIZE / 16) + 64 + 3)
>
> +#define ZSTD_BTRFS_MAX_WINDOWLOG 17
> +#define ZSTD_BTRFS_MAX_INPUT     (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
> +
>  typedef grub_uint8_t grub_btrfs_checksum_t[0x20];
>  typedef grub_uint16_t grub_btrfs_uuid_t[8];
>
> @@ -217,6 +223,7 @@ struct grub_btrfs_extent_data
>  #define GRUB_BTRFS_COMPRESSION_NONE 0
>  #define GRUB_BTRFS_COMPRESSION_ZLIB 1
>  #define GRUB_BTRFS_COMPRESSION_LZO  2
> +#define GRUB_BTRFS_COMPRESSION_ZSTD 3
>
>  #define GRUB_BTRFS_OBJECT_ID_CHUNK 0x100
>
> @@ -1216,6 +1223,91 @@ grub_btrfs_read_inode (struct grub_btrfs_data *data,
>    return grub_btrfs_read_logical (data, elemaddr, inode, sizeof (*inode), 0);
>  }
>
> +static void* grub_zstd_malloc (void* state __attribute__((unused)), size_t size)
> +{
> +	return grub_malloc (size);

Four spaces instead of tab.

> +}
> +
> +static void grub_zstd_free (void* state __attribute__((unused)), void* address)
> +{
> +	return grub_free (address);

Ditto.

> +}
> +
> +static ZSTD_customMem grub_zstd_allocator (void)
> +{
> +	ZSTD_customMem allocator;
> +
> +	allocator.customAlloc = &grub_zstd_malloc;
> +	allocator.customFree = &grub_zstd_free;
> +	allocator.opaque = NULL;
> +
> +	return allocator;

Like above and below... Leading tabs can be used if there are more than 8 spaces.

> +}
> +
> +static grub_ssize_t
> +grub_btrfs_zstd_decompress (char *ibuf, grub_size_t isize, grub_off_t off,
> +			    char *obuf, grub_size_t osize)
> +{
> +	void *allocated = NULL;
> +	char *otmpbuf = obuf;
> +	grub_size_t otmpsize = osize;
> +	ZSTD_DCtx *dctx = NULL;
> +	grub_size_t zstd_ret;
> +	grub_ssize_t ret = -1;
> +
> +	/*
> +	 * Zstd will fail if it can't fit the entire output in the destination
> +	 * buffer, so if osize isn't large enough, allocate a temporary buffer.
> +	 */

Except leading tabs comments are good.

> +	if (otmpsize < ZSTD_BTRFS_MAX_INPUT) {

Curly bracket is in wrong place.

> +		allocated = grub_malloc (ZSTD_BTRFS_MAX_INPUT);
> +		if (!allocated) {

Ditto.

> +			grub_error (GRUB_ERR_OUT_OF_MEMORY, "failed to allocate a zstd buffer");
> +			goto err;
> +		}

Ditto.

> +		otmpbuf = (char*)allocated;
> +		otmpsize = ZSTD_BTRFS_MAX_INPUT;
> +	}

Ditto and below...

> +	/* Create the ZSTD_DCtx. */
> +	dctx = ZSTD_createDCtx_advanced (grub_zstd_allocator ());
> +	if (!dctx) {
> +		/* ZSTD_createDCtx_advanced() only fails if it is out of memory. */
> +		grub_error (GRUB_ERR_OUT_OF_MEMORY, "failed to create a zstd context");
> +		goto err;
> +	}
> +
> +	/*
> +	 * Get the real input size, there may be junk at the
> +	 * end of the frame.
> +	 */
> +	isize = ZSTD_findFrameCompressedSize (ibuf, isize);
> +	if (ZSTD_isError (isize)) {
> +		grub_error (GRUB_ERR_BAD_COMPRESSED_DATA, "zstd data corrupted");
> +		goto err;
> +	}
> +
> +	/* Decompress and check for errors. */
> +	zstd_ret = ZSTD_decompressDCtx (dctx, otmpbuf, otmpsize, ibuf, isize);
> +	if (ZSTD_isError (zstd_ret)) {
> +		grub_error (GRUB_ERR_BAD_COMPRESSED_DATA, "zstd data corrupted");
> +		goto err;
> +	}
> +
> +	/*
> +	 * Move the requested data into the obuf. obuf may be equal
> +	 * to otmpbuf, which is why grub_memmove() is required.
> +	 */
> +	grub_memmove (obuf, otmpbuf + off, osize);
> +	ret = osize;
> +
> +err:
> +	grub_free (allocated);
> +	ZSTD_freeDCtx (dctx);
> +
> +	return ret;
> +}
> +
>  static grub_ssize_t
>  grub_btrfs_lzo_decompress(char *ibuf, grub_size_t isize, grub_off_t off,
>  			  char *obuf, grub_size_t osize)
> @@ -1391,7 +1483,8 @@ grub_btrfs_extent_read (struct grub_btrfs_data *data,
>
>        if (data->extent->compression != GRUB_BTRFS_COMPRESSION_NONE
>  	  && data->extent->compression != GRUB_BTRFS_COMPRESSION_ZLIB
> -	  && data->extent->compression != GRUB_BTRFS_COMPRESSION_LZO)
> +	  && data->extent->compression != GRUB_BTRFS_COMPRESSION_LZO
> +	  && data->extent->compression != GRUB_BTRFS_COMPRESSION_ZSTD)
>  	{
>  	  grub_error (GRUB_ERR_NOT_IMPLEMENTED_YET,
>  		      "compression type 0x%x not supported",
> @@ -1431,6 +1524,15 @@ grub_btrfs_extent_read (struct grub_btrfs_data *data,
>  		  != (grub_ssize_t) csize)
>  		return -1;
>  	    }
> +	  else if (data->extent->compression == GRUB_BTRFS_COMPRESSION_ZSTD)
> +	    {

...and here it is OK.

> +	      if (grub_btrfs_zstd_decompress(data->extent->inl, data->extsize -
> +					     ((grub_uint8_t *) data->extent->inl
> +					      - (grub_uint8_t *) data->extent),
> +					     extoff, buf, csize)
> +		  != (grub_ssize_t) csize)
> +		return -1;
> +	    }

Same here.

Daniel
