Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05BEC43387
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:51:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C7020656
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 11:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfAOLvj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:51:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:53196 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728133AbfAOLvj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 06:51:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 64CF8AEE9;
        Tue, 15 Jan 2019 11:51:38 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DF978DA83D; Tue, 15 Jan 2019 12:51:09 +0100 (CET)
Date:   Tue, 15 Jan 2019 12:51:09 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS critical corrupt leaf bad key order
Message-ID: <20190115115109.GF2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Leonard Lausen <leonard@lausen.nl>, linux-btrfs@vger.kernel.org
References: <87d0oyw46b.fsf@lausen.nl>
 <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddda9d3e-7d63-755c-d421-0e3828059d78@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 15, 2019 at 07:48:47PM +0800, Qu Wenruo wrote:
> > following tree-dumps:
> > 
> >   sudo btrfs inspect dump-tree -t root /dev/mapper/vg1-root > /tmp/btrfsdumproot
> >   sudo btrfs inspect dump-tree -b 1350630375424 /dev/mapper/vg1-root > /tmp/btrfsdump1350630375424
> > 
> > The root dump is at https://termbin.com/lz0l and the block dump at
> > https://termbin.com/oev5 . The number 1350630375424 does not occur in
> > the root dump. The root dump has 16715 lines, the block dump only 645.
> 
> Super nice move, it shows the corruption and the cause.
> 
> 	item 66 key (1714119835648 METADATA_ITEM 0) itemoff 13325 itemsize 33
> 	item 67 key (10510212874240 METADATA_ITEM 0) itemoff 13283 itemsize 42
> 	item 68 key (1714119868416 METADATA_ITEM 0) itemoff 13250 itemsize 33
> 
> See the key objectid of key 67 is way larger than item 66/68.
> 
> And furthermore, it indeed looks like a bit rot:
> 0x18f19810000 (1714119835648)
> 0x98f19814000 (10510212874240)
> 0x18f19818000 (1714119868416)
> 
> See one bit got flipped.
> 
> I don't know it's corrupted in memory or on the SSD, although I tend to
> believe it's caused by memory bit flip.

Single bit flips are almost always caused by RAM, not storage (that
fails in larger blocks or does not even return any data)

> But anyway, it can be fixed by patching the corrupted leaf manually.

That will fix one instance of the corrupted key, without an analysis how
far the wrong key got spred it's still risky.
