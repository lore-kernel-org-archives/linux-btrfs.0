Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22214C433FE
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Apr 2022 05:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349047AbiDOFJX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351079AbiDOFF1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Apr 2022 01:05:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DA7BE9C7;
        Thu, 14 Apr 2022 21:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55CCFB82C28;
        Fri, 15 Apr 2022 04:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63D2C385A6;
        Fri, 15 Apr 2022 04:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649998632;
        bh=sdf3KNK2bCPLRKBu/jbG05O+vAvWO2dlRW++18iqkWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yvgRgIJ/EZ6dXfJiAClGq2iKMGVu4cGaeM/SFONhtbI5bvkcjb/7i7oKBSmmQa9cv
         +NjKml8zX249PhAmTJ5Jnc87fv5ivODJ4zVVpPFR9DNgmRnTYOzlEuiyrvCVCbrOu7
         YHfKOZXN69H6QJQ9ETNNlzsaLOO12ASlRFtY7OHk=
Date:   Fri, 15 Apr 2022 06:57:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs warning fixes for 5.15 and 5.17
Message-ID: <Ylj7JclrqzHx2gpQ@kroah.com>
References: <YliEOSL8z3/s7DGG@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YliEOSL8z3/s7DGG@dev-arch.thelio-3990X>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 14, 2022 at 01:29:45PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Please apply
> 
> ad3fc7946b18 ("btrfs: remove no longer used counter when reading data page")
> 6d4a6b515c39 ("btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()")
> 
> to 5.15 and 5.17 and
> 
> cd9255be6980 ("btrfs: remove unused parameter nr_pages in add_ra_bio_pages()")
> 
> to 5.15 (it landed in 5.16), as they all resolve build errors with
> CONFIG_WERROR=y and tip of tree clang, which recently added support for
> unary operations in -Wunused-but-set-variable. They all apply cleanly
> and I do not see any additional build warnings and errors.
> 
> Commit 6d4a6b515c39 was specifically tagged for stable back to 5.4,
> which should be fine, but it really only needs to go back to 5.12+, as
> btrfs turned on W=1 (which includes this warning) for itself in commit
> e9aa7c285d20 ("btrfs: enable W=1 checks for btrfs"), which landed in
> 5.12-rc1. Prior that that change, none of these warnings will be
> visible under a normal build.

Now queued up, thanks.

greg k-h
