Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913B0C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 13:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633AE2083D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 13:44:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 633AE2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388344AbeKFXJp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:09:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:33030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388029AbeKFXJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 18:09:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74CF0B639;
        Tue,  6 Nov 2018 13:44:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 965EEDAE2D; Tue,  6 Nov 2018 14:44:12 +0100 (CET)
Date:   Tue, 6 Nov 2018 14:44:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/7] btrfs: test balance and resize with an active swap
 file
Message-ID: <20181106134411.GB24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        fstests@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <cover.1541193856.git.osandov@fb.com>
 <e6656ec218c973d548803ed50a45c8d3f81fe388.1541193856.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6656ec218c973d548803ed50a45c8d3f81fe388.1541193856.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 02, 2018 at 02:29:42PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Make sure we don't shrink the device past an active swap file, but allow
> shrinking otherwise, as well as growing and balance.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  tests/btrfs/177     | 64 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/177.out |  6 +++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/btrfs/177
>  create mode 100644 tests/btrfs/177.out
> 
> diff --git a/tests/btrfs/177 b/tests/btrfs/177
> new file mode 100755
> index 00000000..12dad8fc
> --- /dev/null
> +++ b/tests/btrfs/177
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Facebook.  All Rights Reserved.
> +#
> +# FS QA Test 177
> +#
> +# Test relocation (balance and resize) with an active swap file.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +. ./common/btrfs
> +
> +rm -f $seqres.full
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_swapfile
> +
> +swapfile="$SCRATCH_MNT/swap"
> +
> +# First, create a 1GB filesystem and fill it up.
> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) >> $seqres.full 2>&1
> +_scratch_mount
> +dd if=/dev/zero of="$SCRATCH_MNT/fill" bs=1024k >> $seqres.full 2>&1

Can this be replaced by fallocate? Though it's just a 1GiB of data, it
still takes some seconds on rotational storage.
