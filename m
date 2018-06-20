Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:46906 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932554AbeFTJPP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 05:15:15 -0400
Received: by mail-io0-f181.google.com with SMTP id d22-v6so2808960iof.13
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 02:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAJH6TXhoL+HLEp8ioMMt06fvykEjM3Usq7OMAk9VwpcsfTBHpA@mail.gmail.com>
 <pan$5b36b$e29a9693$2c5705da$6ebdcc0d@cox.net>
In-Reply-To: <pan$5b36b$e29a9693$2c5705da$6ebdcc0d@cox.net>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Wed, 20 Jun 2018 11:15:03 +0200
Message-ID: <CAJH6TXg4jJ0nD1dkWAm-oSLjQrvaTaWJYAbtuDTWdGnK0S_H8g@mail.gmail.com>
Subject: Re: RAID56
To: 1i5t5.duncan@cox.net
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il giorno mer 20 giu 2018 alle ore 10:34 Duncan <1i5t5.duncan@cox.net>
ha scritto:
> Parity-raid is certainly nice, but mandatory, especially when there's
> already other parity solutions (both hardware and software) available
> that btrfs can be run on top of, should a parity-raid solution be /that/
> necessary?

You can't be serious. hw raid as much more flaws than any sw raid.
Current CPUs are much more performant than any hw raid chipset and
there is no more a performance lost in using a sw raid VS hw raid.

Biggest difference is that you are not locked with a single vendor.
When you have to move disks between servers you can do safely without
having to use the same hw raid controller (with the same firmware). Almost
all raid controller only support one-way upgrades, if your raid was created
with an older model, you can upgrade to a newer one but then it's impossible
to move it back. If you have some issues with the new controller, you can't use
the previous one.
Almost all server vendor doesn't support old-gen controller on new-gen servers
(at lest DELL), so you are forced to upgrade the raid controller when
you have to upgrade
the whole server or move disks between servers. I can continue for
hours, no, you can't
compare any modern software raid to any hw raid.
