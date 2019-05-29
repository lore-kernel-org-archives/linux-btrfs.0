Return-Path: <SRS0=OIbs=T5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34AD2C28CC0
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 May 2019 13:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14A5222CE9
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 May 2019 13:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfE2NzS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 May 2019 09:55:18 -0400
Received: from mailgw-01.dd24.net ([193.46.215.41]:56082 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfE2NzS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 May 2019 09:55:18 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 792025FDF9;
        Wed, 29 May 2019 13:55:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-01.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id GZn0OeKV_C7m; Wed, 29 May 2019 13:55:14 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-188-174-64-185.dynamic.mnet-online.de [188.174.64.185])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Wed, 29 May 2019 13:55:14 +0000 (UTC)
Message-ID: <90f76cf541c5572c1a89b1388a26515994db60bc.camel@scientia.net>
Subject: Re: Patch "Btrfs: do not start a transaction during fiemap"
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
Cc:     dsterba@suse.com
Date:   Wed, 29 May 2019 15:55:14 +0200
In-Reply-To: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
References: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey David.

Regarding your patch "Btrfs: do not start a transaction during
fiemap"...

I assume since the blockdevice had to be set read-only in order for the
bug to happen... all these aborted transactions, etc. couldn't cause
any corruptions/etc. upon the fs,... so there's nothing further one
would need to check, right?


Thanks,
Chris.

