Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFCF2C433DB
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Feb 2021 16:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEB164E6F
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Feb 2021 16:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhBJQWa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhBJQW2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Feb 2021 11:22:28 -0500
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B330C0613D6
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2021 08:21:47 -0800 (PST)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id A8700140B23;
        Wed, 10 Feb 2021 17:21:44 +0100 (CET)
Date:   Wed, 10 Feb 2021 17:21:44 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>, u-boot@lists.denx.de,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Tom Rini <trini@konsulko.com>
Subject: Re: [PATCH u-boot] fs: btrfs: do not fail when offset of a
 ROOT_ITEM is not -1
Message-ID: <20210210172144.5136d23e@nic.cz>
In-Reply-To: <0acf2948-3a13-a2b8-d480-7fc2af1bfb8a@suse.com>
References: <20210209173337.16621-1-marek.behun@nic.cz>
        <40e38323-0013-6799-1527-02cbac8dc93e@gmx.com>
        <20210210020549.6881d90a@nic.cz>
        <0acf2948-3a13-a2b8-d480-7fc2af1bfb8a@suse.com>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 10 Feb 2021 09:20:11 +0800
Qu Wenruo <wqu@suse.com> wrote:

> You're correct, the kernel is using new schema, btrfs_get_fs_root(), 
> which only requires root objectid and completely get rid of the 
> offset/type, which is far less possible to call with wrong parameters.
> 
> It would be a good timing to sync the code between kernel and 
> progs/u-boot now.

So do you agree with this patch? If so, can you add Reviewed-by? Thanks.
