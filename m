Return-Path: <SRS0=42Hc=6T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9101C47247
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 May 2020 22:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB48206FA
	for <linux-btrfs@archiver.kernel.org>; Tue,  5 May 2020 22:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgEEWdL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 5 May 2020 18:33:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:50886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbgEEWdL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 May 2020 18:33:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 20F87AE2C;
        Tue,  5 May 2020 22:33:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5A3BBDA7AD; Wed,  6 May 2020 00:32:21 +0200 (CEST)
Date:   Wed, 6 May 2020 00:32:21 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        David Sterba <dsterba@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2 1/2] btrfs: add authentication support
Message-ID: <20200505223221.GY18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
References: <20200428105859.4719-1-jth@kernel.org>
 <20200428105859.4719-2-jth@kernel.org>
 <20200501053908.GC1003@sol.localdomain>
 <SN4PR0401MB3598198E5FB728B68B39A1589BA60@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200504205935.GA51650@gmail.com>
 <SN4PR0401MB359843476634082E8329168A9BA70@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <d395520c-0763-8551-ec80-9cde9b39c3cd@gmx.com>
 <bb748efb-850b-3fa9-0ecd-c754af83e452@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb748efb-850b-3fa9-0ecd-c754af83e452@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 05, 2020 at 05:59:14PM +0800, Qu Wenruo wrote:
> After some more thought, there is a narrow window where the attacker can
> reliably revert the fs to its previous transaction (but only one
> transaction earilier).
> 
> If the attacker can access the underlying block disk, then it can backup
> the current superblock, and replay it to the disk after exactly one
> transaction being committed.
> 
> The fs will be reverted to one transaction earlier, without triggering
> any hmac csum mismatch.
> 
> If the attacker tries to revert to 2 or more transactions, it's pretty
> possible that the attacker will just screw up the fs, as btrfs only
> keeps all the tree blocks of previous transaction for its COW.
> 
> I'm not sure how valuable such attack is, as even the attacker can
> revert the status of the fs to one trans earlier, the metadata and COWed
> data (default) are still all validated.
> 
> Only nodatacow data is affected.

I agree with the above, this looks like the only relialbe attack that
can safely switch to previous transaction. This is effectively the
consistency model of btrfs, to have the current and new transaction
epoch, where the transition is done atomic overwrite of the superblock.

And exactly at this moment the old copy of superblock can be overwritten
back, as if the system crashed just before writing the new one.

From now on With each data/metadata update, new metadata blocks are
cowed and allocated and may start to overwrite the metadata from the
previous transaction. So the reliability of an undetected and unnoticed
revert to previous transaction is decreasing.

And this is on a live filesystem, the attacker would have to somehow
prevent new writes, then rewrite superblock and force new mount.

> To defend against such attack, we may need extra mount option to verify
> the super generation?

I probably don't understand what you mean here, like keeping the last
committed generation somewhere else and then have the user pass it to
mount?
