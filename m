Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A768BC11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8972B2084E
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXR6U (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:58:20 -0500
Received: from verein.lst.de ([213.95.11.211]:39476 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgBXR6U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 12:58:20 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 603D568B20; Mon, 24 Feb 2020 18:58:17 +0100 (CET)
Date:   Mon, 24 Feb 2020 18:58:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     dsterba@suse.cz,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/4] btrfs: bypass UUID API aliasing
Message-ID: <20200224175816.GA8184@lst.de>
References: <20200224153752.35063-1-andriy.shevchenko@linux.intel.com> <20200224172645.GA2902@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224172645.GA2902@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 24, 2020 at 06:26:45PM +0100, David Sterba wrote:
> On Mon, Feb 24, 2020 at 05:37:48PM +0200, Andy Shevchenko wrote:
> > UUID API has been converted to differentiate UUID and GUID.
> > Btrfs is using aliases to the new API for some time.
> > 
> > Bypass that aliasing by converting btrfs to use API calls directly.
> > 
> > The series has been compiled only.
> 
> Now it looks good to me, all the objections have been addressed, thanks.
> 
> > P.S. It may be applied either to btrfs tree or to UUID one.
> 
> Both works for me. There are no conflicts with current btrfs queue and I
> don't expect anything serious in the future.

Please pick it up through the btrfs tree.
