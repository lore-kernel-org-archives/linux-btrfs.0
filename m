Return-Path: <SRS0=xGl5=7Y=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0314FC433E0
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 22:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD8482073E
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Jun 2020 22:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgFKWdv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Jun 2020 18:33:51 -0400
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:43012 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726270AbgFKWdu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jun 2020 18:33:50 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id D65CC18029123;
        Thu, 11 Jun 2020 22:33:48 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cakes14_3209fc126dd7
X-Filterd-Recvd-Size: 4066
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf14.hostedemail.com (Postfix) with ESMTPA;
        Thu, 11 Jun 2020 22:33:46 +0000 (UTC)
Message-ID: <3518483f1836bdfbc193292dc1639509ac33fe7c.camel@perches.com>
Subject: Re: [PATCH v3 6/7] venus: Make debug infrastructure more flexible
From:   Joe Perches <joe@perches.com>
To:     Jason Baron <jbaron@akamai.com>, jim.cromie@gmail.com,
        Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 11 Jun 2020 15:33:45 -0700
In-Reply-To: <e65d2c81-6d0b-3c1e-582c-56d707c0d1f1@akamai.com>
References: <20200609104604.1594-7-stanimir.varbanov@linaro.org>
         <20200609111414.GC780233@kroah.com>
         <dc85bf9e-e3a6-15a1-afaa-0add3e878573@linaro.org>
         <20200610133717.GB1906670@kroah.com>
         <31e1aa72b41f9ff19094476033511442bb6ccda0.camel@perches.com>
         <2fab7f999a6b5e5354b23d06aea31c5018b9ce18.camel@perches.com>
         <20200611062648.GA2529349@kroah.com>
         <bc92ee5948c3e71b8f1de1930336bbe162d00b34.camel@perches.com>
         <20200611105217.73xwkd2yczqotkyo@holly.lan>
         <ed7dd5b4-aace-7558-d012-fb16ce8c92d6@linaro.org>
         <20200611121817.narzkqf5x7cvl6hp@holly.lan>
         <CAJfuBxzE=A0vzsjNai_jU_16R_P0haYA-FHnjZcaHOR_3fy__A@mail.gmail.com>
         <e65d2c81-6d0b-3c1e-582c-56d707c0d1f1@akamai.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, 2020-06-11 at 17:59 -0400, Jason Baron wrote:
> 
> On 6/11/20 5:19 PM, jim.cromie@gmail.com wrote:
> > trimmed..
> > 
> > > > > Currently I think there not enough "levels" to map something like
> > > > > drm.debug to the new dyn dbg feature. I don't think it is intrinsic
> > > > > but I couldn't find the bit of the code where the 5-bit level in struct
> > > > > _ddebug is converted from a mask to a bit number and vice-versa.
> > > > 
> > > > Here [1] is Joe's initial suggestion. But I decided that bitmask is a
> > > > good start for the discussion.
> > > > 
> > > > I guess we can add new member uint "level" in struct _ddebug so that we
> > > > can cover more "levels" (types, groups).
> > > 
> > > I don't think it is allocating only 5 bits that is the problem!

There were 6 unused bits in struct _ddebug;

The original idea was to avoid expanding the already somewhat
large struct _ddebug uses and the __verbose/__dyndbg section
that can have quite a lot of these structs.

I imagine adding another int or long wouldn't be too bad.

> > > The problem is that those 5 bits need not be encoded as a bitmask by
> > > dyndbg, that can simply be the category code for the message. They only
> > > need be converted into a mask when we compare them to the mask provided
> > > by the user.
> > > 

I also suggested adding a pointer to whatever is provided
by the developer so the address of something like
MODULE_PARM_DESC(variable, ...) can be also be used.

> > heres what I have in mind.  whats described here is working.
> > I'll send it out soon
> 
> Cool. thanks for working on this!

Truly, thank you both Jim and Stanimir.

Please remember that dynamic_debug is not required and
pr_debug should still work.

> >     API:
> > 
> >     - change pr_debug(...)  -->  pr_debug_typed(type_id=0, ...)
> >     - all existing uses have type_id=0
> >     - developer creates exclusive types of log messages with type_id>0
> >       1, 2, 3 are disjoint groups, for example: hi, mid, low

You could have a u8 for type if there are to be 3 classes

	bitmask
	level
	group by value

though I believe group by value might as well just be bitmask
and bool is_bitmask is enough (!is_bitmask would be level)

cheers, Joe

