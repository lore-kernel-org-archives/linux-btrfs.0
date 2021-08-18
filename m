Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C657C432BE
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 12:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07F656108D
	for <linux-btrfs@archiver.kernel.org>; Wed, 18 Aug 2021 12:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235943AbhHRMxu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 08:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234801AbhHRMxu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Aug 2021 08:53:50 -0400
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7C3C061764
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Aug 2021 05:53:15 -0700 (PDT)
Received: from ananda.localnet (unknown [IPv6:2001:a62:1a8a:f00:b5dd:7c8a:f028:1c76])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id B08002A4A4E
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Aug 2021 14:53:13 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     linux-btrfs@vger.kernel.org
Subject: swapfile with BTRFS RAID 1
Date:   Wed, 18 Aug 2021 14:53:12 +0200
Message-ID: <10958794.vSJxiKAMbr@ananda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin2 smtp.mailfrom=martin@lichtvoll.de
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

Regarding swapfile support in BTRFS I found it does not work on RAID 1:

BTRFS warning (device somepartition): swapfile must have single data 
profile

as is documented

https://btrfs.wiki.kernel.org/index.php/Manpage/
btrfs(5)#SWAPFILE_SUPPORT

Now is there a way to tell BTRFS that the swapfile should be single 
profile?

I see "btrfs filesystem usage" says "no" for "multiple profiles". But I 
also got the following hint that it is not yet supported to specify a 
different profile for a subvolume:

https://unix.stackexchange.com/questions/196490/what-can-i-do-with-btrfs-profiles

I also did not find anything in btrfs subvolume manpage about it.

So just not possible at the moment?

(And no, I do not need that for my own setups.)

Best,
-- 
Martin


