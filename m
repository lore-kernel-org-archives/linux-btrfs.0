Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.knebb.de ([85.25.100.221]:55115 "EHLO mail.knebb.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbcKBJU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 05:20:28 -0400
Subject: Re: Resizing BTRFS - raw partition
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
 <20161102091249.GL16645@carfax.org.uk>
From: =?UTF-8?Q?Christian_V=c3=b6lker?= <cvoelker@knebb.de>
Message-ID: <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
Date: Wed, 2 Nov 2016 10:18:03 +0100
MIME-Version: 1.0
In-Reply-To: <20161102091249.GL16645@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

thanks for the quick reply. Regarding version- I prefer to use stable
Linux versions....and I am not going to upgrade just btrfs outside of
the verndors builds. So I am stuck happily with this version. And I run
Linux since more than 10years, so I am really fine with it, I guess :D

And thanks again for your proposal. Yes, your command worked.

I had to tell betrfs the devid!

So this did NOT work:

 btrfs fi resize  max /srv/share/

Instead the following two commands worked:

 btrfs fi resize  1:max /srv/share/
 btrfs fi resize  2:max /srv/share/

And now boths phydevices show the correct size.

This sound really strange for me that I have to tell btrfs to resize
just a single disk insteag of automatically resizing all disks...I bet
next time I have it forgotten again :-(


Greetings


Christian



