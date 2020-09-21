Return-Path: <SRS0=y50c=C6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E0DC4363C
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 20:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F7792071A
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Sep 2020 20:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIUU0T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 16:26:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:38270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgIUU0T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Sep 2020 16:26:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40938ACD8;
        Mon, 21 Sep 2020 20:26:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F1D3CDA6E0; Mon, 21 Sep 2020 22:25:02 +0200 (CEST)
Date:   Mon, 21 Sep 2020 22:25:02 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anandsuveer@gmail.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 1/2] btrfs: init device stats for seed devices
Message-ID: <20200921202502.GT6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anandsuveer@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1600461724.git.josef@toxicpanda.com>
 <b0c2be2e6722f091821521301f251628afcd8313.1600461724.git.josef@toxicpanda.com>
 <8217721c-0bd9-67af-1900-9594689c127b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8217721c-0bd9-67af-1900-9594689c127b@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Sep 19, 2020 at 05:47:18AM +0800, Anand Jain wrote:
> 
> Seed read errors should remain persistent.

How? The seed device is read-only, we can't record the stats and
recording them on the sprout device has unclear meaning.

> A similar update to btrfs_run_dev_stats() is required?
