Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD40FC7113B
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Aug 2023 07:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjHXHmb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 03:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbjHXHmA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2023 03:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A571219B4;
        Thu, 24 Aug 2023 00:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747E160E0A;
        Thu, 24 Aug 2023 07:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891AAC433C7;
        Thu, 24 Aug 2023 07:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692862858;
        bh=ssS4wDM8TMEp+tiz5ddaOpV33H5yzXwL19MBi5wuLek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GCE/nilhgAtePmIMznX735V43mtZPZ1ORNxYX1Ka1QR1R+9BJrpfYjMjiplDNDtdE
         +7nMmdwINkEWCzK1BBu+RuHyarbubuJZYL8xFQdMM1X32rVaNCVAtJ/Yanp37ava6l
         XQkESBHQW8VVo2WTMY8vPSEy9DR3IYcfTawqPAs6QMLInJ+qvmx3quaZBlFJD8uzQX
         Oqy8qVMEYJN7XspVPEVeTaD3ZhKB7y33qtMZTyEN3QY+aQ4dO44z6FJhR1cGwxyGDt
         9rXNQa5m3ITgEUrJulA5sV6OymjUOHSUSz6UljvwBCcEqX9JIYN7z8ZysJKSIgwzQa
         ENFsCfQQFYnyg==
Date:   Thu, 24 Aug 2023 08:40:56 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs/213: fix the _not_run spell
Message-ID: <ZOcJiGFIlsnD0zUx@debian0.Home>
References: <20230824064820.72147-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824064820.72147-1-wqu@suse.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Aug 24, 2023 at 02:48:20PM +0800, Qu Wenruo wrote:
> The proper function is _notrun, not _not_run.
> 
> This can cause false alerts if the write speed is too fast or has some
> cache causing the balance to finish eariler than expectation.

https://lore.kernel.org/fstests/71413edbeb1ee5b945f0b82faccaf4a75e8ba56b.1691924176.git.fdmanana@suse.com/

> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  tests/btrfs/213 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/btrfs/213 b/tests/btrfs/213
> index 5666d9b9..6def4f6e 100755
> --- a/tests/btrfs/213
> +++ b/tests/btrfs/213
> @@ -55,7 +55,7 @@ sleep $(($runtime / 4))
>  # any error about no balance currently running.
>  $BTRFS_UTIL_PROG balance cancel "$SCRATCH_MNT" 2>&1 | grep -iq 'not in progress'
>  if [ $? -eq 0 ]; then
> -	_not_run "balance finished before we could cancel it"
> +	_notrun "balance finished before we could cancel it"
>  fi
>  
>  # Now check if we can finish relocating metadata, which should finish very
> -- 
> 2.41.0
> 
