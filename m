Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36983 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932226AbdGTSOk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 14:14:40 -0400
Received: by mail-pg0-f52.google.com with SMTP id y129so18012449pgy.4
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 11:14:40 -0700 (PDT)
Date: Thu, 20 Jul 2017 11:14:38 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720181438.GC29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500572904.7266.11.camel@scientia.net>
 <20170720175551.GB29924@vader.DHCP.thefacebook.com>
 <1500574012.7266.13.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500574012.7266.13.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 08:06:52PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 10:55 -0700, Omar Sandoval wrote:
> > Against 4.12 would be best, thanks!
> okay,.. but that will take a while to compile...
> 
> 
> in the meantime... do you know whether it's more or less safe to use
> the 4.9 kernel without any fix, when I change the parameters mentioned
> before, during the massive copying?

Yes, that's a safe enough workaround. It's a good idea to change the
parameters back after the copy.

> Cheers,
> Chris.
