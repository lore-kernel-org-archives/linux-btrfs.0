Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C1AC00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 09:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0E372086D
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 09:18:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0E372086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbeJHQ3V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:29:21 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39737 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726123AbeJHQ3U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 12:29:20 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45780200"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 08 Oct 2018 17:18:34 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 6973E4B6AE19;
        Mon,  8 Oct 2018 17:18:32 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 8 Oct 2018 17:18:35 +0800
Subject: Re: [PATCH 5/5] btrfs-progs: fsck-tests: Add test image for dev
 extents beyond device boundary
To:     Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20181008070025.27035-1-wqu@suse.com>
 <20181008070025.27035-6-wqu@suse.com>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <ec265886-3db6-60d4-1fe2-db46e9d5698d@cn.fujitsu.com>
Date:   Mon, 8 Oct 2018 17:25:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181008070025.27035-6-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 6973E4B6AE19.AB9FF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/8/18 3:00 PM, Qu Wenruo wrote:
> Now two locations can detect such problem, either by device item
> used/total bytes check, or by early dev extents check against device
> boundary.
> 
> The image is hand-crafted image which uses DATA SINGLE chunk to feed
> btrfs check.
> As expected, as long as block group item, chunk item, device used bytes
> matches, older btrfs check can't detect such problem.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   .../over_dev_boundary.img.xz                  | Bin 0 -> 1640 bytes
>   tests/fsck-tests/036-bad-dev-extents/test.sh  |  19 ++++++++++++++++++
>   2 files changed, 19 insertions(+)
>   create mode 100644 tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz
>   create mode 100755 tests/fsck-tests/036-bad-dev-extents/test.sh
> 
> diff --git a/tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz b/tests/fsck-tests/036-bad-dev-extents/over_dev_boundary.img.xz
> new file mode 100644
> index 0000000000000000000000000000000000000000..47cb2a707b0097e369dc088ed0549f847995f136
> GIT binary patch
> literal 1640
> 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
> 
> literal 0
> HcmV?d00001
> 
> diff --git a/tests/fsck-tests/036-bad-dev-extents/test.sh b/tests/fsck-tests/036-bad-dev-extents/test.sh
> new file mode 100755
> index 000000000000..d2a82a65f631
> --- /dev/null
> +++ b/tests/fsck-tests/036-bad-dev-extents/test.sh
> @@ -0,0 +1,19 @@
> +#!/bin/bash
> +#
> +# Due to DUP chunk allocator bugs, we could allocate DUP chunks while its dev
> +# extents could exist beyond device boundary.
> +# And since all related items (block group, chunk, device used bytes) are all
> +# valid, btrfs check won't report any error.
> +#
> +# This test case contain hand crafted minimal image, to test if btrfs check can
> +# detect and report such error.
> +
> +source "$TEST_TOP/common"
> +
> +check_prereq btrfs
> +
> +check_image() {
> +	run_check "$TOP/btrfs" check "$1"
I checked to your branch and ran test but failed.
Should it be run_must_fail instead?
> +}
> +
> +check_all_images
> 


