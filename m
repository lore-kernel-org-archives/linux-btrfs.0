Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A03C433DB
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Jan 2021 14:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC1D23A7F
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Jan 2021 14:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbhANO3i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Jan 2021 09:29:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:34528 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbhANO3h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Jan 2021 09:29:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 61757AE63;
        Thu, 14 Jan 2021 14:28:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 11DDEDA7EE; Thu, 14 Jan 2021 15:27:03 +0100 (CET)
Date:   Thu, 14 Jan 2021 15:27:02 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
Subject: Re: btrfs: shrink delalloc pages instead of full inodes, for 5.10.8?
Message-ID: <20210114142702.GW6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <CAJCQCtRekGcPXk7-bZKxTNapTkM43d5s0rtLJ77rQL4sLiNX1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRekGcPXk7-bZKxTNapTkM43d5s0rtLJ77rQL4sLiNX1g@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 14, 2021 at 01:13:50AM -0700, Chris Murphy wrote:
> Hi,
> 
> It looks like this didn't make it to 5.10.7. I see the PR for
> 5.11-rc4. Is it likely it'll make it into 5.10.8?

5.10.8 is feasible I think, a minor diff fixup is needed to apply to
5.10.x, I'll send it.
