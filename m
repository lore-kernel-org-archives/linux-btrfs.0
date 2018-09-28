Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D222C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 12:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8134216FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 12:42:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0fpXi3C"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8134216FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbeI1TGd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 15:06:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35393 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbeI1TGd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 15:06:33 -0400
Received: by mail-pf1-f193.google.com with SMTP id p12-v6so4284442pfh.2;
        Fri, 28 Sep 2018 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vQNwm1PZceaoMFxFpEaS67MEhMRTaSI+zJ0nOSPGdVc=;
        b=i0fpXi3Cye21Q+BgfOt09DlqWUodFeH9m8wJQWtb7EOrJmQvUL1wk8+UkVAl6vj9OX
         F7oHy3EXhtdP+k7MP757Xuj822uQM+Sk4haSUVHDnLpcr1Jve+l0YnTCMJyZBvjLHrQC
         Z8tm+B9c/Tex/UHWaKkLBNrZorx7Sbv2ZL/kZCIsup+kBA+nb6PxW9ThJWHfW79VHn0u
         2nGUK3ewoMqabS4y4i7VGKEeIY5sazV5Q9SOOLxrf4vZn70PpLPW29YP6QWxuads5TwN
         WC5o2i3W4HkFVS1f4pIwksd+veMUzHtpIg35oen+mXjiODjiVkauP37tCPySiBD2fh58
         yVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vQNwm1PZceaoMFxFpEaS67MEhMRTaSI+zJ0nOSPGdVc=;
        b=ADGw7B8i3qcJmTn+9FFfToKpMiEq1FmdDxwNU4W8SydThoI3Ai0Zb6KFA9Ivlz22yR
         n3yILgA/2iTjR1cmhMlhJ7EGAk2o/EVzptG+si/x8BAZ3mSwOAc6rXJtVCVYnpFNE29m
         wuKVeVOpHJGmUB1SaLr49UvrwSDK9qBMs66qSUFeF8or4TxWCeqsFC6aJF3b2oqn8Rte
         rk955wVyRLSWGkFOJ8NhBzJRBaee+oEf2xaCLrGQDMKu0kS6g6FAaimzPwQqvrm4ppJB
         k9JLrCEzP7fgVqsBU2TK1oKsNlIlE1NBBgeTMk36NcpOszx/li4i+HV86f6Wp3ChDNty
         blDQ==
X-Gm-Message-State: ABuFfogO+yq1KWa+8Pk4pbSuKJlY5Ltk853171yPSjPTcSsQHgNdyzGX
        hSDbyjJwsSlkfIn6jGPJ/1M=
X-Google-Smtp-Source: ACcGV63ZH1SfNCc5IfVnFzj0S2iR/ipe/uBJmLbKBH5uussOaSMSKyorGZIAlgEvaPTmlVnAXceLrA==
X-Received: by 2002:a17:902:263:: with SMTP id 90-v6mr16165731plc.190.1538138575634;
        Fri, 28 Sep 2018 05:42:55 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id i184-v6sm7013439pgc.9.2018.09.28.05.42.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 05:42:54 -0700 (PDT)
Date:   Fri, 28 Sep 2018 20:42:49 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] test unaligned punch hole at ENOSPC
Message-ID: <20180928124249.GH17817@desktop>
References: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537789659-29460-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Sep 24, 2018 at 07:47:39PM +0800, Anand Jain wrote:
> Try to punch hole with unaligned size and offset when the FS
> returns ENOSPC
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> This test case fails on btrfs as of now.
> 
>  tests/btrfs/172     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/172.out |  2 ++
>  tests/btrfs/group   |  1 +
>  3 files changed, 69 insertions(+)
>  create mode 100755 tests/btrfs/172
>  create mode 100644 tests/btrfs/172.out
> 
> diff --git a/tests/btrfs/172 b/tests/btrfs/172
> new file mode 100755
> index 000000000000..9c32a173f912
> --- /dev/null
> +++ b/tests/btrfs/172
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Oracle. All Rights Reserved.
> +#
> +# FS QA Test 172
> +#
> +# Test if the unaligned (by size and offset) punch hole is successful when FS
> +# is at ENOSPC.
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
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +
> +_scratch_mkfs_sized $((200 * 1024 *1024)) >> $seqres.full
> +
> +# max_inline helps to create regular extent
> +_scratch_mount "-o max_inline=0,nodatacow"
> +
> +echo "Fill fs upto ENOSPC" >> $seqres.full
> +dd status=none if=/dev/zero of=$SCRATCH_MNT/filler bs=512 >> $seqres.full 2>&1
> +
> +extent_size=$(_scratch_btrfs_sectorsize)
> +unalign_by=512
> +echo extent_size=$extent_size unalign_by=$unalign_by >> $seqres.full
> +
> +hole_offset=0
> +hole_len=$unalign_by
> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler

Please don't introduce new run_check/_run_btrfs_util_prog users, just
redirect output to /dev/null if the outputs don't matter. Please refer
to this thread

https://www.spinics.net/lists/linux-btrfs/msg80996.html

And use xfs_io fpunch command instead of bare 'fallocate -p', and check
xfs_io and kernel support on fpunch by calling

_require_xfs_io_comand "fpunch"

> +
> +hole_offset=$(($extent_size + $unalign_by))
> +hole_len=$(($extent_size - $unalign_by))
> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
> +
> +hole_offset=$(($extent_size * 2 + $unalign_by))
> +hole_len=$(($extent_size * 5))
> +run_check fallocate -p -o $hole_offset -l $hole_len $SCRATCH_MNT/filler
> +
> +# success, all done
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/btrfs/172.out b/tests/btrfs/172.out
> new file mode 100644
> index 000000000000..ce2de3f0d107
> --- /dev/null
> +++ b/tests/btrfs/172.out
> @@ -0,0 +1,2 @@
> +QA output created by 172
> +Silence is golden
> diff --git a/tests/btrfs/group b/tests/btrfs/group
> index feffc45b6564..7e1a638ab7e1 100644
> --- a/tests/btrfs/group
> +++ b/tests/btrfs/group
> @@ -174,3 +174,4 @@
>  169 auto quick send
>  170 auto quick snapshot
>  171 auto quick qgroup
> +172 auto quick

Add 'punch' group too.

Thanks,
Eryu

> -- 
> 1.8.3.1
> 
