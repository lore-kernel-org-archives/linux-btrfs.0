Return-Path: <SRS0=vY8e=3T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3EACC2D0DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Jan 2020 14:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA8C52082E
	for <linux-btrfs@archiver.kernel.org>; Thu, 30 Jan 2020 14:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgA3OHR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 09:07:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:51484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgA3OHR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Jan 2020 09:07:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4172CAC66;
        Thu, 30 Jan 2020 14:07:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 359FCDA84C; Thu, 30 Jan 2020 15:06:57 +0100 (CET)
Date:   Thu, 30 Jan 2020 15:06:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Implement DRW lock
Message-ID: <20200130140657.GT3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200130125945.7383-1-nborisov@suse.com>
 <20200130125945.7383-5-nborisov@suse.com>
 <7c1530e7-85a0-e4c7-3ae5-770c5f9c18b2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1530e7-85a0-e4c7-3ae5-770c5f9c18b2@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 30, 2020 at 03:37:26PM +0200, Nikolay Borisov wrote:
> > +int btrfs_drw_lock_init(struct btrfs_drw_lock *lock)
> > +{
> > +	int ret;
> > +
> > +	ret = percpu_counter_init(&lock->writers, 0, GFP_KERNEL);
> > +	if (ret)
> > +		return ret;
> > +
> > +	atomic_set(&lock->readers, 0);
> > +	init_waitqueue_head(&lock->pending_readers);
> > +	init_waitqueue_head(&lock->pending_writers);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(btrfs_drw_lock_init);
> 
> I have the functions EXPORT_SYMBOL since I have an internal patch which
> is hooking this code to locktorture. SO they can be removed.

You can make the exports conditional, #ifdef LOCKTORTURE.
