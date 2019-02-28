Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CAFFC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 121202171F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 13:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfB1NkE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:40:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:38270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbfB1NkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 08:40:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68464AAA9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Feb 2019 13:40:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AE2FBDA944; Thu, 28 Feb 2019 14:41:23 +0100 (CET)
Date:   Thu, 28 Feb 2019 14:41:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] btrfs: Remove __extent_readpages
Message-ID: <20190228134123.GD31119@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181203102532.13945-1-nborisov@suse.com>
 <50e531dd-1c4d-dc27-332d-58f7f748c5b0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50e531dd-1c4d-dc27-332d-58f7f748c5b0@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 09:46:10AM +0200, Nikolay Borisov wrote:
> >      issued rwts: total=2621440,0,0,0 short=0,0,0,0 dropped=0,0,0,0
> >      latency   : target=0, window=0, percentile=100.00%, depth=1
> > 
> > Run status group 0 (all jobs):
> >    READ: bw=353MiB/s (370MB/s), 353MiB/s-353MiB/s (370MB/s-370MB/s), io=10.0GiB (10.7GB), run=29008-29008msec
> > 
> > Clearly both bandwidth and iops are worse. However I'm puzzled as to why this is 
> > the case, given that I don't see how this patch affects the submission of 
> > readahead io. 
> > 
> >  fs/btrfs/extent_io.c | 63 +++++++++++++-------------------------------
> >  1 file changed, 19 insertions(+), 44 deletions(-)
> 
> Revisiting the patch and the results IMHO it shouldn't be RFC and is
> ready for merging.

I almost missed it. Please resend it without RFC, update the changelog
with anything relevant that came out of the discussion and fix typos and
coding style. The subject should describe what's the core of the change,
removing __extent_readpages is IMHO just a side effect. Thanks.
