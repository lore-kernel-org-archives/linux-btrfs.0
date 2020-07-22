Return-Path: <SRS0=Ghwh=BB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8304FC433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 16:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B2F720787
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jul 2020 16:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgGVQIC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jul 2020 12:08:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:38518 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgGVQIC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jul 2020 12:08:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D09F9AF57;
        Wed, 22 Jul 2020 16:08:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 609CBDA70B; Wed, 22 Jul 2020 18:07:35 +0200 (CEST)
Date:   Wed, 22 Jul 2020 18:07:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/2][RESEND] Fix how we do block group flags
Message-ID: <20200722160735.GB3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20200721144846.4511-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721144846.4511-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jul 21, 2020 at 10:48:44AM -0400, Josef Bacik wrote:
> These two patches address some wonkiness with how we do block group flags.
> We've had long standing failures here, this makes things more consistent and
> fixes some weird corner cases where we end up with lots of chunks we cannot use.
> Thanks,

I responded to the previous posting, tl;dr merged but not tested.
