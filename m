Return-Path: <SRS0=bPhb=7G=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43919C433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 May 2020 06:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19C4A2075F
	for <linux-btrfs@archiver.kernel.org>; Sun, 24 May 2020 06:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgEXGiG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 24 May 2020 02:38:06 -0400
Received: from bezitopo.org ([45.55.162.231]:34870 "EHLO marozi.bezitopo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgEXGiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 May 2020 02:38:05 -0400
Received: from bezitopo.org (unknown [IPv6:2001:5b0:212a:cab8:4e72:b9ff:fe7b:8dbf])
        by marozi.bezitopo.org (Postfix) with ESMTPSA id 041F75FB7E
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2020 02:38:04 -0400 (EDT)
Received: from puma.localnet (localhost [127.0.0.1])
        by bezitopo.org (Postfix) with ESMTP id E4D8630EC4
        for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2020 02:37:52 -0400 (EDT)
From:   Pierre Abbat <phma@bezitopo.org>
To:     linux-btrfs@vger.kernel.org
Subject: Re: Trying to mount hangs
Date:   Sun, 24 May 2020 02:37:52 -0400
Message-ID: <19884168.u0ROftlITR@puma>
In-Reply-To: <f49ceced-fcbf-5be7-442d-25bbfbc75881@gmx.com>
References: <2549429.Qys7a5ZjRC@puma> <2582603.WkyslYimHe@puma> <f49ceced-fcbf-5be7-442d-25bbfbc75881@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Friday, May 22, 2020 6:02:44 AM EDT Qu Wenruo wrote:
> For that purpose, we have btrfs-image, which will only dump the
> metadata, which is way smaller than the full disk, and can be further
> compressed using -c9 option. (And you can compress it furthermore).
> 
> That btrfs-image dump even contains log tree, which is exactly what we
> need to fix the hang.

I'm sending it. Let me know if you can reproduce the hang.

Pierre

-- 
gau do li'i co'e kei do



