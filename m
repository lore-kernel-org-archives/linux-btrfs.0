Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49873C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:40:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B02020737
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 16:40:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgFIQkf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 12:40:35 -0400
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:44916 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731073AbgFIQkb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 12:40:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 2F7D4183B25B7;
        Tue,  9 Jun 2020 16:40:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: paste04_0b0768b26dc4
X-Filterd-Recvd-Size: 1978
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Tue,  9 Jun 2020 16:40:27 +0000 (UTC)
Message-ID: <2bf362d58b320b3081703d75ea419274fb889e9a.camel@perches.com>
Subject: Re: [PATCH v3 0/7] Venus dynamic debug
From:   Joe Perches <joe@perches.com>
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@akamai.com>
Date:   Tue, 09 Jun 2020 09:40:26 -0700
In-Reply-To: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-06-09 at 13:45 +0300, Stanimir Varbanov wrote:
> Hello,
> 
> Here is the third version of dynamic debug improvements in Venus
> driver.  As has been suggested on previous version by Joe [1] I've
> made the relevant changes in dynamic debug core to handle leveling
> as more generic way and not open-code/workaround it in the driver.
> 
> About changes:
>  - added change in the dynamic_debug and in documentation
>  - added respective pr_debug_level and dev_dbg_level
> 
> regards,
> Stan
> 
> [1] https://lkml.org/lkml/2020/5/21/668

This capability is already clumsily used by many
drivers that use a module level "debug" flag.

$ git grep -P "MODULE_PARM.*\bdebug\b"|wc -l
501

That's a _lot_ of homebrewed mechanisms.

Making dynamic debug have this as a feature would
help consolidate and standardize the capability.

ftrace is definitely useful, but not quite as
lightweight and doesn't have the typical uses.


