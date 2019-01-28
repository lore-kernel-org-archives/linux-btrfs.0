Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95721C282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 18:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6718B2171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 18:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfA1Spe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 13:45:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:56800 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726694AbfA1Spe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 13:45:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4264B00C;
        Mon, 28 Jan 2019 18:45:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32787DA78C; Mon, 28 Jan 2019 19:44:56 +0100 (CET)
Date:   Mon, 28 Jan 2019 19:44:55 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6 v2] btrfs: merge btrfs_find_device() and find_device()
Message-ID: <20190128184454.GJ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-6-git-send-email-anand.jain@oracle.com>
 <1547880535-29710-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547880535-29710-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Jan 19, 2019 at 02:48:55PM +0800, Anand Jain wrote:
> Both btrfs_find_device() and find_device() does the same things expect
> that latter function is not keen in seed device in the scan-context. So
> merge them.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

I can't find a reply that this has been merged, but it is, in misc-next,
thanks.
