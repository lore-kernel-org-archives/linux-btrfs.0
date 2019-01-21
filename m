Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB745C282DB
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 08:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10F220861
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 08:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfAUIoi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 03:44:38 -0500
Received: from verein.lst.de ([213.95.11.211]:56997 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbfAUIoi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 03:44:38 -0500
Received: by newverein.lst.de (Postfix, from userid 2407)
        id CB27C68DD2; Mon, 21 Jan 2019 09:44:36 +0100 (CET)
Date:   Mon, 21 Jan 2019 09:44:36 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     dsterba@suse.cz,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1] Btrfs: Switch to use new generic UUID API
Message-ID: <20190121084436.GC18680@lst.de>
References: <20190110181653.66048-1-andriy.shevchenko@linux.intel.com> <20190111134803.GB27146@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190111134803.GB27146@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 11, 2019 at 02:48:03PM +0100, David Sterba wrote:
> >  	if (is_fstree(objectid))
> > -		uuid_le_gen(&uuid);
> > -	memcpy(root->root_item.uuid, uuid.b, BTRFS_UUID_SIZE);
> > +		guid_gen((guid_t *)&root->root_item.uuid);
> > +	else
> > +		guid_copy((guid_t *)&root->root_item.uuid, &guid_null);
> 
> I don't like the type casts, a simple wrapper would be better I think.

It seems like we should use the guid_t type in the actual strutures
instead of doing this casting.  Andy, is there any reason I'm missing
why we can't do that in btrfs?
