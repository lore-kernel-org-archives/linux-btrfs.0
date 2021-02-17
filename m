Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016B6C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Feb 2021 16:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAA8364DBD
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Feb 2021 16:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhBQQn3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Feb 2021 11:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbhBQQn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Feb 2021 11:43:29 -0500
Received: from smtp-out-3.mxes.net (smtp-out-3.mxes.net [IPv6:2605:d100:2f:10::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0711C061756
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2021 08:42:43 -0800 (PST)
Received: from Customer-MUA (mua.mxes.net [IPv6:fd::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp.mxes.net (Postfix) with ESMTPSA id 4DgkCh5djQz3c9P
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2021 11:42:40 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mxes.net; s=mta;
        t=1613580161; bh=Rj2iGmsW0AJlkNHt++OcGFEUEYLceVnMUrDNCHKtrCE=;
        h=To:From:Subject:Date:From;
        b=bcrXV1WnfLDABWwlBU50gtAIL6bD4qFRmGDGrqSTEwHB2qhSyEm6Qb9x+QK6ZfSiP
         c7D3GIW9tPnNNhE3d5ocgo5FKqI/J66EEsnUrRs9IbuNUiHrn7OD/loDjyuZ7oWMTS
         o83JLbCNf3LrLf+fx2BNkuYOeTXPEWA6Zeh7xtLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrewnesbit.org;
        s=default; t=1613580161;
        bh=Rj2iGmsW0AJlkNHt++OcGFEUEYLceVnMUrDNCHKtrCE=; l=1011;
        h=To:From:Subject:Date:From;
        b=HC5zj7iF0Hu2GIvqIz3p7v9H9W9u5Qyx5e95hkuqpyK+KBVgcHKa+GaRIMFJKUfG1
         X2Hl+vGsdUiyLz0oULyNm9pSvVXV6I0E7JanU8ar/3CCvmolL6g+rfp+xfquxxeFHc
         O+txL0ZeUiXFmaP1uITUwcp3Tawn7RA96uWMvjaw=
To:     linux-btrfs@vger.kernel.org
From:   U'll Be King Of The Stars <ullbeking@andrewnesbit.org>
Subject: Is there a "documentation subproject" for Btrfs?
Message-ID: <f286c6df-31b2-1f6c-0bcd-f9c12fec9a97@andrewnesbit.org>
Date:   Wed, 17 Feb 2021 16:42:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Sent-To: <bGludXgtYnRyZnNAdmdlci5rZXJuZWwub3Jn>
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear Btrfs folks,

I've got a few thoughts about the development, perception, progress, and
other things concerning Btrfs.  I realized that these ideas center on
the presentation, and especially, documentation, of Btrfs.

Is there anything like a Btrfs subproject for documentation or "Btrfs
newbies"?

I'm asking from the perspective of throwing ideas around presently.
Hopefully I get an answer or two that might lead to something that
allows me to understand and express the things I've been thinking about.

In a nutshell, this concerns the public perception and enthusiastic
progress of the project.  It first came to mind the other day, when I
was chatting on IRC and wondered whether Btrfs might one day support a
fast SSD tier.  Apparently there have been patches for this, and this is
the kind of thing that interests me greatly.  But there are other things
that are probably more important to get right first, hence my question
near the top of this message.

Kind regards,

Andrew
