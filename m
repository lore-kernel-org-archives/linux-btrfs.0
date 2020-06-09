Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C09C433DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:58:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE56520774
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgFIQ6P (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 12:58:15 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:60760 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731061AbgFIQ6M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 12:58:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 48FFD100462CE;
        Tue,  9 Jun 2020 16:58:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: paper32_280912f26dc4
X-Filterd-Recvd-Size: 2234
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:58:08 +0000 (UTC)
Message-ID: <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
Date:   Tue, 09 Jun 2020 09:58:07 -0700
In-Reply-To: <20200609111615.GD780233@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-2-stanimir.varbanov@linaro.org>
         <20200609111615.GD780233@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> What is wrong with the existing control of dynamic
> debug messages that you want to add another type of arbitrary grouping
> to it? 

There is no existing grouping mechanism.

Many drivers and some subsystems used an internal one
before dynamic debug.

$ git grep "MODULE_PARM.*\bdebug\b"|wc -l
501

This is an attempt to unify those homebrew mechanisms.

Stanimir attempted to add one for his driver via a
driver specific standardized format substring for level.

> And who defines that grouping?

Individual driver authors

> Will it be driver/subsystem/arch/author specific?  Or kernel-wide?

driver specific

> This feels like it could easily get out of hand really quickly.

Likely not.  A question might be how useful all these
old debugging printks are today and if it's reasonable
to just delete them.

> Why not just use tracepoints if you really want to be fine-grained?

Weight and lack of class/group capability


