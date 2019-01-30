Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4F9C282D7
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C638B2087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 16:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbfA3QbM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:31:12 -0500
Received: from mailgw-01.dd24.net ([193.46.215.41]:40554 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbfA3QbM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 11:31:12 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.27])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 148C85FF5A;
        Wed, 30 Jan 2019 16:31:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at
        mailpolicy-02.live.igb.homer.key-systems.net
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-02.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id kjkABILvh20u; Wed, 30 Jan 2019 16:31:08 +0000 (UTC)
Received: from gar-nb-etp23.garching.physik.uni-muenchen.de (unknown [141.84.41.132])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA;
        Wed, 30 Jan 2019 16:31:08 +0000 (UTC)
Message-ID: <eb97d7596e5526dfe8ef7016636f2a9eb9b8aa3e.camel@scientia.net>
Subject: Re: dm-integrity + mdadm + btrfs = no journal?
From:   Christoph Anton Mitterer <calestyo@scientia.net>
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date:   Wed, 30 Jan 2019 17:31:07 +0100
In-Reply-To: <f7a55647-ac67-4a6d-ca7e-bf3ed05428fb@gmail.com>
References: <2a321782-d258-1ef3-8d25-149b8e24e819@mendix.com>
         <5c11b6a4-de3d-2ba0-c5c6-65ea04cd0245@gmail.com>
         <6ce96b57897acb62101dd213f8127ffeb981ee90.camel@scientia.net>
         <f7a55647-ac67-4a6d-ca7e-bf3ed05428fb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2019-01-30 at 11:00 -0500, Austin S. Hemmelgarn wrote:
> Running dm-integrity on a device which doesn't support barriers
> without 
> a journal is risky, because the journal can help mitigate the issues 
> arising from the lack of barrier support.

Does it? Isn't it then suffering from the same problems that any IO
suffers (e.g. also from btrfs itself, with no further block layer
beneath), when there are no barriers supported?


>   So, make sure your storage 
> devices support barriers properly first.
Is there any proper way to do so? And if,... shouldn't the kernel then
do this automatically?


> > If btrfs is by itself already safe (by using barriers), then I'd
> > have
> > expected that not transaction is committed, unless it got through
> > all
> > lower layers... so either everything works well on the dm-integrity
> > base (and thus no journal is needed)... or it fails there... but
> > then
> > btrfs would already safe by it's own means (barriers + CoW)?
> BTRFS is _mostly_ safe.  The problem is that there are still devices
> out 
> there that don't have proper barrier support.  Without barriers, the 
> superblocks can hit the disk before the most recent transactions do,
> and 
> in that case you're kind of screwed.  dm-integrity's journaling can
> help 
> protect against this to a limited degree (it doesn't completely
> solve 
> the issue, but it's better than nothing), but at the cost of higher 
> overhead from duplicated work.

Okay. But then the general official btrfs advise should probably be:
[If the device supports barriers - and if not one is
anyway at risk]... journaling at the lower dm-integrity level can be
safely disabled, right?

I would expect that there's no difference as to wheter nodatasum is
used or not... cause even if one has a journal below which can be
recovered, btrfs would not be able to make any use of this, or would
it?


If all this is truly the case (i.e. double checked by senior
developers), then it should go into perhaps even both, btrfs and
cryptsetup manpages.


Cheers,
Chris.

