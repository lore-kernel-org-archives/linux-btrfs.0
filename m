Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874E6C04EBA
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 14:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 554A92145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 14:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 554A92145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389276AbeK3Bh0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 20:37:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:47878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389273AbeK3Bh0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 20:37:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 241A3AFE6;
        Thu, 29 Nov 2018 14:31:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0D4F6DAC25; Thu, 29 Nov 2018 15:31:33 +0100 (CET)
Date:   Thu, 29 Nov 2018 15:31:33 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: scrub: fix circular locking dependency warning
Message-ID: <20181129143133.GA2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
 <1543223228-28232-3-git-send-email-anand.jain@oracle.com>
 <ed04b1e5-b187-7ea9-3f8d-0a14f1143232@suse.com>
 <49b4a708-0d99-fb01-23ff-3463ddd4315f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49b4a708-0d99-fb01-23ff-3463ddd4315f@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 04:47:27PM +0800, Anand Jain wrote:
> > 2. scrub_workers_refcnt must eventually be converted to refcount_t type
> 
>   ok. Added in v2 patch set.

No such thing is in v2 and this would actually get rid of the need to
hold scrub_lock in scrub_workers_put. Which in turn can be moved out of
the locked section in btrfs_scrub_dev and the warning is gone. Problem
solved.
