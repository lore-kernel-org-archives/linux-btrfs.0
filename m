Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007D9C10F14
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 10:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDCF820833
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 10:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDHKTR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 06:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfDHKTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 06:19:17 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1CEC81113;
        Mon,  8 Apr 2019 10:19:16 +0000 (UTC)
Received: from ming.t460p (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2679760CD0;
        Mon,  8 Apr 2019 10:19:08 +0000 (UTC)
Date:   Mon, 8 Apr 2019 18:19:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Omar Sandoval <osandov@osandov.com>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible bio merging breakage in mp bio rework
Message-ID: <20190408101903.GC19589@ming.t460p>
References: <59c19acf-999f-1911-b0b8-1a5cec8116c5@suse.com>
 <20190406001653.GA4805@ming.t460p>
 <eb586b8f-f8d4-f455-6203-4ceae2420274@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb586b8f-f8d4-f455-6203-4ceae2420274@suse.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 08 Apr 2019 10:19:16 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 08, 2019 at 11:52:59AM +0200, Johannes Thumshirn wrote:
> On 06/04/2019 02:16, Ming Lei wrote:
> > Hi Nikolay,
> > 
> > On Fri, Apr 05, 2019 at 07:04:18PM +0300, Nikolay Borisov wrote:
> >> Hello Ming, 
> >>
> >> Following the mp biovec rework what is the maximum 
> >> data that a bio could contain? Should it be PAGE_SIZE * bio_vec 
> > 
> > There isn't any maximum data limit on the bio submitted from fs,
> > and block layer will make the final bio sent to driver correct
> > by applying all kinds of queue limit, such as max segment size,
> > max segment number, max sectors, ...
> 
> Naive question, why are we creating possibly huge bios just to split
> them according the the LLDD's limits afterwards?

bio split is one important IO model in block layer, which simplifies
stacked driver(dm, md, bcache, ...) a lot.

It is very reasonable to apply the queue limits in its. make_request_fn().

Otherwise, it will cause huge mess in stacking driver if queue limits
are applied in bio_add_page(), see previous .merge_bvec_fn's implementation
in these stacking drivers.

Not only bio_add_page(), there is also bio clone involved.

> 
> Can't we look at the limits in e.g. bio_add_page() and decide if we need
> to split there?

bio_add_page() is absolutely the fast path, and it is much more efficient
to apply the limit just once in the queue's .make_request_fn.

Thanks,
Ming
