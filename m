Return-Path: <SRS0=GeaY=YB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFA0C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 11:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF0B20673
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Oct 2019 11:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbfJHLjy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:39:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:49548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730371AbfJHLjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Oct 2019 07:39:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 751B9B012;
        Tue,  8 Oct 2019 11:39:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7F240DA7FB; Tue,  8 Oct 2019 13:40:07 +0200 (CEST)
Date:   Tue, 8 Oct 2019 13:40:07 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: sysfs: export supported checksums
Message-ID: <20191008114007.GN2751@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20191007091104.18095-1-jthumshirn@suse.de>
 <20191007091104.18095-4-jthumshirn@suse.de>
 <bb3aa7b2-ee08-a4f2-99f3-1d10750322d4@suse.com>
 <20191007154602.GF2751@twin.jikos.cz>
 <de46a7df-37e6-e04e-6a58-9e8380a39dbd@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de46a7df-37e6-e04e-6a58-9e8380a39dbd@suse.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 08, 2019 at 08:47:14AM +0200, Johannes Thumshirn wrote:
> On 07/10/2019 17:46, David Sterba wrote:
> [...]
> >> nit: This function is used only once and the ARRAY_SIZE() macro is
> >> descriptive enough, why not just remove it and opencoude the call to
> >> array_size
> > 
> > Agreed, ARRAY_SIZE in loops is fine, it's a compile-time constant.
> 
> Nope, btrfs_csums[] is defined in ctree.c, so I can't get the size of
> this array outside of ctree.c. And it was moved to ctree.c from ctree.h
> on request by David.

Ohh, right you are of course.
