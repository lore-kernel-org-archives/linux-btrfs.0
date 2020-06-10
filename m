Return-Path: <SRS0=J01l=7X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675DBC433E0
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 07:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C3892064C
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Jun 2020 07:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFJHYa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 03:24:30 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:33160 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726081AbgFJHY3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jun 2020 03:24:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 2364F180A7FCA;
        Wed, 10 Jun 2020 07:24:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: toad10_2409db926dc9
X-Filterd-Recvd-Size: 2861
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed, 10 Jun 2020 07:24:26 +0000 (UTC)
Message-ID: <4b77ebf589ccc8ce0983539ce2fca4eba8f72a2a.camel@perches.com>
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
Date:   Wed, 10 Jun 2020 00:24:25 -0700
In-Reply-To: <20200610070949.GB1923109@kroah.com>
References: <20200609104604.1594-1-stanimir.varbanov@linaro.org>
         <20200609104604.1594-2-stanimir.varbanov@linaro.org>
         <20200609111615.GD780233@kroah.com>
         <ba32bfa93ac2e147c2e0d3a4724815a7bbf41c59.camel@perches.com>
         <20200610063103.GD1907120@kroah.com>
         <f94b2abe85d7c849ca76677ff5a1e0b272bb3bdf.camel@perches.com>
         <20200610070949.GB1923109@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, 2020-06-10 at 09:09 +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 09, 2020 at 11:35:31PM -0700, Joe Perches wrote:
> > On Wed, 2020-06-10 at 08:31 +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Jun 09, 2020 at 09:58:07AM -0700, Joe Perches wrote:
> > > > On Tue, 2020-06-09 at 13:16 +0200, Greg Kroah-Hartman wrote:
> > > > > What is wrong with the existing control of dynamic
> > > > > debug messages that you want to add another type of arbitrary grouping
> > > > > to it? 
> > > > 
> > > > There is no existing grouping mechanism.
> > > 
> > > info/warn/err/dbg is what I am referring to.

This is specifically about dbg so that's not relevant is it.
> But each "level" you all come up with will be intrepreted differently
> per driver, causing total confusion (like we have today.)  Try to make
> it better by just removing that mess.

Or add value as it allows the developer to do what's
necessary for their development.

> > > In the beginning, yes, adding loads of different types of debugging
> > > options to a driver is needed by the author, but by the time it is added
> > > to the kernel, all of that should be able to be removed and only a
> > > single "enable debug" should be all that is needed.
> > 
> > No one does that.
> 
> We did that for USB drivers a decade ago, it can be done.

And nearly no one does it.

btw: look up usbip_debug_flag and usbip_dbg_<foo> or the uhci driver


