Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33778C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 14:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25E22081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 14:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C25E22081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388766AbeKGAO2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 19:14:28 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:35005 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388428AbeKGAO2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 19:14:28 -0500
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1878631AbeKFOsc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 15:48:32 +0100
Date:   Tue, 6 Nov 2018 15:48:32 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH v4 1/2] Import upstream zstd-1.3.6
Message-ID: <20181106144832.GA9907@router-fw-old.i.net-space.pl>
References: <20181031175617.230241-1-terrelln@fb.com> <20181031175617.230241-2-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031175617.230241-2-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 31, 2018 at 10:56:16AM -0700, Nick Terrell wrote:
> Import zstd-1.3.6 from upstream [1]. Only the files need for decompression
> are imported. Additionally makes zstd a module by adding module.c which
> contains the license, and updates Makefile.core.def.
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
> ```
> #!/bin/sh -e
>
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
> ```
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>

I have a few concerns. First of all I can see that you include a lot of
standard headers, e.g. stdlib.h, string.h, stddef.h, etc. Where do they
come from? OS? If yes that is wrong. Additionally, I think that you
should not use standard types, e.g. size_t, because this may not work if
you cross compile. You have to use, e.g. grub_size_t. IMO the simplest
solution would be definition and usage of relevant zstd_* types, e.g.
zstd_size_t. Then e.g. zstd_size_t should be defined as grub_size_t.

[...]

> diff --git a/grub-core/lib/zstd/module.c b/grub-core/lib/zstd/module.c
> new file mode 100644
> index 000000000..e4d0cace8
> --- /dev/null
> +++ b/grub-core/lib/zstd/module.c
> @@ -0,0 +1,3 @@

Could you copy the header e.g. from grub-core/loader/multiboot_mbi2.c?
Of course you have to update the dates accordingly.

> +#include <grub/dl.h>
> +
> +GRUB_MOD_LICENSE ("GPLv3");

Daniel
