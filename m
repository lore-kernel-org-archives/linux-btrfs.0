Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA49FC433E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 06:42:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3152072F
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 06:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgFKGmv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 02:42:51 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:53622 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgFKGmv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 02:42:51 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 3ECF0182CED34;
        Thu, 11 Jun 2020 06:42:49 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: milk04_120e82326dd1
X-Filterd-Recvd-Size: 3673
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 11 Jun 2020 06:42:47 +0000 (UTC)
Message-ID: <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Date:   Wed, 10 Jun 2020 23:42:43 -0700
In-Reply-To: <20200611062648.GA2529349@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
         <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
         <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
         <20200611062648.GA2529349@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 2020-06-11 at 08:26 +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 10, 2020 at 01:23:56PM -0700, Joe Perches wrote:
> > On Wed, 2020-06-10 at 12:49 -0700, Joe Perches wrote:
> > > On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> > > > Please work with the infrastructure we have, we have spent a lot of time
> > > > and effort to make it uniform to make it easier for users and
> > > > developers.
> > > 
> > > Not quite.
> > > 
> > > This lack of debug grouping by type has been a
> > > _long_ standing issue with drivers.
> > > 
> > > > Don't regress and try to make driver-specific ways of doing
> > > > things, that way lies madness...
> > > 
> > > It's not driver specific, it allows driver developers to
> > > better isolate various debug states instead of keeping
> > > lists of specific debug messages and enabling them
> > > individually.
> > 
> > For instance, look at the homebrew content in
> > drivers/gpu/drm/drm_print.c that does _not_ use
> > dynamic_debug.
> > 
> > MODULE_PARM_DESC(debug, "Enable debug output, where each bit enables a debug category.\n"
> > "\t\tBit 0 (0x01)  will enable CORE messages (drm core code)\n"
> > "\t\tBit 1 (0x02)  will enable DRIVER messages (drm controller code)\n"
> > "\t\tBit 2 (0x04)  will enable KMS messages (modesetting code)\n"
> > "\t\tBit 3 (0x08)  will enable PRIME messages (prime code)\n"
> > "\t\tBit 4 (0x10)  will enable ATOMIC messages (atomic code)\n"
> > "\t\tBit 5 (0x20)  will enable VBL messages (vblank code)\n"
> > "\t\tBit 7 (0x80)  will enable LEASE messages (leasing code)\n"
> > "\t\tBit 8 (0x100) will enable DP messages (displayport code)");
> > module_param_named(debug, __drm_debug, int, 0600);
> > 
> > void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
> > 		 const char *format, ...)
> > {
> > 	struct va_format vaf;
> > 	va_list args;
> > 
> > 	if (!drm_debug_enabled(category))
> > 		return;
> 
> Ok, and will this proposal be able to handle stuff like this?

Yes, that's the entire point.

If it doesn't have the capability to handle stuff like this,
then no, it wouldn't be a good or useful change.

That includes the ability to work without dynamic debug and
perhaps still use a MODULE_PARM_DESC. 

