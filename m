Return-Path: <SRS0=Bqu+=B3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2F8C433E1
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 14:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D21B20716
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Aug 2020 14:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgHQOYm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 10:24:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:53570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbgHQOYl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Aug 2020 10:24:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2340AB8B;
        Mon, 17 Aug 2020 14:25:04 +0000 (UTC)
Message-ID: <b95d7ef12ae4725abf33dfbed5cd4273f90dcd1e.camel@suse.de>
Subject: Re: [PATCH 3/3] btrfs/174: Adjust error message when setting
 compressed flag
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Nikolay Borisov <nborisov@suse.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Date:   Mon, 17 Aug 2020 11:24:34 -0300
In-Reply-To: <20200817103718.10239-3-nborisov@suse.com>
References: <20200817103718.10239-1-nborisov@suse.com>
         <20200817103718.10239-3-nborisov@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 2020-08-17 at 13:37 +0300, Nikolay Borisov wrote:
> Following kernel commit "btrfs: add missing check for nocow and
> compression inode flags" btrfs refuses setting +c on +C files during
> validation of the args. Account for this by adjusting the expected
> error message.

LGTM, so

Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>

> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  tests/btrfs/174     | 2 +-
>  tests/btrfs/174.out | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/btrfs/174 b/tests/btrfs/174
> index af3352212170..bca1dc5c0b3b 100755
> --- a/tests/btrfs/174
> +++ b/tests/btrfs/174
> @@ -47,7 +47,7 @@ $LSATTR_PROG -l "$swapfile" | _filter_scratch |
> _filter_spaces
>  
>  # Compression we reject outright.
>  echo "Enable compression"
> -$CHATTR_PROG +c "$swapfile" 2>&1 | grep -o "Text file busy"
> +$CHATTR_PROG +c "$swapfile" 2>&1 | grep -o "Invalid argument while
> setting flags"
>  $LSATTR_PROG -l "$swapfile" | _filter_scratch | _filter_spaces
>  
>  echo "Snapshot"
> diff --git a/tests/btrfs/174.out b/tests/btrfs/174.out
> index bc24f1fb8be3..15bdf79e7bfb 100644
> --- a/tests/btrfs/174.out
> +++ b/tests/btrfs/174.out
> @@ -2,7 +2,7 @@ QA output created by 174
>  Disable nocow
>  SCRATCH_MNT/swapvol/swap No_COW
>  Enable compression
> -Text file busy
> +Invalid argument while setting flags
>  SCRATCH_MNT/swapvol/swap No_COW
>  Snapshot
>  Text file busy

