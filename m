Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC0AC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 16:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18C64206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 16:45:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18C64206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bouton.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeLDQpu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 11:45:50 -0500
Received: from ns.bouton.name ([109.74.195.142]:56236 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbeLDQpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 11:45:49 -0500
Received: from [192.168.30.46] (laubervilliers-657-1-19-239.w80-15.abo.wanadoo.fr [80.15.154.239])
        by mail.bouton.name (Postfix) with ESMTP id B454CB849;
        Tue,  4 Dec 2018 17:45:47 +0100 (CET)
Subject: [Mount time bug bounty?] was: BTRFS Mount Delay Time Graph
To:     Hans van Kranenburg <Hans.van.Kranenburg@mendix.com>,
        "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <4746e8ba-b20c-01e2-379e-b76f0d2ab5a7@bouton.name>
 <57bdbd3d-e605-7dad-4b9a-d78a2f657dce@mendix.com>
From:   Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <0a25ef18-83d1-de59-e2ab-1f36b04d9625@bouton.name>
Date:   Tue, 4 Dec 2018 17:45:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <57bdbd3d-e605-7dad-4b9a-d78a2f657dce@mendix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Le 03/12/2018 à 23:22, Hans van Kranenburg a écrit :
> [...]
> Yes, I think that's true. See btrfs_read_block_groups in extent-tree.c:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/extent-tree.c#n9982
>
> What the code is doing here is starting at the beginning of the extent
> tree, searching forward until it sees the first BLOCK_GROUP_ITEM (which
> is not that far away), and then based on the information in it, computes
> where the next one will be (just after the end of the vaddr+length of
> it), and then jumps over all normal extent items and searches again near
> where the next block group item has to be. So, yes, that means that they
> depend on each other.
>
> Two possible ways to improve this:
>
> 1. Instead, walk the chunk tree (which has all related items packed
> together) instead to find out at which locations in the extent tree the
> block group items are located and then start getting items in parallel.
> If you have storage with a lot of rotating rust that can deliver much
> more random reads if you ask for more of them at the same time, then
> this can already cause a massive speedup.
>
> 2. Move the block group items somewhere else, where they can nicely be
> grouped together, so that the amount of metadata pages that has to be
> looked up is minimal. Quoting from the link below, "slightly tricky
> [...] but there are no fundamental obstacles".
>
> https://www.spinics.net/lists/linux-btrfs/msg71766.html
>
> I think the main obstacle here is finding a developer with enough
> experience and time to do it. :)

I would definitely be interested in sponsoring at least a part of the
needed time through my company (we are too small to hire kernel
developers full-time but we can make a one-time contribution for
something as valuable to us as faster mount delays).

If needed it could be split in two steps with separate bounties :
- providing a patch for the latest LTS kernel with a substantial
decrease in mount time in our case (ideally less than a minute instead
of 15 minutes but <5 minutes is already worth it).
- having it integrated in mainline.

I don't have any experience with company sponsorship/bounties but I'm
willing to learn (don't hesitate to make suggestions). I'll have to
discuss it with our accountant to make sure we do it correctly.

Is it the right place to discuss this kind of subject or should I take
the discussion elsewhere ?

Best regards,

Lionel
