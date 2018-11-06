Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4635DC46464
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A79920869
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 15:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A79920869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbeKGAca (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 19:32:30 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:35049 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbeKGAca (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 19:32:30 -0500
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1878691AbeKFPGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 16:06:34 +0100
Date:   Tue, 6 Nov 2018 16:06:34 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH v4 2/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181106150634.GB9907@router-fw-old.i.net-space.pl>
References: <20181031175617.230241-1-terrelln@fb.com> <20181031175617.230241-3-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031175617.230241-3-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 10:56:17AM -0700, Nick Terrell wrote:
> Adds zstd support to the btrfs module.
>
> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zstd
> compression. A test case was also added to the test suite that fails before
> the patch, and passes after.
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
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
>  Makefile.util.def            |  10 +++-
>  grub-core/Makefile.core.def  |   2 +-
>  grub-core/fs/btrfs.c         | 108 ++++++++++++++++++++++++++++++++++-
>  tests/btrfs_test.in          |   1 +
>  tests/util/grub-fs-tester.in |   2 +-
>  5 files changed, 119 insertions(+), 4 deletions(-)
>
> diff --git a/Makefile.util.def b/Makefile.util.def
> index 9ae45f351..3ce9388ae 100644
> --- a/Makefile.util.def
> +++ b/Makefile.util.def
> @@ -54,7 +54,7 @@ library = {
>  library = {
>    name = libgrubmods.a;
>    cflags = '-fno-builtin -Wno-undef';
> -  cppflags = '-I$(top_srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -DMINILZO_HAVE_CONFIG_H';
> +  cppflags = '-I$(srcdir)/grub-core/lib/minilzo -I$(srcdir)/grub-core/lib/xzembed -I$(srcdir)/grub-core/lib/zstd -DMINILZO_HAVE_CONFIG_H';

I am not strongly against s/top_srcdir/srcdir/ here. However, if you do
such things I will ask you to add a blurb why to the commit message.

[...]

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
> +	if (otmpsize < ZSTD_BTRFS_MAX_INPUT) {
> +		allocated = grub_malloc (ZSTD_BTRFS_MAX_INPUT);
> +		if (!allocated) {
> +			goto err;

Hmmm... You fail silently. Should not you say something here?

> +		}

If above is OK then drop this curly brackets.

> +		otmpbuf = (char*)allocated;
> +		otmpsize = ZSTD_BTRFS_MAX_INPUT;
> +	}
> +
> +	/* Create the ZSTD_DCtx. */
> +	dctx = ZSTD_createDCtx_advanced (grub_zstd_allocator ());
> +	if (!dctx) {
> +		grub_error (GRUB_ERR_OUT_OF_MEMORY, "zstd out of memory");

...and here you complain. OK, but why GRUB_ERR_OUT_OF_MEMORY?
This probably applies to grub_zstd_allocator() but maybe not to
ZSTD_createDCtx_advanced(). AIUI both functions may return
different errors.

Daniel
