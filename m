Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD9FE95A6B
	for <linux-btrfs@archiver.kernel.org>; Sat,  7 Oct 2023 21:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344187AbjJGVGA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 7 Oct 2023 17:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344165AbjJGVF7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Oct 2023 17:05:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1697793;
        Sat,  7 Oct 2023 14:05:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44379C433C8;
        Sat,  7 Oct 2023 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696712758;
        bh=raul4EaUteAXCpippFc6UcG0VYsz5uREbWR8i2YhMbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BnzvqjhcfzscVHEozhwWP0zCP0MwhSH+Kx7gkkj1MnVQanCh6joXZ71pv9IdnE9h8
         QhLK44W8X+Dzl0Y8iKKhhS4bfigsUih23JsRRkKrFA6WM8Kup6hm5YKxTwg86V8Xri
         RDANPxtT5hKt1Dpq+sQhGK6HZnC0Ns1XdAwiwBE+hZvbcrTgB/UOxlCJjboBM88FCo
         icmLhIh+NZXQA/UOQidH92F0to+WMpb+zt6jqg31q6j9jJQo46MEErUyw7L/YjOdgm
         quuR2sybQqRwVhs1OFFoQy4WXqOID7yV7YTIn4uWnwAgbgMLwlt20nw+mxbgR3jE6V
         MVjbYgYlVxVKA==
Date:   Sat, 7 Oct 2023 14:05:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nick Terrell <terrelln@fb.com>
Cc:     syzbot <syzbot+1f2eb3e8cd123ffce499@syzkaller.appspotmail.com>,
        clm@fb.com, dsterba@suse.com, josef@toxicpanda.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        terrelln@fb.com, linux-hardening@vger.kernel.org
Subject: Re: [syzbot] [zstd] UBSAN: array-index-out-of-bounds in
 FSE_decompress_wksp_body_bmi2
Message-ID: <20231007210556.GA174883@sol.localdomain>
References: <00000000000049964e06041f2cbf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000049964e06041f2cbf@google.com>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nick,

On Wed, Aug 30, 2023 at 12:49:53AM -0700, syzbot wrote:
> UBSAN: array-index-out-of-bounds in lib/zstd/common/fse_decompress.c:345:30
> index 33 is out of range for type 'FSE_DTable[1]' (aka 'unsigned int[1]')

Zstandard needs to be converted to use C99 flex-arrays instead of length-1
arrays.  https://github.com/facebook/zstd/pull/3785 would fix this in upstream
Zstandard, though it doesn't work well with the fact that upstream Zstandard
supports C90.  Not sure how you want to handle this.

- Eric
