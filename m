Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535AAC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3427C2072F
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 22:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgFIWXN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 18:23:13 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:37066 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728191AbgFIWXM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 18:23:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2F710180CE42F;
        Tue,  9 Jun 2020 22:23:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: ant44_0c05fb026dc6
X-Filterd-Recvd-Size: 4029
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 22:23:08 +0000 (UTC)
Message-ID: <6115b15ced02686f7408417411ff758445b42421.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
From:   Joe Perches <joe@perches.com>
To:     jim.cromie@gmail.com,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Date:   Tue, 09 Jun 2020 15:23:07 -0700
In-Reply-To: <CAJfuBxwyDysP30cMWDusw4CsSQitchA5hOKkpk1PktbsbCKTSw@mail.gmail.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609111323.GA19604@bombadil.infradead.org>
         <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
         <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
         <CAJfuBxwyDysP30cMWDusw4CsSQitchA5hOKkpk1PktbsbCKTSw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-06-09 at 15:21 -0600, jim.cromie@gmail.com wrote:
> On Tue, Jun 9, 2020 at 10:49 AM Joe Perches <joe@perches.com> wrote:
> > (adding Jim Cromie and comments)
> > On Tue, 2020-06-09 at 09:03 -0700, Randy Dunlap wrote:
> > > On 6/9/20 4:13 AM, Matthew Wilcox wrote:
> > > > On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
> > > > > Here is the third version of dynamic debug improvements in Venus
> > > > > driver.  As has been suggested on previous version by Joe [1] I've
> > > > > made the relevant changes in dynamic debug core to handle leveling
> > > > > as more generic way and not open-code/workaround it in the driver.
> > > > > 
> > > > > About changes:
> > > > >  - added change in the dynamic_debug and in documentation
> > > > >  - added respective pr_debug_level and dev_dbg_level
> > > > 
> > > > Honestly, this seems like you want to use tracepoints, not dynamic debug.
> > 
> > Tracepoints are a bit heavy and do not have any class
> > or grouping mechanism.
> > 
> > debug_class is likely a better name than debug_level
> > 
> > > Also see this patch series:
> > > https://lore.kernel.org/lkml/20200605162645.289174-1-jim.cromie@gmail.com/
> > > [PATCH 00/16] dynamic_debug: cleanups, 2 features
> > > 
> > > It adds/expands dynamic debug flags quite a bit.
> > 
> > Yes, and thanks Randy and Jim and Stanimir
> > 
> > I haven't gone through Jim's proposal enough yet.
> > It's unfortunate these patches series conflict.
> > 
> > And for Jim, a link to Stanimir's patch series:
> > https://lore.kernel.org/lkml/20200609104604.1594-1-stanimir.varbanov@linaro.org/
> > 
> > 
> 
> As Joe noted, there is a lot of ad-hockery to possibly clean up,
> but I dont grok how these levels should be distinguished from
> KERN_(WARN|INFO|DEBUG) constants.

These are not KERN_<LEVEL> at all, all are emitted at KERN_DEBUG

These are just driver developer mechanisms to enable/disable
groups of formats via some test for < level or | bitmap

> Those constants are used by coders, partly to convey how bad things are
> As a user, Id be reluctant to disable an EMERG callsite.

Not possible.

> are you trying to add a User Bit ? or maybe 7-9 of them ?

Or maybe a u32/ulong worth as most as I think the largest
current use is 32 bits of bitmask.

> I have a patchset which adds a 'u' flag, for user.

Adapting that with an external bool for bitmask or class
would work fine.

	if (is_bitmask)
		enable/disable(value|flag)
	else
		enable/disable(value < flag)

So the equivalent of logical sets would work just fine.


