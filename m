Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39174C433ED
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0AA261352
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Apr 2021 15:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhD3PcD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 11:32:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:45272 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhD3PcD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Apr 2021 11:32:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D4429AFEF;
        Fri, 30 Apr 2021 15:31:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 23363DA838; Fri, 30 Apr 2021 17:28:48 +0200 (CEST)
Date:   Fri, 30 Apr 2021 17:28:47 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/7] Preemptive flushing improvements
Message-ID: <20210430152847.GE7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Wang Yugui <wangyugui@e16-tech.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <a4d45780-84f1-2ff9-638e-64a0e97af5b0@toxicpanda.com>
 <20210430054002.6E36.409509F4@e16-tech.com>
 <20210430062307.0CEE.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430062307.0CEE.409509F4@e16-tech.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 30, 2021 at 06:23:08AM +0800, Wang Yugui wrote:
> > > > This is the file 562.out.bad.

Can you please post again the error?

> By the way, We enable '-O no-holes -R free-space-tree' default for
> mkfs.btrfs.

The fstests cases are not robust enough to catch differences in the
output when various features are enabled so it depends on the exact
error.
