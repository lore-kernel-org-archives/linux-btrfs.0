Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BB0C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 22:52:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F34CB20818
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 22:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfDLWwY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 18:52:24 -0400
Received: from mailgw-01.dd24.net ([193.46.215.41]:40922 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfDLWwY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 18:52:24 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 139BE600A2;
        Fri, 12 Apr 2019 22:52:23 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id WBLsMPyriYvu; Fri, 12 Apr 2019 22:52:21 +0000 (UTC)
Received: from heisenberg.fritz.box (ppp-82-135-82-31.dynamic.mnet-online.de [82.135.82.31])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Fri, 12 Apr 2019 22:52:21 +0000 (UTC)
Message-ID: <2634827e254f1994d1ed52bcfb1863855af42aab.camel@scientia.net>
Subject: Re: delayed_refs has NO entry / btrfs_update_root:136: Aborting
 unused transaction(No space left).
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Sat, 13 Apr 2019 00:52:20 +0200
In-Reply-To: <e92b879b03f4838cc05c1b80d20917d3be1ba7f7.camel@scientia.net>
References: <b2a668d7124f1d3e410367f587926f622b3f03a4.camel@scientia.net>
         <d35fa8de087c746f9affb789cf3ab599a3d042c1.camel@scientia.net>
         <9ff84820-5d7e-f541-6adc-29c4949d44e0@suse.de>
         <e92b879b03f4838cc05c1b80d20917d3be1ba7f7.camel@scientia.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, 2019-04-13 at 00:46 +0200, Christoph Anton Mitterer wrote:
> If you repeat the above from the losetup point, but with -r ...

s/with -r/without -r/

