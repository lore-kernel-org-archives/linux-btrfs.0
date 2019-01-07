Return-Path: <SRS0=zk84=PP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B84FC43387
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 15:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0C0206C0
	for <linux-btrfs@archiver.kernel.org>; Mon,  7 Jan 2019 15:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729912AbfAGPf2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 7 Jan 2019 10:35:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:43140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbfAGPf2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Jan 2019 10:35:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2AC73AFAF;
        Mon,  7 Jan 2019 15:35:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9BF77DA7E8; Mon,  7 Jan 2019 16:34:56 +0100 (CET)
Date:   Mon, 7 Jan 2019 16:34:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, Dmitriy Gorokh <dmitriy.gorokh@gmail.com>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2] btrfs: raid56: data corruption on a device removal
Message-ID: <20190107153456.GW23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        Dmitriy Gorokh <dmitriy.gorokh@gmail.com>,
        linux-btrfs@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
References: <66F8D435-4E51-4761-B6CF-BA96F4BC5986@wdc.com>
 <CANYdAbLNAxoAXcxuC+ugpdhsCpTbh0zVjY3T5rtOcpVufnmWRA@mail.gmail.com>
 <20190104164943.GU23615@twin.jikos.cz>
 <0a356978-4d95-7597-b71a-d502e94c2461@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a356978-4d95-7597-b71a-d502e94c2461@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 07, 2019 at 12:03:43PM +0100, Johannes Thumshirn wrote:
> >> + /*
> >> +  * Since the failed bio can return partial data, bi_sector might be
> >> +  * incremented by that value. We need to revert it back to the
> >> +  * state before the bio was submitted.
> >> +  */
> >> + physical -= bio->bi_iter.bi_done;
> > 
> > The bi_done member has been removed in recent block layer changes
> > commit 7759eb23fd9808a2e4498cf36a798ed65cde78ae ("block: remove
> > bio_rewind_iter()"). I wonder what kind of block-magic do we need to do
> > as the iterators seem to be local and there's nothing available in the
> > call chain leading to find_bio_stripe. Johannes, any ideas?
> 
> Right, what we could do here is go the same way Ming did in
> 7759eb23fd980 ("block: remove bio_rewind_iter()") and save a bvec_iter
> somewhere before submission and then see if we returned partial data,
> but this somehow feels wrong to me (at least to do in btrfs code instead
> of the block layer).

> Ming can we resurrect ->bi_done, or do you have a different suggestion
> for finding about partial written bios?

I don't think bi_done can be resurrected
(https://marc.info/?l=linux-block&m=153549921116441&w=2) but I still am
not sure that saving the iterator is the right thing (or at least how to
do that right, not that the whole idea is wrong).
