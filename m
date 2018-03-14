Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:44674 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750902AbeCNEYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 00:24:44 -0400
Received: by mail-ot0-f170.google.com with SMTP id 79-v6so1938340oth.11
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 21:24:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180314020313.2f444787@couracado.motaleite.net>
References: <20180314020313.2f444787@couracado.motaleite.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Mar 2018 22:24:43 -0600
Message-ID: <CAJCQCtQg5_V0POgNbQs894Bq6JExpdb5b38F_T000kFanMQxag@mail.gmail.com>
Subject: Re: btrfs errors
To: higuita <higuita@gmx.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If you search the list for 'corrupt leaf bad key ordering' the top two
causes are bad RAM and flaky power supply. These can be hard to narrow
down. But yes pretty good chance it can be fixed with 'btrfs check
--repair' but two things before you do that:

a. Make sure backups are up to date. Hopefully you can mount the
volume read only, it's a more permissive mount and also it helps not
contribute more problems, and then update your backups. If you can't
mount read only, then you kinda have to weigh the risk of repair
breaking the file system versus updating backups with btrfs restore -
which is an offline scraping tool. I don't know what the risk is for
bad key ordering repairs though.

b. Make sure you're using a recent btrfs-progs - as recent as you can
get a hold of. I'd probably not use anything older than 4.14.1 but
anything since 4.4 should be capable of repairing this because it's a
pretty old feature in check and should be safe, but yeah...

c. (optional) take a btrfs image before you do the repair because if
something blows up, at least that will help a dev figure out why btrfs
check blew up your file system.

---
Chris Murphy
