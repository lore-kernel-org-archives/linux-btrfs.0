Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1602DC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 19:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C916D20665
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 19:06:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C916D20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbeK2GJd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 01:09:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:48456 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729159AbeK2GJc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 01:09:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 16F11AFF1;
        Wed, 28 Nov 2018 19:06:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 84F59DAC7F; Wed, 28 Nov 2018 20:06:34 +0100 (CET)
Date:   Wed, 28 Nov 2018 20:06:34 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH 2/3] btrfs: wakeup cleaner thread when adding delayed iput
Message-ID: <20181128190633.GZ2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
References: <20181121190922.25038-1-josef@toxicpanda.com>
 <20181121190922.25038-3-josef@toxicpanda.com>
 <4e8aad56-42e2-d666-c909-d5d058b799c9@suse.com>
 <20181127195450.fjor2gewhp3hri56@macbook-pro-91.dhcp.thefacebook.com>
 <13D3592A-3719-4F9E-8E8A-944FE88F30D4@fb.com>
 <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181127200807.bdnvwap2kuuwuarg@macbook-pro-91.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 03:08:08PM -0500, Josef Bacik wrote:
> On Tue, Nov 27, 2018 at 07:59:42PM +0000, Chris Mason wrote:
> > On 27 Nov 2018, at 14:54, Josef Bacik wrote:
> > 
> > > On Tue, Nov 27, 2018 at 10:26:15AM +0200, Nikolay Borisov wrote:
> > >>
> > >>
> > >> On 21.11.18 г. 21:09 ч., Josef Bacik wrote:
> > >>> The cleaner thread usually takes care of delayed iputs, with the
> > >>> exception of the btrfs_end_transaction_throttle path.  The cleaner
> > >>> thread only gets woken up every 30 seconds, so instead wake it up to 
> > >>> do
> > >>> it's work so that we can free up that space as quickly as possible.
> > >>
> > >> Have you done any measurements how this affects the overall system. I
> > >> suspect this introduces a lot of noise since now we are going to be
> > >> doing a thread wakeup on every iput, does this give a chance to have
> > >> nice, large batches of iputs that  the cost of wake up can be 
> > >> amortized
> > >> across?
> > >
> > > I ran the whole patchset with our A/B testing stuff and the patchset 
> > > was a 5%
> > > win overall, so I'm inclined to think it's fine.  Thanks,
> > 
> > It's a good point though, a delayed wakeup may be less overhead.
> 
> Sure, but how do we go about that without it sometimes messing up?  In practice
> the only time we're doing this is at the end of finish_ordered_io, so likely to
> not be a constant stream.  I suppose since we have places where we force it to
> run that we don't really need this.  IDK, I'm fine with dropping it.  Thanks,

The transaction thread wakes up cleaner periodically (commit interval,
30s by default), so the time to process iputs is not unbounded.

I have the same concerns as Nikolay, coupling the wakeup to all delayed
iputs could result in smaller batches. But some of the callers of
btrfs_add_delayed_iput might benefit from the extra wakeup, like
btrfs_remove_block_group, so I don't want to leave the idea yet.
