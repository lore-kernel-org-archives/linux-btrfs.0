Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29856C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC40B2084F
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 10:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfDIKZZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 06:25:25 -0400
Received: from verein.lst.de ([213.95.11.211]:49466 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbfDIKZZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 06:25:25 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 8E03F68B02; Tue,  9 Apr 2019 12:25:12 +0200 (CEST)
Date:   Tue, 9 Apr 2019 12:25:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 1/2] uuid: Add a glue layer macros for raw buffers
Message-ID: <20190409102512.GB7741@lst.de>
References: <20190329202644.40058-1-andriy.shevchenko@linux.intel.com> <20190403180903.GD28682@lst.de> <20190404084526.GI9224@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404084526.GI9224@smile.fi.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 04, 2019 at 11:45:26AM +0300, Andy Shevchenko wrote:
> On Wed, Apr 03, 2019 at 08:09:03PM +0200, Christoph Hellwig wrote:
> > On Fri, Mar 29, 2019 at 11:26:43PM +0300, Andy Shevchenko wrote:
> > > When the ID comes from or we would like to pass it to a raw buffer,
> > > the casting is needed.
> > 
> > Something is missing in this sentence.
> 
> What I meant there is if we got a raw buffer, consider u8 * pointer to it, and
> we would like to either take a UUID in binary form from it or pass it to that
> buffer, we have to cast due to type inequivalence.
> 
> Can you suggest how to compress it nicely to few words?

Well, the usual way is to memcpy it out, and I'm not sure how this
is so much better.  But maybe a detailed changelog that actuall parses
and properly typed inline functions might convince me :)
