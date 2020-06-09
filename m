Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF9CC433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B211A2078D
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbgFIQth (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 12:49:37 -0400
Received: from smtprelay0148.hostedemail.com ([216.40.44.148]:58246 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbgFIQtg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 12:49:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 07A511005E387;
        Tue,  9 Jun 2020 16:49:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: van97_43148ba26dc4
X-Filterd-Recvd-Size: 2619
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:49:31 +0000 (UTC)
Message-ID: <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
From:   Joe Perches <joe@perches.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Jim Cromie <jim.cromie@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Date:   Tue, 09 Jun 2020 09:49:30 -0700
In-Reply-To: <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609111323.GA19604@bombadil.infradead.org>
         <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

(adding Jim Cromie and comments)

On Tue, 2020-06-09 at 09:03 -0700, Randy Dunlap wrote:
> On 6/9/20 4:13 AM, Matthew Wilcox wrote:
> > On Tue, Jun 09, 2020 at 01:45:57PM +0300, Stanimir Varbanov wrote:
> > > Here is the third version of dynamic debug improvements in Venus
> > > driver.  As has been suggested on previous version by Joe [1] I've
> > > made the relevant changes in dynamic debug core to handle leveling
> > > as more generic way and not open-code/workaround it in the driver.
> > > 
> > > About changes:
> > >  - added change in the dynamic_debug and in documentation
> > >  - added respective pr_debug_level and dev_dbg_level
> > 
> > Honestly, this seems like you want to use tracepoints, not dynamic debug.

Tracepoints are a bit heavy and do not have any class
or grouping mechanism.

debug_class is likely a better name than debug_level

> Also see this patch series:
> https://lore.kernel.org/lkml/20200605162645.289174-1-jim.cromie@gmail.com/
> [PATCH 00/16] dynamic_debug: cleanups, 2 features
> 
> It adds/expands dynamic debug flags quite a bit.

Yes, and thanks Randy and Jim and Stanimir

I haven't gone through Jim's proposal enough yet.
It's unfortunate these patches series conflict.

And for Jim, a link to Stanimir's patch series:
https://lore.kernel.org/lkml/20200609104604.1594-1-stanimir.varbanov@linaro.org/


