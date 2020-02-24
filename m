Return-Path: <SRS0=op+e=4M=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B328DC11D2F
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93A2B20838
	for <linux-btrfs@archiver.kernel.org>; Mon, 24 Feb 2020 17:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgBXRl3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:41:29 -0500
Received: from verein.lst.de ([213.95.11.211]:39374 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgBXRl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Feb 2020 12:41:29 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 44A5868B20; Mon, 24 Feb 2020 18:41:26 +0100 (CET)
Date:   Mon, 24 Feb 2020 18:41:26 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4 1/4] uuid: Add inline helpers to import / export
 UUIDs
Message-ID: <20200224174126.GA7771@lst.de>
References: <20200224153752.35063-1-andriy.shevchenko@linux.intel.com> <20200224153752.35063-2-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224153752.35063-2-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 24, 2020 at 05:37:49PM +0200, Andy Shevchenko wrote:
> Sometimes we may need to import UUID from or export to the raw buffer,
> which is provided outside of kernel and can't be declared as UUID type.
> With current API this operation will require an explicit casting
> to one of UUID types and length, that is always a constant derived as sizeof
> the certain UUID type.
> 
> Provide a helpful set of inline helpers to minimize developer's effort
> in the cases when raw buffers are involved.
> 
> Suggested-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

No a huge fan of these trivial memcpy wrappers, but they also don't
seem entirely horrible:

Acked-by: Christoph Hellwig <hch@lst.de>
