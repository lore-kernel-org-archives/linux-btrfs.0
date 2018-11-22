Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F4BC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E77E8206B2
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 14:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E77E8206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbeKWAzJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 19:55:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:33576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732939AbeKWAzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 19:55:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ABF44ADE3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 14:15:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0F53DA871; Thu, 22 Nov 2018 15:15:15 +0100 (CET)
Date:   Thu, 22 Nov 2018 15:15:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: improve error handling of btrfs_add_link()
Message-ID: <20181122141514.GS24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181122131528.19421-1-jthumshirn@suse.de>
 <20181122133555.GR24115@twin.jikos.cz>
 <d1917f36-89c4-6219-ade0-8f1d4892341d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1917f36-89c4-6219-ade0-8f1d4892341d@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 02:44:35PM +0100, Johannes Thumshirn wrote:
> On 22/11/2018 14:35, David Sterba wrote:
> > On Thu, Nov 22, 2018 at 02:15:28PM +0100, Johannes Thumshirn wrote:
> >> err holds the return value of either btrfs_del_root_ref() or
> >> btrfs_del_inode_ref() but it hasn't been checked since it's
> >> introduction with commit fe66a05a0679 (Btrfs: improve error handling
> >> for btrfs_insert_dir_item callers) in 2012.
> >>
> >> The first attempt in removing the variable was rejected, so instead of
> >> removing 'err', start handling the errors of
> >> btrfs_del_root_ref()/btrfs_del_inode_ref() by aborting the transaction in
> >> btrfs_add_link() directly instead of the call-sites.
> > 
> > ... which is an anti-pattern.
> > 
> > https://btrfs.wiki.kernel.org/index.php/Development_notes#Error_handling_and_transaction_abort
> > 
> > In case there are several conditons that can fail we want to see the
> > first one for later analysis and debugging.
> 
> OK, but then handling the error of either btrfs_del_root_ref() or
> btrfs_del_inode_ref() will essentially only be printing an error message
> as anything else would hide the error condition which has led us into
> this path (i.e. btrfs_insert_dir_item() returning EEXISTS or EOVERFLOW),
> wouldn't it?

So this seems to point out there are more things to resolve here:

* how to recover from errors of btrfs_del_root_ref or btrfs_del_inode_ref
* what to report back to the user

When insert_dir_item fails, there are the inode references to be cleaned
up, and error reported as EEXIST or EOVERFLOW.

When btrfs_del_root_ref or btrfs_del_inode_ref fail, the cleanup is not
possible and there's no other option than the transaction abort. As the
original reason was the overflow, this should be reported to back to the
user.

The reason of the del_*_ref failures can be misleading, in case it's eg.
ENOMEM. This would mean that the add-link operation is possible but
there was not enough memory and restarting later would let it possibly
succeed.

So the missing part of error hanling is to add two "if (err) abort" and
then still return 'ret'. As this is not all obvious why, a comment would
be good there.
