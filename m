Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33289 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964809AbdGTRcQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Jul 2017 13:32:16 -0400
Received: by mail-pg0-f53.google.com with SMTP id k14so17749115pgr.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Jul 2017 10:32:16 -0700 (PDT)
Date: Thu, 20 Jul 2017 10:32:14 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: Re: strange No space left on device issues
Message-ID: <20170720173214.GA29924@vader.DHCP.thefacebook.com>
References: <1500561549.7266.1.camel@scientia.net>
 <0102015d6083ffde-e6d15fd5-6e66-41a0-9ddf-af163c96ebd8-000000@eu-west-1.amazonses.com>
 <1500564013.7266.8.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500564013.7266.8.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 20, 2017 at 05:20:13PM +0200, Christoph Anton Mitterer wrote:
> On Thu, 2017-07-20 at 15:00 +0000, Martin Raiber wrote:
> > It would be interesting if lowering the dirty ratio is a viable
> > work-around (sysctl vm.dirty_background_bytes=314572800 && sysctl
> > vm.dirty_bytes=1258291200).
> > 
> > Regards,
> > Martin
> 
> I took away a trailing 0 for each of them... and then it goes through
> without error....
> 
> sysctl vm.dirty_bytes=125829120
> vm.dirty_bytes = 125829120
> sysctl vm.dirty_background_bytes=31457280
> vm.dirty_background_bytes = 31457280
> 
> 
> But what does that mean now... could there be still any corruptions?
> And do you need to permanently set the value (until this is fixed in
> stable), or is this just necessary when I had this large copying
> operation?
> 
> 
> Cheers,
> Chris.

Could you try 4.12? If that doesn't work, could you please also try
https://patchwork.kernel.org/patch/9829593/?
