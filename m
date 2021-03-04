Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04574C433E6
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD8E64E5F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Mar 2021 13:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbhCDNzb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:55:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:46820 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241677AbhCDNzF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Mar 2021 08:55:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F232CAAC5;
        Thu,  4 Mar 2021 13:54:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CB7A6DA81D; Thu,  4 Mar 2021 14:52:27 +0100 (CET)
Date:   Thu, 4 Mar 2021 14:52:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
Subject: Re: BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!
Message-ID: <20210304135227.GO7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-btrfs @ vger . kernel . org" <linux-btrfs@vger.kernel.org>
References: <PH0PR04MB74169B4B92CC269611F54BF09B999@PH0PR04MB7416.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74169B4B92CC269611F54BF09B999@PH0PR04MB7416.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 02, 2021 at 10:27:28AM +0000, Johannes Thumshirn wrote:
> I've just tripped over this lockdep splat on v5.12-rc1 (Linus' tree not misc-next),
> while investigating a different bug report.
> 
> 
> [ 1250.721882] BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!

That's not a new warning, it shows up from time to time, it's something
in lockdep, the value is defined in kernel/locking/lockdep_internals.h.

> [ 1250.722641] turning off the locking correctness validator.

This makes things worse as all follwing tests won't be validated, so you
may want to go report it to lockdep people.
