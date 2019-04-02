Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E36AC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 15:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A3820645
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 15:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbfDBPvb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 11:51:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbfDBPvb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 11:51:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA5A0AEB0
        for <linux-btrfs@vger.kernel.org>; Tue,  2 Apr 2019 15:51:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 246CEDA824; Tue,  2 Apr 2019 17:52:40 +0200 (CEST)
Date:   Tue, 2 Apr 2019 17:52:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 03/15] btrfs: Handle pending/pinned chunks before
 blockgroup relocation during device shrink
Message-ID: <20190402155239.GC29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190327122418.24027-1-nborisov@suse.com>
 <20190327122418.24027-4-nborisov@suse.com>
 <20190401182639.GZ29086@twin.jikos.cz>
 <e2f491ab-4f3e-f889-e711-8138338096c4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e2f491ab-4f3e-f889-e711-8138338096c4@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 02, 2019 at 08:55:32AM +0300, Nikolay Borisov wrote:
> 
> 
> On 1.04.19 г. 21:26 ч., David Sterba wrote:
> > On Wed, Mar 27, 2019 at 02:24:06PM +0200, Nikolay Borisov wrote:
> >> During device shrink pinned/pending chunks (i.e those which have been
> >> deleted/created respectively, in the current transaction and haven't
> >> touched disk) need to be accounted when doing device shrink. Presently
> >> this happens after the main relocation loop in btrfs_shrink_device,
> >> which could lead to making another go in the body of the function.
> >>
> >> Since there is no hard requirement to perform pinned/pending chunks
> >> handling after the relocation loop, move the code before it. This leads
> >> to simplifying the code flow around - i.e no need to use 'goto again'.
> > 
> > On the other hand this starts 2 transactions unconditionally, previously
> > it was 1 for the final change and 1 if there were pending chunks. This
> > should be mentioned or explained why this is needed, otherwise the code
> > looks equivalent to the original version. In this case some guidance in
> > the changelog could shorten the time to understand the change, I've been
> > starting at it for half an hour.
> > 
> 
> Valid point, how about adding the following sentence at the end of the
> changelog :
> 
> A notable side effect of this change is that modification of the
> device's size requires a transaction to be started and committed before
> the relocation loop starts. This is necessary to ensure that relocation
> process sees the shrunk device size.

Thanks, patch updated.
