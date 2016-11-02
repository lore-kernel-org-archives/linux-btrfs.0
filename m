Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:35148 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbcKBLkj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 07:40:39 -0400
Received: by mail-it0-f50.google.com with SMTP id e187so77422720itc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 04:40:39 -0700 (PDT)
Subject: Re: Resizing BTRFS - raw partition
To: =?UTF-8?Q?Christian_V=c3=b6lker?= <cvoelker@knebb.de>,
        Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <92e3c63e-0301-7a25-7c56-56447a1948cc@knebb.de>
 <20161102091249.GL16645@carfax.org.uk>
 <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4748119f-099c-9403-511a-4888cf1f5c3e@gmail.com>
Date: Wed, 2 Nov 2016 07:40:31 -0400
MIME-Version: 1.0
In-Reply-To: <6050c1f3-ff13-204c-ec32-3bcb62db7c5a@knebb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-02 05:18, Christian Völker wrote:
> Hi Hugo,
>
> thanks for the quick reply. Regarding version- I prefer to use stable
> Linux versions....and I am not going to upgrade just btrfs outside of
> the verndors builds. So I am stuck happily with this version. And I run
> Linux since more than 10years, so I am really fine with it, I guess :D
>
> And thanks again for your proposal. Yes, your command worked.
>
> I had to tell betrfs the devid!
>
> So this did NOT work:
>
>  btrfs fi resize  max /srv/share/
>
> Instead the following two commands worked:
>
>  btrfs fi resize  1:max /srv/share/
>  btrfs fi resize  2:max /srv/share/
>
> And now boths phydevices show the correct size.
>
> This sound really strange for me that I have to tell btrfs to resize
> just a single disk insteag of automatically resizing all disks...I bet
> next time I have it forgotten again :-(
Responding just to this in particular.

The reasoning behind this is that by requiring the device ID to be 
specified, it reduces the amount of parsing required, which in turn 
makes the command more robust.  There are also plenty of practical 
reasons to resize just one device in a multi-device filesystem (for 
example, if you're replacing one disk at a time, or just need to free up 
some space on a single disk, etc), so we need to have support for that, 
and in turn it's easier from a software maintenance perspective to just 
require it to be that way.

That said, I would love to have 'btrfs fi resize max' special cased to 
just resize every device in the FS to max size, since increasing the 
size of a device is much more common than reducing it, and it's a lot 
more convenient than having to look up device ID's (because those can 
change as devices are added to and removed from the FS).

