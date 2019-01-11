Return-Path: <SRS0=hHgh=PT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E127EC43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 09:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4BE320872
	for <linux-btrfs@archiver.kernel.org>; Fri, 11 Jan 2019 09:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfAKJ0k (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 11 Jan 2019 04:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbfAKJ0k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 Jan 2019 04:26:40 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 501A0122E92;
        Fri, 11 Jan 2019 09:26:40 +0000 (UTC)
Received: from ming.t460p (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E48475D6A9;
        Fri, 11 Jan 2019 09:26:34 +0000 (UTC)
Date:   Fri, 11 Jan 2019 17:26:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, Dmitriy Gorokh <dmitriy.gorokh@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: raid56: data corruption on a device removal
Message-ID: <20190111092628.GB6265@ming.t460p>
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
 <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
 <20190104164943.GU23615@twin.jikos.cz>
 <0a356978-4d95-7597-b71a-d502e94c2461@suse.de>
 <20190107153456.GW23615@twin.jikos.cz>
 <be8f867e-deee-ccbd-65c5-e4140fdf7b8c@suse.de>
 <7e1204a4-ed81-7989-f479-f1ee9d0dfd64@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e1204a4-ed81-7989-f479-f1ee9d0dfd64@suse.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 11 Jan 2019 09:26:40 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 11, 2019 at 09:08:27AM +0100, Johannes Thumshirn wrote:
> On 10/01/2019 17:49, Johannes Thumshirn wrote:
> > Right, but we're looking for the number of already completed bytes to
> > rewind here, so from bvec.h's docs it is bi_bvec_done.
> > 
> > Dmitriy can you see if this works for you:
> > 
> > diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> > index e74455eb42f9..2d0e2eec5413 100644
> > --- a/fs/btrfs/raid56.c
> > +++ b/fs/btrfs/raid56.c
> > @@ -1350,6 +1350,7 @@ static int find_bio_stripe(struct btrfs_raid_bio
> > *rbio,
> >         struct btrfs_bio_stripe *stripe;
> > 
> >         physical <<= 9;
> > +       physical -= bio->bi_iter.bi_bvec_done;
> 
> OK talked to Hannes about this issue, he says the only way is to save
> the iterator state before submitting the bio.
> 
> So the above is bogus too.
> 
> This also is what Kent said in
> https://marc.info/?l=linux-block&m=153549921116441&w=2

Yeah, .bi_bvec_done can't help, seems you need to take the similar
approach in 7759eb23fd9808a2e ("block: remove bio_rewind_iter()").

In theory, the follow way might work, but still like a hack:

	#define BVEC_ITER_ALL_INIT (struct bvec_iter)                  \
	{                                                              \
	        .bi_sector      = 0,                                   \
	        .bi_size        = UINT_MAX,                            \
	        .bi_idx         = 0,                                   \
	        .bi_bvec_done   = 0,                                   \
	}
	
	old_bi_sector = bio->bi_iter.bi_sector;
	bio->bi_iter = BVEC_ITER_ALL_INIT;
	bio->bi_iter.bi_sector = old_bi_sector;
	bio_advance(bio, where_to_rewind);

This bio can't be the fast-cloned one, which should be satisfied
by fs code.

Also 'where_to_rewind' needs to point to the offset relative to start
of this bio.


Thanks,
Ming
