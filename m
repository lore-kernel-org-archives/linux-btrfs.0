Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC05FC64E8A
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Nov 2020 15:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92316206F9
	for <linux-btrfs@archiver.kernel.org>; Mon, 30 Nov 2020 15:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbgK3PR7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 30 Nov 2020 10:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3PR7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Nov 2020 10:17:59 -0500
X-Greylist: delayed 959 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Nov 2020 07:17:19 PST
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690E7C0613D2
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2020 07:17:19 -0800 (PST)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id B0168874;
        Mon, 30 Nov 2020 15:17:17 +0000 (UTC)
Date:   Mon, 30 Nov 2020 20:17:17 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: do not allow -o compress-force to override
 per-inode settings
Message-ID: <20201130201717.49ec8031@natsu>
In-Reply-To: <df787c30-8a5e-0256-a4c9-baa3e3556a39@toxicpanda.com>
References: <a3cd057e747862eb7027ac6318bd26c6c36e0c49.1606743972.git.josef@toxicpanda.com>
        <20201130190805.48779810@natsu>
        <b92d0141-f68f-ce96-8099-e145ebc6f594@toxicpanda.com>
        <20201130200116.79a710fe@natsu>
        <df787c30-8a5e-0256-a4c9-baa3e3556a39@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 30 Nov 2020 10:10:42 -0500
Josef Bacik <josef@toxicpanda.com> wrote:

> Right, but if we have compress-force we don't set NOCOMPRESS if the compression 
> is bad, so theoretically we shouldn't ever really have that problem?

It is persistent on disk, so remounting or mounting next time with
compress-force would now skip compression for those files which were deemed
having a bad compression ratio at some point in the past.

-- 
With respect,
Roman
