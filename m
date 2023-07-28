Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA5AC0015E
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Jul 2023 12:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbjG1Miu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Jul 2023 08:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbjG1Mit (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2023 08:38:49 -0400
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89C187
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2023 05:38:48 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id 5020C75AF95;
        Fri, 28 Jul 2023 14:38:35 +0200 (CEST)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 0/5] btrfs: scrub: improve the scrub performance
Date:   Fri, 28 Jul 2023 14:38:35 +0200
Message-ID: <6543972.G0QQBjFxQf@lichtvoll.de>
In-Reply-To: <cover.1690542141.git.wqu@suse.com>
References: <cover.1690542141.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo - 28.07.23, 13:14:03 CEST:
> The first 3 patches would greately improve the scrub read performance,
> but unfortunately it's still not as fast as the pre-6.4 kernels.
> (2.2GiB/s vs 3.0GiB/s), but still much better than 6.4 kernels
> (2.2GiB vs 1.0GiB/s).

Thanks for the patch set.

What is the reason for not going back to the performance of the pre-6.4 
kernel? Isn't it possible with the new scrubbing method? In that case 
what improvements does the new scrubbing code have that warrant to have 
a lower performance?

Just like to understand the background of this a bit more. I do not mind 
a bit lower performance too much, especially in case it is outweighed by 
other benefits.

-- 
Martin


