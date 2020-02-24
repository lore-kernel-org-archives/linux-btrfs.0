Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EB7C11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8286020836
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgBXR1G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:27:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:51390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbgBXR1G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 12:27:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8B591AC84;
        Mon, 24 Feb 2020 17:27:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AA398DA727; Mon, 24 Feb 2020 18:26:45 +0100 (CET)
Date:   Mon, 24 Feb 2020 18:26:45 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/4] btrfs: bypass UUID API aliasing
Message-ID: <20200224172645.GA2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
References: <20200224153752.35063-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224153752.35063-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 24, 2020 at 05:37:48PM +0200, Andy Shevchenko wrote:
> UUID API has been converted to differentiate UUID and GUID.
> Btrfs is using aliases to the new API for some time.
> 
> Bypass that aliasing by converting btrfs to use API calls directly.
> 
> The series has been compiled only.

Now it looks good to me, all the objections have been addressed, thanks.

> P.S. It may be applied either to btrfs tree or to UUID one.

Both works for me. There are no conflicts with current btrfs queue and I
don't expect anything serious in the future.
