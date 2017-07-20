Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:36650 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755582AbdGTRzy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 13:55:54 -0400
Received: by mail-pg0-f50.google.com with SMTP id 125so17855610pgi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 10:55:53 -0700 (PDT)
Date: Thu, 20 Jul 2017 10:55:51 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720175551.GB29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
 <20170720173214.GA29924@vader.DHCP.thefacebook.com>
 <1500572904.7266.11.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500572904.7266.11.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 07:48:24PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 10:32 -0700, Omar Sandoval wrote:
> > Could you try 4.12?
> Linux 4.12.0-trunk-amd64 #1 SMP Debian 4.12.2-1~exp1 (2017-07-18)
> x86_64 GNU/Linux
> from Debian experimental, doesn't fix the issue...

Okay, didn't think it would :)

> >  If that doesn't work, could you please also try
> > https://patchwork.kernel.org/patch/9829593/?
> Against 4.9?

Against 4.12 would be best, thanks!
