Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7EAEB64DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jul 2023 07:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjGSHB2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 03:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjGSHBM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jul 2023 03:01:12 -0400
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAC0198
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jul 2023 00:01:10 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id CDEC6747985;
        Wed, 19 Jul 2023 09:01:08 +0200 (CEST)
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH] btrfs: scrub: speed up on NVME devices
Date:   Wed, 19 Jul 2023 09:01:08 +0200
Message-ID: <4298848.ejJDZkT8p0@lichtvoll.de>
In-Reply-To: <ef3951fa130f9b61fe097e8d5f6e425525165a28.1689330324.git.wqu@suse.com>
References: <ef3951fa130f9b61fe097e8d5f6e425525165a28.1689330324.git.wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu.

I bet this patch is intended to go into 6.4.

Qu Wenruo - 14.07.23, 12:26:40 CEST:
> For the proper fix, I'm afraid we have to utilize btrfs workqueue, let
> the initial read and repair done in an async manner, and let the
> writeback (repaired and dev-replace) happen in a synchronized manner.
> 
> This can allow us to have a very high queue depth, to claim the
> remaining 1GiB/s performance.
> 
> But I'm also not sure if we should go that hard, as we may still have
> SATA SSD/HDDs, which won't benefit at all from high queue depth.

Could workqueue be tuned to use a lower queue depth for SATA SSD/HDDs?

Best,
-- 
Martin


