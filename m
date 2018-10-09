Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2967AECDFDF
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD57213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFD57213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbeJJCgE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:36:04 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52031 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbeJJCgD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 22:36:03 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874706AbeJITHx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 21:07:53 +0200
Date:   Tue, 9 Oct 2018 21:07:53 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH v2 2/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181009190753.GF11162@router-fw-old.i.net-space.pl>
References: <20181008230621.2185884-1-terrelln@fb.com> <20181008230621.2185884-3-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008230621.2185884-3-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 08, 2018 at 04:06:21PM -0700, Nick Terrell wrote:
> Adds zstd support to the btrfs module. I'm not sure that my changes to the
> Makefiles are correct, please let me know if I need to do something
> differently.
>
> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zstd
> compression. A test case was also added to the test suite that fails before
> the patch, and passes after.
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
> v1 -> v2:
> - Fix comments from Daniel Kiper
>
>  Makefile.util.def            |  10 +++-
>  grub-core/Makefile.core.def  |  10 +++-
>  grub-core/fs/btrfs.c         | 105 ++++++++++++++++++++++++++++++++++-
>  grub-core/lib/zstd/up        |   1 -

Please do not take this file into patch #1.

>  tests/btrfs_test.in          |   1 +
>  tests/util/grub-fs-tester.in |   2 +-
>  6 files changed, 124 insertions(+), 5 deletions(-)
>  delete mode 120000 grub-core/lib/zstd/up
>
> diff --git a/Makefile.util.def b/Makefile.util.def
> index f9caccb97..81898c509 100644
> --- a/Makefile.util.def
> +++ b/Makefile.util.def
> @@ -54,7 +54,7 @@ library = {
>  library = {
>    name = libgrubmods.a;
>    cflags = '-fno-builtin -Wno-undef';
> -  cppflags = '-I$(top_srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -DMINILZO_HAVE_CONFIG_H';
> +  cppflags = '-I$(top_srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -I$(top_srcdir)/grub-core/lib/zstd -DMINILZO_HAVE_CONFIG_H';

s/top_srcdir/srcdir/?

>    common_nodist = grub_script.tab.c;
>    common_nodist = grub_script.yy.c;
> @@ -164,6 +164,14 @@ library = {
>    common = grub-core/lib/xzembed/xz_dec_bcj.c;
>    common = grub-core/lib/xzembed/xz_dec_lzma2.c;
>    common = grub-core/lib/xzembed/xz_dec_stream.c;
> +  common = grub-core/lib/zstd/debug.c;
> +  common = grub-core/lib/zstd/entropy_common.c;
> +  common = grub-core/lib/zstd/error_private.c;
> +  common = grub-core/lib/zstd/fse_decompress.c;
> +  common = grub-core/lib/zstd/xxhash.c;
> +  common = grub-core/lib/zstd/zstd_common.c;
> +  common = grub-core/lib/zstd/huf_decompress.c;
> +  common = grub-core/lib/zstd/zstd_decompress.c;
>  };
>
>  program = {
> diff --git a/grub-core/Makefile.core.def b/grub-core/Makefile.core.def
> index 2c1d62cee..2a97bb807 100644
> --- a/grub-core/Makefile.core.def
> +++ b/grub-core/Makefile.core.def
> @@ -1265,8 +1265,16 @@ module = {
>    name = btrfs;
>    common = fs/btrfs.c;
>    common = lib/crc.c;
> +  common = lib/zstd/debug.c;
> +  common = lib/zstd/entropy_common.c;
> +  common = lib/zstd/error_private.c;
> +  common = lib/zstd/fse_decompress.c;
> +  common = lib/zstd/xxhash.c;
> +  common = lib/zstd/zstd_common.c;
> +  common = lib/zstd/huf_decompress.c;
> +  common = lib/zstd/zstd_decompress.c;

Could you sort the names of files here?

>    cflags = '$(CFLAGS_POSIX) -Wno-undef';
> -  cppflags = '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -DMINILZO_HAVE_CONFIG_H';
> +  cppflags = '-I$(srcdir)/lib/posix_wrap -I$(srcdir)/lib/minilzo -I$(srcdir)/lib/zstd -DMINILZO_HAVE_CONFIG_H';
>  };
>
>  module = {
> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
> index 4849c1ceb..cfeb7995e 100644
> --- a/grub-core/fs/btrfs.c
> +++ b/grub-core/fs/btrfs.c
> @@ -17,6 +17,8 @@
>   *  along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
>   */
>
> +#define ZSTD_STATIC_LINKING_ONLY
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
>
> @@ -45,6 +48,9 @@ GRUB_MOD_LICENSE ("GPLv3+");
>  #define GRUB_BTRFS_LZO_BLOCK_MAX_CSIZE (GRUB_BTRFS_LZO_BLOCK_SIZE + \
>  				     (GRUB_BTRFS_LZO_BLOCK_SIZE / 16) + 64 + 3)
>
> +#define ZSTD_BTRFS_MAX_WINDOWLOG 17
> +#define ZSTD_BTRFS_MAX_INPUT     (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
> +
>  typedef grub_uint8_t grub_btrfs_checksum_t[0x20];
>  typedef grub_uint16_t grub_btrfs_uuid_t[8];
>
> @@ -212,6 +218,7 @@ struct grub_btrfs_extent_data
>  #define GRUB_BTRFS_COMPRESSION_NONE 0
>  #define GRUB_BTRFS_COMPRESSION_ZLIB 1
>  #define GRUB_BTRFS_COMPRESSION_LZO  2
> +#define GRUB_BTRFS_COMPRESSION_ZSTD 3
>
>  #define GRUB_BTRFS_OBJECT_ID_CHUNK 0x100
>
> @@ -912,6 +919,88 @@ grub_btrfs_read_inode (struct grub_btrfs_data *data,
>    return grub_btrfs_read_logical (data, elemaddr, inode, sizeof (*inode), 0);
>  }
>
> +static void* grub_zstd_malloc (void* state, size_t size)
> +{
> +	(void)state;

Do we need that?

> +	return grub_malloc (size);
> +}
> +
> +static void grub_zstd_free (void* state, void* address)
> +{
> +	(void)state;

Ditto?

> +	return grub_free (address);
> +}
> +
> +static ZSTD_customMem grub_zstd_allocator (void)
> +{
> +	ZSTD_customMem allocator;

Please add empty line here.

> +	allocator.customAlloc = &grub_zstd_malloc;
> +	allocator.customFree = &grub_zstd_free;
> +	allocator.opaque = NULL;

And here.

> +	return allocator;
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
> +	/* Zstd will fail if it can't fit the entire output in the destination
> +	 * buffer, so if osize isn't large enough, allocate a temporary buffer.
> +	 */

        /*
         * Zstd will fail if it can't fit the entire output in the destination
         * buffer, so if osize isn't large enough, allocate a temporary buffer.
         */

> +	if (otmpsize < ZSTD_BTRFS_MAX_INPUT) {
> +		allocated = grub_malloc (ZSTD_BTRFS_MAX_INPUT);
> +		if (!allocated) {
> +			grub_dprintf ("zstd", "outtmpbuf allocation failed\n");
> +			goto err;
> +		}
> +		otmpbuf = (char*)allocated;
> +		otmpsize = ZSTD_BTRFS_MAX_INPUT;
> +	}
> +
> +	/* Create the ZSTD_DCtx. */
> +	dctx = ZSTD_createDCtx_advanced (grub_zstd_allocator ());
> +	if (!dctx) {
> +		grub_dprintf ("zstd", "failed to allocate the ZSTD_DCtx\n");

Should not you set grub_errno here?

> +		goto err;
> +	}
> +
> +	/* Get the real input size, there may be junk at the
> +	 * end of the frame.
> +	 */

Please reformat the comment like above.

> +	isize = ZSTD_findFrameCompressedSize (ibuf, isize);
> +	if (ZSTD_isError (isize)) {
> +		grub_dprintf ("zstd", "first frame is invalid: %s\n",
> +			      ZSTD_getErrorName (isize));

grub_errno?

> +		goto err;
> +	}
> +
> +	/* Decompress and check for errors */

This can stay as is. You can add a full stop at the end.

> +	zstd_ret = ZSTD_decompressDCtx (dctx, otmpbuf, otmpsize, ibuf, isize);
> +	if (ZSTD_isError (zstd_ret)) {
> +		grub_dprintf ("zstd", "zstd failed with message: %s\n",
> +			      ZSTD_getErrorName (zstd_ret));

grub_errno?

> +		goto err;
> +	}
> +
> +	/* Move the requested data into the obuf.
> +	 * obuf may be equal to otmpbuf, which is why grub_memmove() is required.
> +	 */

Begs for reformat.

Daniel
