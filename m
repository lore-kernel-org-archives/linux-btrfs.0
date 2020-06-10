Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FA2C433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2A7207ED
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 06:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgFJGfi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 02:35:38 -0400
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:35340 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbgFJGfg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jun 2020 02:35:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 90372182CF665;
        Wed, 10 Jun 2020 06:35:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: fork19_2e0cbf626dc9
X-Filterd-Recvd-Size: 2396
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 06:35:32 +0000 (UTC)
Message-ID: <f94b2abe85d7c849ca76677ff5a1e0b272bb3bdf.camel@perches.com>
Subject: Re: [PATCH v3 1/7] Documentation: dynamic-debug: Add description of
 level bitmask
From:   Joe Perches <joe@perches.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jim Cromie <jim.cromie@gmail.com>
Date:   Tue, 09 Jun 2020 23:35:31 -0700
In-Reply-To: <20200610063103.GD1907120@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-2-stanimir.varbanov@linaro.org>
         <20200609111615.GD780233@kroah.com>
         <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
         <20200610063103.GD1907120@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2020-06-10 at 08:31 +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 09, 2020 at 09:58:07AM -0700, Joe Perches wrote:
> > On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> > > What is wrong with the existing control of dynamic
> > > debug messages that you want to add another type of arbitrary grouping
> > > to it? 
> > 
> > There is no existing grouping mechanism.
> 
> info/warn/err/dbg is what I am referring to.
> 
> > Many drivers and some subsystems used an internal one
> > before dynamic debug.
> > 
> > $ git grep "MODULE_PARM.*\bdebug\b"|wc -l
> > 501
> 
> Yes, and it's horrid and needs to be cleaned up, not added to.

Or unified so driver authors have a standardized mechanism
rather than reinventing or doing things differently.

> In the beginning, yes, adding loads of different types of debugging
> options to a driver is needed by the author, but by the time it is added
> to the kernel, all of that should be able to be removed and only a
> single "enable debug" should be all that is needed.

No one does that.


