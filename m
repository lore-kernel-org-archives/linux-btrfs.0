Return-Path: <SRS0=0DI8=CJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C12EC433E2
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 302912068E
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Aug 2020 11:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHaLTp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 07:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgHaLR6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Aug 2020 07:17:58 -0400
X-Greylist: delayed 98 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 31 Aug 2020 04:16:53 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32088C061A03
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2020 04:16:53 -0700 (PDT)
Received: from natsu (unknown [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 7E77B405;
        Mon, 31 Aug 2020 11:15:05 +0000 (UTC)
Date:   Mon, 31 Aug 2020 16:15:05 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Hamish Moffatt <hamish-btrfs@moffatt.email>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: new database files not compressed
Message-ID: <20200831161505.369be693@natsu>
In-Reply-To: <baadab71-61a7-704e-86f7-3607895df663@moffatt.email>
References: <6992fae3-ce87-8ae1-8dfe-1cb65578a16a@moffatt.email>
        <20200831034731.GX5890@hungrycats.org>
        <baadab71-61a7-704e-86f7-3607895df663@moffatt.email>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 31 Aug 2020 18:53:54 +1000
Hamish Moffatt <hamish-btrfs@moffatt.email> wrote:

> $ sudo mount -O compress-force=zstd /dev/sdb /mnt/test

Specifying the filesystem mount options is done with -o, not -O.
See "man mount".


-- 
With respect,
Roman
