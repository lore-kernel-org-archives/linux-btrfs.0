Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C920C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D4032081B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 13:40:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D4032081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbeLENk1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:40:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:37246 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726918AbeLENk1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 08:40:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DECA4B065
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 13:40:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0C969DAB92; Wed,  5 Dec 2018 14:40:05 +0100 (CET)
Date:   Wed, 5 Dec 2018 14:40:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 07/13] btrfs-progs: Fix Wmaybe-uninitialized warning
Message-ID: <20181205134005.GB3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181205064018.27755-1-wqu@suse.com>
 <20181205064018.27755-8-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205064018.27755-8-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 02:40:12PM +0800, Qu Wenruo wrote:
> GCC 8.2.1 will report the following warning with "make W=1":
> 
>   ctree.c: In function 'btrfs_next_sibling_tree_block':
>   ctree.c:2990:21: warning: 'slot' may be used uninitialized in this function [-Wmaybe-uninitialized]
>     path->slots[level] = slot;
>     ~~~~~~~~~~~~~~~~~~~^~~~~~
> 
> The culprit is the following code:
> 
> 	int slot;		<< Not initialized
> 	int level = path->lowest_level + 1;
>  	BUG_ON(path->lowest_level + 1 >= BTRFS_MAX_LEVEL);
>  	while(level < BTRFS_MAX_LEVEL) {
> 		slot = path->slots[level] + 1;
> 		^^^^^^ but we initialize @slot here.
> 		...
> 	}
> 	path->slots[level] = slot;
> 
> It's possible that compiler doesn't get enough hint for BUG_ON() on
> lowest_level + 1 >= BTRFS_MAX_LEVEL case.
> 
> Fix it by using a do {} while() loop other than while() {} loop, to
> ensure we will run the loop for at least once.

I was hoping that we can actually add the hint to BUG_ON so the code
does not continue if the condition is true.
