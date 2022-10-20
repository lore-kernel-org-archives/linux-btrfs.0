Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BFFC433FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Oct 2022 11:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJTLBz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Oct 2022 07:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiJTLBx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2022 07:01:53 -0400
Received: from manchmal.in-ulm.de (manchmal.in-ulm.de [217.10.9.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986DD1CB50C
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Oct 2022 04:01:51 -0700 (PDT)
Date:   Thu, 20 Oct 2022 13:01:48 +0200
From:   Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
To:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Endless "reclaiming chunk"/"relocating block group"
Message-ID: <1666262200@msgid.manchmal.in-ulm.de>
References: <1666204197@msgid.manchmal.in-ulm.de>
 <Y1Crh/Cz2rcbIayw@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Crh/Cz2rcbIayw@hungrycats.org>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for add the toughts shared ...

Zygo Blaxell wrote...

(...)
> It makes me think of possible rounding errors (e.g. the threshold
> calculation divides by 100, or there's a sum of quantities that leads
> to a percentage > 100, but the code treats zero as a special case and
> bails out long before, so I don't see how we'd reach those corner cases.

Out of desperation, I followed an approach I could read between the lines
here. The thing I did not mention (just because I forgot about it) is
the compiler version used to build the kernel. For reasons, this is
still a gcc-5 (5.4.0, to be precise). After a rebuild using gcc-11,
things are nice and smooth.

Now I cannot deny I'm quite confused. Assuming this is really the cause,
how should I go from here? I can patch the sources at will, but it's a
huge amount of code, and I don't even know where is start. Also from
expericence, debug print statements do bar the optimizer from creating
the problematic instructions.

    Christoph

FWIW, according to Documentation/process/changes.rst, that old gcc-5 is
considered sufficient. I didn't expect that :)
