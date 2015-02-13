Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:62011 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbBMNId (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 08:08:33 -0500
Received: by mail-yk0-f177.google.com with SMTP id 20so7550726yks.8
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 05:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54DC9AB9.7030505@gmail.com>
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
	<pan$321bc$90037b7$6ca4e371$e54e1a3b@cox.net>
	<CABdHLQ6La7BO-TJ3cYEx_NnOUhAYJ69uv3tGnVRYsWkiUrqCsQ@mail.gmail.com>
	<pan$9532$65b1220e$320184ed$94bcf659@cox.net>
	<62ntqb-o2r.ln1@hurikhan77.spdns.de>
	<54DC9AB9.7030505@gmail.com>
Date: Fri, 13 Feb 2015 14:08:33 +0100
Message-ID: <CABdHLQ6v-VASSk=7FuoB6rVbw7mg6E1F5Tkjp8bJ+mhphHZr0g@mail.gmail.com>
Subject: Re: btrfs performance, sudden drop to 0 IOPs
From: "P. Remek" <p.remek1@googlemail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'd definitely suggest using NOCOW for any file you are doing O_DIRECT with,
> as you should see _much_ better performance that way, and also don't run the
> (theoretical) risk of some of the same types of corruption that swapfiles on
> BTRFS can cause.

I mounted the filesystem with nodatacow as follows and it didn't help
- it still drops to 0 IOPs every couple of seconds.

/dev/sdi on /mnt/btrfs type btrfs (rw,nodatacow)
