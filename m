Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDB3C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 19:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BEB20656
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 19:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbgFJTuC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 15:50:02 -0400
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:34158 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730085AbgFJTuC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jun 2020 15:50:02 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 700B5180295B8;
        Wed, 10 Jun 2020 19:50:00 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: blade08_160868726dcd
X-Filterd-Recvd-Size: 1819
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 19:49:58 +0000 (UTC)
Message-ID: <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>
Date:   Wed, 10 Jun 2020 12:49:57 -0700
In-Reply-To: <20200610133717.GB1906670@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2020-06-10 at 15:37 +0200, Greg Kroah-Hartman wrote:
> Please work with the infrastructure we have, we have spent a lot of time
> and effort to make it uniform to make it easier for users and
> developers.

Not quite.

This lack of debug grouping by type has been a
_long_ standing issue with drivers.

> Don't regress and try to make driver-specific ways of doing
> things, that way lies madness...

It's not driver specific, it allows driver developers to
better isolate various debug states instead of keeping
lists of specific debug messages and enabling them
individually.


