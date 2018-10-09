Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF31ECDFDF
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B19C213A2
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 19:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B19C213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbeJJCgC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:36:02 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:52031 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeJJCgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2018 22:36:01 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874694AbeJISkM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 20:40:12 +0200
Date:   Tue, 9 Oct 2018 20:40:12 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH v2 1/2] Import upstream zstd-1.3.6
Message-ID: <20181009184012.GE11162@router-fw-old.i.net-space.pl>
References: <20181008230621.2185884-1-terrelln@fb.com> <20181008230621.2185884-2-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008230621.2185884-2-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 08, 2018 at 04:06:20PM -0700, Nick Terrell wrote:
> Import zstd-1.3.6 from upstream [1]. Only the files need for decompression
> are imported.
>
> I used the latest zstd release, which includes patches [2] to build cleanly
> in GRUB.
>
> Upstream zstd commit hash: 4fa456d7f12f8b27bd3b2f5dfd4f46898cb31c24
> Upstream zstd commit name: Merge pull request #1354 from facebook/dev
>
> I've included the script used to import zstd-1.3.6 below.
>
> [1] https://github.com/facebook/zstd/releases/tag/v1.3.6
> [2] https://github.com/facebook/zstd/pull/1344
>
> ---
> #!/bin/sh

It seems to me that "-e" is missing here. Now you will see "SUCCESS!"
even if an error occurs.

> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz
> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz.sha256
> sha256sum --check zstd-1.3.6.tar.gz.sha256
> tar xzf zstd-1.3.6.tar.gz
>
> SRC_LIB="zstd-1.3.6/lib"
> DST_LIB="grub-core/lib/zstd"
> rm -rf $DST_LIB
> mkdir -p $DST_LIB
> cp $SRC_LIB/zstd.h $DST_LIB/
> cp $SRC_LIB/common/*.[hc] $DST_LIB/
> cp $SRC_LIB/decompress/*.[hc] $DST_LIB/
> rm $DST_LIB/{pool.[hc],threading.[hc]}
> rm -rf zstd-1.3.6*
> echo SUCCESS!
> ---
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>
> ---
> v1 -> v2:
> - Switch to upstream zstd-1.3.6 rather than using the kernel zstd.
>
>  grub-core/lib/zstd/bitstream.h       |  458 ++++
>  grub-core/lib/zstd/compiler.h        |  133 ++
>  grub-core/lib/zstd/cpu.h             |  215 ++
>  grub-core/lib/zstd/debug.c           |   44 +
>  grub-core/lib/zstd/debug.h           |  123 +
>  grub-core/lib/zstd/entropy_common.c  |  236 ++
>  grub-core/lib/zstd/error_private.c   |   48 +
>  grub-core/lib/zstd/error_private.h   |   76 +
>  grub-core/lib/zstd/fse.h             |  708 ++++++
>  grub-core/lib/zstd/fse_decompress.c  |  309 +++
>  grub-core/lib/zstd/huf.h             |  334 +++
>  grub-core/lib/zstd/huf_decompress.c  | 1096 +++++++++
>  grub-core/lib/zstd/mem.h             |  374 ++++
>  grub-core/lib/zstd/up                |    1 +

I do not think that we need this file.

Otherwise LGTM.

Daniel
