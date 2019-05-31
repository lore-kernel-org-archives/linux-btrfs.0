Return-Path: <SRS0=YdAF=T7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0557CC04AB6
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA18726E4B
	for <linux-btrfs@archiver.kernel.org>; Fri, 31 May 2019 20:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfEaUi1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 31 May 2019 16:38:27 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:58745 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727576AbfEaUi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 May 2019 16:38:26 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 764EC3D05;
        Fri, 31 May 2019 20:38:24 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: price00_f062e7ab5c2e
X-Filterd-Recvd-Size: 1735
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 May 2019 20:38:23 +0000 (UTC)
Message-ID: <c7dd57c50690048c16722005bba1c47bcb3af750.camel@perches.com>
Subject: Re: [PATCH] btrfs: Fix -Wunused-but-set-variable warnings
From:   Joe Perches <joe@perches.com>
To:     Andrey Abramov <st5pub@yandex.ru>, "clm@fb.com" <clm@fb.com>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "dsterba@suse.com" <dsterba@suse.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Fri, 31 May 2019 13:38:22 -0700
In-Reply-To: <14843931559334698@myt6-add70abb4f02.qloud-c.yandex.net>
References: <20190531195349.31129-1-st5pub@yandex.ru>
         <a7a2a7c70c2dcef122ddbe86eb84820fc4384c7e.camel@perches.com>
         <14843931559334698@myt6-add70abb4f02.qloud-c.yandex.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, 2019-05-31 at 23:31 +0300, Andrey Abramov wrote:
> 31.05.2019, 23:05, "Joe Perches" <joe@perches.com>:
> > On Fri, 2019-05-31 at 22:53 +0300, Andrey Abramov wrote:
> > >  Fix -Wunused-but-set-variable warnings in raid56.c and sysfs.c files
> > These uses seem boolean, so perhaps just use bool?
> I used int because you use ints (as bools) everywhere (for example
> there is only one bool (as a function argument) in the entire raid56.c
> file with 3000 lines of code), so with int code looks more consistent.
> Are you sure that I should use bool?

That's up to you and the btrfs maintainers.


