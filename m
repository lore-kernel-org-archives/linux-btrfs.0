Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBADC64EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DACF20644
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 15:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DACF20644
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeJIXBm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 19:01:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726468AbeJIXBm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 19:01:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0EDC8ACCE
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Oct 2018 15:44:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6BB19DAD2B; Tue,  9 Oct 2018 17:44:06 +0200 (CEST)
Date:   Tue, 9 Oct 2018 17:44:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: qgroup: Avoid calling qgroup functions if qgroup
 is not enabled
Message-ID: <20181009154406.GI29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181009063645.16113-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009063645.16113-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 02:36:45PM +0800, Qu Wenruo wrote:
> Some qgroup trace events like btrfs_qgroup_release_data() and
> btrfs_qgroup_free_delayed_ref() can still be triggered even qgroup is
> not enabled.
> 
> This is caused by the lack of qgroup status check before really calling
> qgroup functions.
> Thankfully related functions can handle quota disabled case well and just
> do nothing for qgroup disabled case.
> 
> This patch will do earlier check before triggering related trace events.
> 
> And for enabled <-> disabled race case:
> 1) For enabled->disabled case
>    Disable will wipe out all qgroups data including reservation and
>    excl/rfer. Even we leaks some reserveration or numbers, it will
>    still be wiped, so nothing can go wrong.
> 
> 2) For disabled -> enabled case
>    Current btrfs_qgroup_release_data() will use extent_io tree to ensure
>    we won't underflow reservation. And for delayed_ref we use
>    head->qgroup_reserved to record reserved space, so in that case
>    head->qgroup_reserved should be 0 and we won't underflow.
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>

I've added the link to the report.
