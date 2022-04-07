Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8CEC4332F
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Apr 2022 07:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbiDGHiH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 03:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242089AbiDGHiC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Apr 2022 03:38:02 -0400
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 00:36:02 PDT
Received: from mail.lichtvoll.de (lichtvoll.de [IPv6:2001:67c:14c:12f::11:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AEC254683
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Apr 2022 00:36:02 -0700 (PDT)
Received: from 127.0.0.1 (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
        (No client certificate requested)
        by mail.lichtvoll.de (Postfix) with ESMTPSA id ADFE43FD1CC;
        Thu,  7 Apr 2022 09:30:42 +0200 (CEST)
From:   Martin Steigerwald <martin@lichtvoll.de>
To:     Josef Bacik <josef@toxicpanda.com>, Marc MERLIN <marc@merlins.org>
Cc:     Linux BTRFS mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Rebuilding 24TB Raid5 array (was btrfs corruption: parent transid verify failed + open_ctree failed)
Date:   Thu, 07 Apr 2022 09:30:41 +0200
Message-ID: <11970220.O9o76ZdvQC@ananda>
In-Reply-To: <20220407044006.GB25669@merlins.org>
References: <CAEzrpqd0Pjx7qXz1nXEXubTfN3rmR++idOL8z6fx3tZtyaj2TQ@mail.gmail.com> <20220407043717.GA25669@merlins.org> <20220407044006.GB25669@merlins.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Authentication-Results: mail.lichtvoll.de;
        auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi!

Marc MERLIN - 07.04.22, 06:40:06 CEST:
> Damn, it's hosed so badly that even sysrq-o isn't working, never seen
> that before.

I did not keep statistics, but this might be one of the longest threads 
on BTRFS mailing list.

Good luck with restoring your filesystem or at least recovering all data 
from it!

Best,
-- 
Martin


