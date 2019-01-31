Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A6FC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4605B218AF
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 14:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbfAaOhN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 09:37:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:37588 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730070AbfAaOhM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 09:37:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99C1EACB1;
        Thu, 31 Jan 2019 14:37:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3B183DA7D6; Thu, 31 Jan 2019 15:36:37 +0100 (CET)
Date:   Thu, 31 Jan 2019 15:36:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 04/12] btrfs: extent_io: Move the BUG_ON() in
 flush_write_bio() one level up
Message-ID: <20190131143637.GF2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190125050925.30754-1-wqu@suse.com>
 <20190125050925.30754-5-wqu@suse.com>
 <20190130151914.GU2900@twin.jikos.cz>
 <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3893155e-d3c3-5fd0-6f61-ae067d341d81@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 08:45:42AM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/1/30 下午11:19, David Sterba wrote:
> > On Fri, Jan 25, 2019 at 01:09:17PM +0800, Qu Wenruo wrote:
> >> +static int __must_check flush_write_bio(struct extent_page_data *epd)
> >>  {
> >> -	if (epd->bio) {
> >> -		int ret;
> >> +	int ret = 0;
> >>  
> >> +	if (epd->bio) {
> >>  		ret = submit_one_bio(epd->bio, 0, 0);
> >> -		BUG_ON(ret < 0); /* -ENOMEM */
> >>  		epd->bio = NULL;
> > 
> > I'm not sure if resetting epd->bio to NULL is all that needs to be done
> > here. With the BUG_ON the error case never happens so if all goes fine
> > it's also ok to set it to NULL and continue. But the callers might need
> > to send the flush again.
> 
> If flush_write_bio() get called again on the failed one, it will just
> get skipped as  epd->bio is NULL, submit_one_bio() will not be triggered.

Yes that's clear, but what is the state of the bio that went to
flush_write_bio and submit_one_bio failed?
