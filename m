Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16166C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E03D320874
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 15:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfADPbG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 10:31:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56374 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfADPbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Jan 2019 10:31:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3587ACFB
        for <linux-btrfs@vger.kernel.org>; Fri,  4 Jan 2019 15:31:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AA10CDA7CE; Fri,  4 Jan 2019 16:30:34 +0100 (CET)
Date:   Fri, 4 Jan 2019 16:30:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/7] btrfs: Remove WARN_ON in btrfs_alloc_delalloc_work
Message-ID: <20190104153034.GQ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-5-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103085005.32053-5-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:50:02AM +0200, Nikolay Borisov wrote:
> It can never trigger since before calling alloc_delalloc_work we have
> called igrab in start_delalloc_inodes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: David Sterba <dsterba@suse.com>
