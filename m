Return-Path: <SRS0=iRg2=DB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FDDC4346E
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B05F20702
	for <linux-btrfs@archiver.kernel.org>; Thu, 24 Sep 2020 06:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgIXGRZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 02:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIXGRY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Sep 2020 02:17:24 -0400
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58DBC0613CE
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2020 23:17:24 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id B03AF156C30;
        Thu, 24 Sep 2020 08:17:22 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH] btrfs: fix false alert caused by legacy btrfs root item
Date:   Thu, 24 Sep 2020 08:17:20 +0200
Message-ID: <4917690.704LjFaxuO@merkaba>
In-Reply-To: <24c90ac7-a129-a20d-19fd-73fddc2fd73c@gmx.com>
References: <20200922023701.32654-1-wqu@suse.com> <1952994.EpAzVLkqvi@merkaba> <24c90ac7-a129-a20d-19fd-73fddc2fd73c@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Qu Wenruo - 24.09.20, 02:07:01 CEST:
> > If you like I can test with unpatched kernel whether warning goes
> > away, but I bet it may not be needed.
> 
> It should be safe now.

Thanks!

-- 
Martin


