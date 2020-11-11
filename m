Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09648C388F9
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 15:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91C732067D
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Nov 2020 15:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgKKPvS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Nov 2020 10:51:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:54252 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgKKPvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Nov 2020 10:51:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C2267AC75;
        Wed, 11 Nov 2020 15:51:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E5FE1DA6E1; Wed, 11 Nov 2020 16:49:34 +0100 (CET)
Date:   Wed, 11 Nov 2020 16:49:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND 0/2] fix verify_one_dev_extent and
 btrfs_find_device
Message-ID: <20201111154934.GT6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1600940809.git.anand.jain@oracle.com>
 <20201029210242.GX6756@twin.jikos.cz>
 <468a5f49-187a-71ad-b922-eaf091107d65@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468a5f49-187a-71ad-b922-eaf091107d65@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 30, 2020 at 05:14:06AM +0800, Anand Jain wrote:
> > You can also use the workflow scripts to
> > create or update the issue so we'll notice that. 
> 
> I found workflow script can't handle the update? Instead it creates a 
> new issue?

The script btrfs-create-issue asks if there's an existing issue to
update.
