Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BFAC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B31720863
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 16:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfCYQz4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:55:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:48198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725788AbfCYQz4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 12:55:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 367FDABEC
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 16:55:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1416CDA98F; Mon, 25 Mar 2019 17:57:07 +0100 (CET)
Date:   Mon, 25 Mar 2019 17:57:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH v3 07/12] btrfs: replace pending/pinned chunks lists with
 io tree
Message-ID: <20190325165706.GM10640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
 <20190325123132.27835-8-nborisov@suse.com>
 <20190325162651.GI10640@twin.jikos.cz>
 <75db110a-db25-e1ff-f74d-997b61532bf7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75db110a-db25-e1ff-f74d-997b61532bf7@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 06:43:49PM +0200, Nikolay Borisov wrote:
> >> -static int __must_check
> >> +int __must_check
> >>  __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
> >>  		 unsigned bits, unsigned exclusive_bits,
> >>  		 u64 *failed_start, struct extent_state **cached_state,
> > 
> > Does this really need to be exported again? There are helpers that can
> > wrap specific combinations of parameters.
> 
> This is exported so that __set_extent_bit could be called with
> GFP_NOWAIT parameter otherwise I was getting lockdep splats since
> extent_map_device_set_bits (called from add_extent_mapping) is called
> under a write_lock hence we can't sleep.

So then we should add a helper for that, like

  int set_exentent_bit_nowait(...)

similar to set_record_extent_bits.

> >> @@ -335,6 +335,8 @@ void btrfs_free_device(struct btrfs_device *device)
> >>  {
> >>  	WARN_ON(!list_empty(&device->post_commit_list));
> >>  	rcu_string_free(device->name);
> >> +	if (!in_softirq())
> >> +		extent_io_tree_release(&device->alloc_state);
> 
> This is used to distinguish between btrfs_free_device being called from
> btrfs_close_devices in close_ctree i.e non rcu (hence no softirq )
> context or any of the error handlers and from free_device_rcu. In the
> latter case the extent tree is already freed in btrfs_close_one_device,
> hence there is no need to do it in the RCU callback.

Ok, I can cook a comment from that, thanks.

> Furthermore, there is also a comment that the extent io tree cannot be
> destroyed in RCU context because extent_io_tree_release calls
> cond_resched_lock which in turn could sleep, but this is forbidden in
> RCU context.

Yeah, comment in the right place.
