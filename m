Return-Path: <SRS0=QcMt=BH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10FBBC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED985204EA
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 Jul 2020 15:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgG1PJr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:09:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:33010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbgG1PJq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Jul 2020 11:09:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 49308B58D;
        Tue, 28 Jul 2020 15:09:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6AE67DA6FD; Tue, 28 Jul 2020 17:09:16 +0200 (CEST)
Date:   Tue, 28 Jul 2020 17:09:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 2/2] btrfs: fix root leak printk to use %lld instead of
 %llu
Message-ID: <20200728150916.GX3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20200722160722.8641-1-josef@toxicpanda.com>
 <20200722160722.8641-2-josef@toxicpanda.com>
 <20200723142041.GD3703@twin.jikos.cz>
 <ce52445d-b104-252c-005f-9bc13b2141d7@gmx.com>
 <20200727140314.GL3703@twin.jikos.cz>
 <dfdb8641-99ce-a2e1-ea4f-8489d3cb5757@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfdb8641-99ce-a2e1-ea4f-8489d3cb5757@gmx.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 28, 2020 at 07:47:00AM +0800, Qu Wenruo wrote:
> I still remember that we put that limit as a hard limit for subvolume
> creation.

Ok, I found it, added by your patch e09fe2d2119800e6 in 2015. It's not
documented anywhere, eg. manual page 5 states the limit is 2^64.

2^48 should be enough for everyone and we can't probably changed it
right now as it's part of API and ABI. Oh well.
