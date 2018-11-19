Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6444AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3121C2086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3121C2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbeKTAh0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 19:37:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:56348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728252AbeKTAh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:37:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C146AFA3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 14:13:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3688BDAF89; Mon, 19 Nov 2018 15:13:23 +0100 (CET)
Date:   Mon, 19 Nov 2018 15:13:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] btrfs: remove set but not used variable err in
 btrfs_add_link
Message-ID: <20181119141323.GC24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181119093817.9291-1-jthumshirn@suse.de>
 <20181119093817.9291-3-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119093817.9291-3-jthumshirn@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 10:38:14AM +0100, Johannes Thumshirn wrote:
> err holds the return value of either btrfs_del_root_ref() or
> btrfs_del_inode_ref() but it hasn't been checked since it's introduction with
> commit fe66a05a0679 (Btrfs: improve error handling for btrfs_insert_dir_item
> callers) in 2012.
> 
> As the error value hasn't been of any interest for 6 years we can just drop it
> as well.

No, I think there should actually be proper error hanling. This is on
the error handling path already so this might be tricky and could
require restructuring btrfs_add_link.

The error handling is not done everywhere it should and such
inconsistencies are more like a hint to improve that than to count the
years of negligence.  Code removal patches should come with a brief
analysis why the code can be safely dropped. You did that, which is
great, but the conclusion was wrong.
