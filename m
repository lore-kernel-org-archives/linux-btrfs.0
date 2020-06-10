Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF33C433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 01:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36B72072E
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 01:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgFJB6J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 21:58:09 -0400
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:45420 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725944AbgFJB6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Jun 2020 21:58:07 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 055DD181D3762;
        Wed, 10 Jun 2020 01:58:06 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: offer29_1915d5526dc7
X-Filterd-Recvd-Size: 1763
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 01:58:03 +0000 (UTC)
Message-ID: <60799af26082bb05e92a7a74031e3fe88ebf87df.camel@perches.com>
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
Date:   Tue, 09 Jun 2020 18:58:02 -0700
In-Reply-To: <6115b15ced02686f7408417411ff758445b42421.camel@perches.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609111323.GA19604@bombadil.infradead.org>
         <c239d5df-e069-2091-589e-30f341c2cbd3@infradead.org>
         <9a79aded6981ec47f1f8b317b784e6e44158ac61.camel@perches.com>
         <CAJfuBxwyDysP30cMWDusw4CsSQitchA5hOKkpk1PktbsbCKTSw@mail.gmail.com>
         <6115b15ced02686f7408417411ff758445b42421.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-06-09 at 15:23 -0700, Joe Perches wrote:
> These are just driver developer mechanisms to enable/disable
> groups of formats via some test for < level or | bitmap

duh: & bitmask

> 	if (is_bitmask)
> 		enable/disable(value|flag)

obviously
		enable/disable(value & flag)


