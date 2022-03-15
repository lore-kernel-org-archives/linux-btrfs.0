Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D696DC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Mar 2022 18:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348751AbiCOSW0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 14:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiCOSW0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Mar 2022 14:22:26 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1346C5A09E
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 11:21:14 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 56E2F83A45; Tue, 15 Mar 2022 14:20:43 -0400 (EDT)
References: <CAODFU0rZEy064KkSK1juHA6=r2zC4=Go8Me2V2DqHWb-AirL-Q@mail.gmail.com>
 <87tuc9q1fc.fsf@vps.thesusis.net>
 <CAODFU0py06T4Eet+i0ZAY5Zrp5174eQJOCGh_03oZdDXO55TKw@mail.gmail.com>
 <87tuc7gdzp.fsf@vps.thesusis.net>
 <CAODFU0oM02WDpOPXp1of177aEJ9=ux2QFrHZF=khhzAg+3N1dA@mail.gmail.com>
 <87ee34cnaq.fsf@vps.thesusis.net>
 <CAODFU0rXnDhQjGPyuBQ8kxUGBXzQFMkXrNXiSxmcvgaaixspvg@mail.gmail.com>
User-agent: mu4e 1.7.0; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Jan Ziak <0xe2.0x9a.0x9b@gmail.com>
Cc:     unlisted-recipients <unlisted-recipients@thesusis.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: Btrfs autodefrag wrote 5TB in one day to a 0.5TB SSD without a
 measurable benefit
Date:   Tue, 15 Mar 2022 14:15:07 -0400
In-reply-to: <CAODFU0rXnDhQjGPyuBQ8kxUGBXzQFMkXrNXiSxmcvgaaixspvg@mail.gmail.com>
Message-ID: <87k0cvnklg.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


Jan Ziak <0xe2.0x9a.0x9b@gmail.com> writes:

> However, what the manpage doesn't mention is that, in the case of
> btrfs, the above diagram applies not only to compressed extents but to
> other types of extents as well.

Ok, so if you are using compression then your choices are either to read
the entire 128k compressed block, decompress it, update the 4k,
recompress it, and write the whole thing back... or just write the
modified 4k elsewhere and now there is some wasted space in the
compressed block.

But why would something like this happen without compression?

