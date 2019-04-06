Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC41C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94F71218D9
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfDFMav (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 08:30:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfDFMav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 6 Apr 2019 08:30:51 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 196BD9D0DA;
        Sat,  6 Apr 2019 12:30:51 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 35ECD60CCC;
        Sat,  6 Apr 2019 12:30:42 +0000 (UTC)
Date:   Sat, 6 Apr 2019 20:30:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Omar Sandoval <osandov@osandov.com>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible bio merging breakage in mp bio rework
Message-ID: <20190406123035.GA3018@ming.t460p>
References: <59c19acf-999f-1911-b0b8-1a5cec8116c5@suse.com>
 <20190406001653.GA4805@ming.t460p>
 <9ac6f2eb-069a-a02c-7863-e33cb00ad312@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac6f2eb-069a-a02c-7863-e33cb00ad312@suse.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Sat, 06 Apr 2019 12:30:51 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 06, 2019 at 09:09:12AM +0300, Nikolay Borisov wrote:
> 
> 
> On 6.04.19 г. 3:16 ч., Ming Lei wrote:
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
> > 
> >> or something else? Currently I can see bios as large as 127 megs 
> >> on sequential workloads, I got prompted to this since btrfs has a 
> >> memory allocation that is dependent on the data in the bio and this 
> >> particular memory allocation started failing with order 6 allocs. 
> > 
> > Could you share us the code? I don't see why order 6 allocs is a must.
> 
> When a bio is submitted btrfs has to calculate the checksum for it, this
> happens in btrfs_csum_one_bio. Said checksums are stored in an
> kmalloc'ed array, whose size is calculated as:
> 
> 32 + bio_size / btrfs' block size (usually 4k). So for a 127mb bio that
> would be: 32 * ((134184960÷4096) * 4) = 127k. We'd make an order 3
> allocation. Admittedly the code in btrfs should know better rather than
> make unbounded allocations without a fallback, but bio suddenly becoming
> rather unbounded in their size caught us offhand.

OK, thanks for your explanation.

Given it is one btrfs specific feature, I'd suggest you set one max size for
btrfs bio, for example, suppose the max checksum array is 4k, then the max
bio size can be calculated as:

	(4k - 32) * btrfs's block size

which should be big enough.

Thanks,
Ming
