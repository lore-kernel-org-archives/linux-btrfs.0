Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED9EC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A75DC2082F
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfCUN3e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 09:29:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728270AbfCUN3e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 09:29:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1C339AEEA
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 13:29:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A8551DAC1B; Thu, 21 Mar 2019 14:30:47 +0100 (CET)
Date:   Thu, 21 Mar 2019 14:30:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.3 08/11] btrfs: extent_io: Kill the BUG_ON() in
 lock_extent_buffer_for_io()
Message-ID: <20190321133047.GC26179@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-9-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320062749.30953-9-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:27:46PM +0800, Qu Wenruo wrote:
> This function needs some extra check on locked pages and eb.
> 
> For error handling we need to unlock locked pages and the eb.
> 
> Also add comment for possible return values of lock_extent_buffer_for_io().
> 
> There is a rare >0 return value branch, where all pages get locked
> while write bio is not flushed.
> 
> Thankfully it's handled by the only caller, btree_write_cache_pages(),
> as later write_one_eb() call will trigger submit_one_bio().
> So there shouldn't be any problem.

Right, I'd suggest to add a comment to btree_write_cache_pages
explaining that and possibly changing the condition to make it more
explicit that all 3 types of values are really handled.
