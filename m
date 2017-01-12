Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34636 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbdALThY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 14:37:24 -0500
Message-ID: <1484249839.4987.17.camel@gmail.com>
Subject: Re: master - btrfs lockdep splat
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: bo.li.liu@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Date: Thu, 12 Jan 2017 20:37:19 +0100
In-Reply-To: <20170112184427.GB24433@localhost.localdomain>
References: <1484244732.4987.11.camel@gmail.com>
         <20170112184427.GB24433@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-01-12 at 10:44 -0800, Liu Bo wrote:
> On Thu, Jan 12, 2017 at 07:12:12PM +0100, Mike Galbraith wrote:
> > Greetings,
> > 
> > I wanted to do some -rt testing, but seems non-rt kernels aren't
> > lockdep clean with btrfs /, making -rt testing a bit premature.
> > 
> > (hm, 28a235931 Btrfs: fix lockdep warning on deadlock against an inode's log mutex)
> 
> It's rather a false-positive lockdep warning than a real deadlock, and a
> patch[1] has been queued to fix it.

(yeah, just stops lockdep from perhaps finding something real)

> [1]: https://patchwork.kernel.org/patch/9473431/

Yup, virtual box seems to be a happy camper now.  Thanks.

	-Mike

