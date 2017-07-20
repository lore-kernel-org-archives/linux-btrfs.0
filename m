Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:32856 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965196AbdGTVTl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 17:19:41 -0400
Received: by mail-pg0-f54.google.com with SMTP id k14so19907439pgr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 14:19:41 -0700 (PDT)
Date: Thu, 20 Jul 2017 14:19:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720211940.GD29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500572904.7266.11.camel@scientia.net>
 <20170720175551.GB29924@vader.DHCP.thefacebook.com>
 <1500574012.7266.13.camel@scientia.net>
 <20170720181438.GC29924@vader.DHCP.thefacebook.com>
 <1500582495.7266.16.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500582495.7266.16.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 10:28:15PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 11:14 -0700, Omar Sandoval wrote:
> > Yes, that's a safe enough workaround. It's a good idea to change the
> > parameters back after the copy.
> you mean even without having the fix, right?

Yes, even without the fix you should be okay.

> So AFAIU, the bug doesn't really cause FS corruption, but just "false"
> ENOSPC and these happen during having meta-data creating (e.g. during
> operations like mine) only?

Right.
