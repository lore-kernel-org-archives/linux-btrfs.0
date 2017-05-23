Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35513 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760688AbdEWRAa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 May 2017 13:00:30 -0400
Date: Tue, 23 May 2017 10:00:25 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20170523170025.sweg3oyzs5f2jxca@merlins.org>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
 <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
 <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$d0afb$8cb8ad66$8322610b$459f2144@cox.net>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 04, 2017 at 03:55:28AM +0000, Duncan wrote:
> > But that alone may not fix it, I think you need a newer kernel...
> 
> Well, while the 4.4 LTS kernel series /is/ getting a bit long in the 
> tooth by now, it's still the second newest LTS series available, 4.9 
> being the newest.
> 
> And on-list we've long recommended staying within the latest two series 
> in either the LTS or current kernel series, which means the 4.4 series 
> should still be reasonably supported.  

For what it's worth, I also had an ext4 filesystem created by some
debian testing install, tried to convert it, it worked, I rebooted, then
it worked once and got corrupted and in the end I had to destroy it and
convert by hand.

I've tried an ext4 to btrfs conversion 3 times in the last 3 years, it
never worked properly any of those times, sadly.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
