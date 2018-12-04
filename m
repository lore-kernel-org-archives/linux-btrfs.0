Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A353C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7AA2081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD7AA2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbeLDOrf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:47:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:55306 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbeLDOrf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 09:47:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6CCCACB8;
        Tue,  4 Dec 2018 14:47:31 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 007D3DAC39; Tue,  4 Dec 2018 15:47:12 +0100 (CET)
Date:   Tue, 4 Dec 2018 15:47:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] Btrfs: fix deadlock with memory reclaim during scrub
Message-ID: <20181204144711.GV17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181123134543.20199-1-fdmanana@kernel.org>
 <20181123182540.7206-1-fdmanana@kernel.org>
 <20181126181711.GI2842@twin.jikos.cz>
 <CAL3q7H5kGb9otnqmOGddOGvnT3BnNG6hZHVaBUaOJrOXawVNAA@mail.gmail.com>
 <20181128142217.GO2842@twin.jikos.cz>
 <CAL3q7H6nEFPa20iPLuap7xNpSugTScDt+Z1zvf1WS1dOpOtFDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6nEFPa20iPLuap7xNpSugTScDt+Z1zvf1WS1dOpOtFDg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 28, 2018 at 02:40:07PM +0000, Filipe Manana wrote:
> > > Well, the worker tasks can also not use gfp_kernel, since the scrub
> > > task waits for them to complete before pausing.
> > > I missed this, and 2 reviewers as well, so perhaps it wasn't that
> > > trivial and I shouldn't feel that I miserably failed to identify all
> > > cases for something rather trivial. V5 sent.
> >
> > You can say that you left it there intentionally, such cookies are a
> > good drill for reviewers to stay sharp.
> 
> Unfortunately for me, it was not on purpose.
> 
> However there's the small drill of, for the workers only, potentially
> moving the memalloc_nofs_save() and
> restore to scrub_handle_errored_block(), since the only two possible
> gfp_kernel allocations for workers
> are during the case where a repair is needed:
> 
> scrub_bio_end_io_worker()
>   scrub_block_complete()
>     scrub_handle_errored_block()
>       lock_full_stripe()
>         insert_full_stripe_lock()
>           -> kmalloc with GFP_KERNEL
> 
> 
> scrub_bio_end_io_worker()
>    scrub_block_complete()
>      scrub_handle_errored_block()
>        scrub_write_page_to_dev_replace()
>          scrub_add_page_to_wr_bio()
>            -> kzalloc with GFP_KERNEL
> 
> Just to avoid some duplication.

Sounds like a nice cleanup and more in line with the idea of scoped
GFP_NOFS, the markers should be at a higher level. Starting at the
bottom of the callstack is fine as it's obvious where we want the nofs
protection, and then push it up the call chain. That way it's easier to
review. Please send a followup patch, thanks.
