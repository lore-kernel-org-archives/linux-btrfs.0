Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BA2C433EF
	for <linux-btrfs@archiver.kernel.org>; Wed, 22 Jun 2022 13:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350428AbiFVNHu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 09:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiFVNHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Jun 2022 09:07:49 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E08175B3;
        Wed, 22 Jun 2022 06:07:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C40D868AA6; Wed, 22 Jun 2022 15:07:45 +0200 (CEST)
Date:   Wed, 22 Jun 2022 15:07:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4] btrfs: test read repair on a corrupted compressed
 extent
Message-ID: <20220622130745.GA29960@lst.de>
References: <20220622045844.3219390-1-hch@lst.de> <20220622045844.3219390-5-hch@lst.de> <20220622092140.GA26204@lst.de> <20220622124118.mkawtc3n2quhi42l@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622124118.mkawtc3n2quhi42l@zlang-mailbox>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 22, 2022 at 08:41:18PM +0800, Zorro Lang wrote:
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2017 Liu Bo.  All Rights Reserved.
>                    ^^^^^^^^^^^
> Is it a wrong copy&paste ?

A lot of the test is copied from btrfs/141, so I wanted to keep the
copyright intact.

> > +#
> > +# FS QA Test 270
> > +#
> > +# Regression test for btrfs buffered read repair of compressed data.
> 
> If this's a regression test, I'd like to see the fix be reviewed/acked
> at first :)

Heh.  Actually I'm not sure it is a regression, this was copy and
pasted as well.  I think it actually has been broken since day 1.
