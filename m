Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E252C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDA964F7C
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhBCTFP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:05:15 -0500
Received: from mail.eclipso.de ([217.69.254.104]:39976 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhBCTFO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:05:14 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 7A98C829
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Feb 2021 20:04:32 +0100 (CET)
Date:   Wed, 03 Feb 2021 20:04:32 +0100
MIME-Version: 1.0
Message-ID: <f5d8af48e8d5543267089286c01c476f@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: put 2 hard drives in mdadm raid 1 and detect bitrot like btrfs does,
        what's that called?
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     ", linux-btrfs" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

­Hi All,

I am looking for a way to make a raid 1 of two SSD's, and to be able to detect corrupted blocks, much like btrfs does that. I recall being told about a month ago to use a specific piece of software for that, but i forgot to make a note of it, and I can't find it anymore.

What's that called?

Cheers,
Cedric

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


