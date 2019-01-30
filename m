Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F508C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38B0B205C9
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 15:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfA3PcC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 10:32:02 -0500
Received: from mailgw-02.dd24.net ([193.46.215.43]:51136 "EHLO
        mailgw-02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbfA3PcC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 10:32:02 -0500
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2019 10:32:01 EST
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-02.dd24.net (Postfix) with ESMTP id 9876B5FD28;
        Wed, 30 Jan 2019 15:26:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.36])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10236)
        with ESMTP id dFt5iKMUbQsQ; Wed, 30 Jan 2019 15:26:09 +0000 (UTC)
Received: from gar-nb-etp23.garching.physik.uni-muenchen.de (unknown [141.84.41.132])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Wed, 30 Jan 2019 15:26:08 +0000 (UTC)
Message-ID: <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Wed, 30 Jan 2019 16:26:08 +0100
In-Reply-To: <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
         <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2019-01-30 at 07:58 -0500, Austin S. Hemmelgarn wrote:
> Running dm-integrity without a journal is roughly equivalent to
> using 
> the nobarrier mount option (the journal is used to provide the same 
> guarantees that barriers do).  IOW, don't do this unless you are
> willing 
> to lose the whole volume.

That sounds a bit strange to me.

My understanding was that the idea of being able to disable the journal
of dm-integrity was just to avoid any double work, if equivalent
guarantees are already given by higher levels.

If btrfs is by itself already safe (by using barriers), then I'd have
expected that not transaction is committed, unless it got through all
lower layers... so either everything works well on the dm-integrity
base (and thus no journal is needed)... or it fails there... but then
btrfs would already safe by it's own means (barriers + CoW)?


Cheers,
Chris.

