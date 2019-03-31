Return-Path: <SRS0=hyUm=SC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE12CC10F06
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 22:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B83CD20870
	for <linux-btrfs@archiver.kernel.org>; Sun, 31 Mar 2019 22:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731406AbfCaWpy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 31 Mar 2019 18:45:54 -0400
Received: from fieldses.org ([173.255.197.46]:34514 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbfCaWpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 31 Mar 2019 18:45:54 -0400
Received: by fieldses.org (Postfix, from userid 2815)
        id D30141EF6; Sun, 31 Mar 2019 18:45:53 -0400 (EDT)
Date:   Sun, 31 Mar 2019 18:45:53 -0400
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Supercilious Dude <supercilious.dude@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
Subject: Re: Is it possible that certain physical disk doesn't implement
 flush correctly?
Message-ID: <20190331224553.GA17421@fieldses.org>
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
 <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
 <16edb2d0-ee41-908f-e0bf-5c27160ccff7@gmx.com>
 <CAGmvKk5wk9RFhBr20X850MjFDkudzrZvjWVJxGg4GkhtrDfKUw@mail.gmail.com>
 <948a62d3-aa3e-418e-00df-d73d4dbfb5a6@gmx.com>
 <CAGmvKk5wFJNLbiJdYGA5PVFUnAURfN4Uk=JiGUaCndcepa51NA@mail.gmail.com>
 <4f5586f7-aef1-4e2a-2aee-5d040c023c68@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f5586f7-aef1-4e2a-2aee-5d040c023c68@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From:   bfields@fieldses.org (J. Bruce Fields)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Mar 30, 2019 at 09:24:37PM +0800, Qu Wenruo wrote:
> 
> 
> On 2019/3/30 下午9:14, Supercilious Dude wrote:
> > On Sat, 30 Mar 2019 at 13:09, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >>
> >> If controller is doing so, it must have its own power or at least finish
> >> flush when controller writes to its fast cache.
> >>
> > 
> > The controller has its own battery backup to power the DRAM cache, as
> > well as flash storage to dump it onto in the exceedingly unlikely
> > event that the battery gets depleted.
> > 
> >> For cache case, if we have enough data, we could still find some clue on
> >> the flush execution time.
> >>
> >> Despite that, for that enterprise level usage, it's OK.
> >>
> >> But for consumer level storage, I'm not sure, especially for HDDs, and
> >> maybe NVMe devices.
> >>
> > 
> > How do you distinguish who is a who? Am I an enterprise or a consumer?
> 
> Easy, price. :P
> 
> To be honest, I don't really care about that fancy use case.
> It's the vendor doing its work, and if something wrong happened,
> customer will yell at them.
> 
> I'm more interesting in the consumer level situation.

The feature seems to be advertised as "power loss protection" or
"enhanced power loss data protection".  Which makes it sound like a data
safety feature when really it's a performance feature.  E.g. these are
the Intel drives with "EPLDP":

	https://ark.intel.com/content/www/us/en/ark/search/featurefilter.html?productType=35125&0_EPLDP=True

Last I checked there were some that weren't too expensive.

--b.
