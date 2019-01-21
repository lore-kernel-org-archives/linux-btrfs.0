Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AAAC31680
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 18:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD38F2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 18:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfAUSTP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 13:19:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:38198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726885AbfAUSTO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 13:19:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BCBABAFC8;
        Mon, 21 Jan 2019 18:19:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7FCEFDA85F; Mon, 21 Jan 2019 19:18:42 +0100 (CET)
Date:   Mon, 21 Jan 2019 19:18:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     dsterba@suse.cz,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1] Btrfs: Switch to use new generic UUID API
Message-ID: <20190121181841.GJ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20190110181653.66048-1-andriy.shevchenko@linux.intel.com>
 <20190111134803.GB27146@twin.jikos.cz>
 <20190121084436.GC18680@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121084436.GC18680@lst.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 21, 2019 at 09:44:36AM +0100, Christoph Hellwig wrote:
> On Fri, Jan 11, 2019 at 02:48:03PM +0100, David Sterba wrote:
> > >  	if (is_fstree(objectid))
> > > -		uuid_le_gen(&uuid);
> > > -	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
> > > +		guid_gen((guid_t *)&root->root_item.uuid);
> > > +	else
> > > +		guid_copy((guid_t *)&root->root_item.uuid, &guid_null);
> > 
> > I don't like the type casts, a simple wrapper would be better I think.
> 
> It seems like we should use the guid_t type in the actual strutures
> instead of doing this casting.

The uuid is part of several on-disk structures, so the definition with
u8[BTRFS_UUID_SIZE] makes the size and alignment clear, also the
constant is verified to be 16.  I find it quite useful that all the
on-disk definitions use only the basic types like u8 or u64.

I'd rather not touch the definitions but rather add a glue for the
guid_t API and the raw buffers.
