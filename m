Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F53FC433DB
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Jan 2021 19:21:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB6AB6024A
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Jan 2021 19:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbhA2TU6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 14:20:58 -0500
Received: from mail.eclipso.de ([217.69.254.104]:53986 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232994AbhA2TTC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jan 2021 14:19:02 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 4464B0FA
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2021 20:18:17 +0100 (CET)
Date:   Fri, 29 Jan 2021 20:18:17 +0100
MIME-Version: 1.0
Message-ID: <054402b640ce879bbb6032afb91e0abe@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: Re: is back and forth incremental send/receive supported/stable?
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     "Christoph Anton Mitterer" <calestyo@scientia.net>
Cc:     <linux-btrfs@vger.kernel.org>
In-Reply-To: <157ed91bb66820d1fef89eb05d00e65c25607938.camel@scientia.net>
References: <157ed91bb66820d1fef89eb05d00e65c25607938.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

By the way, I'm talking about *precious* data, so I'd like to be really
sure that this works... and whether it's intended to work and ideally
have been tested.


Thanks,
Chris.


Hey Chris,
In case everything goes up in flames, just restore from your off-site, cold backup.
Never leave your data in a single place that can burn down.

Cheers,
Cedric
(I'll leave now, don't shoot me)

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


