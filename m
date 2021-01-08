Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C1CC433DB
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 08:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 964792343F
	for <linux-btrfs@archiver.kernel.org>; Fri,  8 Jan 2021 08:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbhAHIgz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Jan 2021 03:36:55 -0500
Received: from mail.eclipso.de ([217.69.254.104]:50642 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbhAHIgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jan 2021 03:36:55 -0500
Received: from mail.eclipso.de (www1.eclipso.de [217.69.254.102])
        by mail.eclipso.de with ESMTP id 5E3DA845
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jan 2021 09:36:13 +0100 (CET)
Date:   Fri, 08 Jan 2021 09:36:13 +0100
MIME-Version: 1.0
Message-ID: <eb0f5e05a563009af95439f446659cf3@mail.eclipso.de>
X-Mailer: eclipso / 7.4.0
From:   " " <Cedric.dewijs@eclipso.eu>
Subject: Re: Re: Raid1 of a slow hdd and a fast(er) SSD, howto to prioritize the
        SSD?
Reply-To: " " <Cedric.dewijs@eclipso.eu>
To:     "Andrea Gelmini" <andrea.gelmini@gmail.com>
Cc:     <linux-btrfs@vger.kernel.org>
In-Reply-To: <CAK-xaQZS+ANoD+QbPTHwL-ErapA-7PDZe_z=OOWq_axAyR1KfA@mail.gmail.com>
References: <28232f6c03d8ae635d2ddffe29c82fac@mail.eclipso.de>
        <CAK-xaQZS+ANoD+QbPTHwL-ErapA-7PDZe_z=OOWq_axAyR1KfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--- Ursprüngliche Nachricht ---
Von: Andrea Gelmini <andrea.gelmini@gmail.com>
Datum: 08.01.2021 09:16:26
An: Cedric.dewijs@eclipso.eu
Betreff: Re: Raid1 of a slow hdd and a fast(er) SSD, howto to prioritize the SSD?

Il giorno mar 5 gen 2021 alle ore 07:44 <Cedric.dewijs@eclipso.eu>
ha scritto:
>
> Is there a way to tell btrfs to leave the slow hdd alone, and to prioritize
the SSD?

You can use mdadm to do this (I'm using this feature since years in
setup where I have to fallback on USB disks for any reason).

From manpage:

       -W, --write-mostly
              subsequent  devices  listed in a --build, --create, or
--add command will be flagged as 'write-mostly'.  This is valid for
              RAID1 only and means that the 'md' driver will avoid
reading from these devices if at all possible.  This can be useful if
              mirroring over a slow link.

       --write-behind=
              Specify  that  write-behind  mode  should be enabled
(valid for RAID1 only).  If an argument is specified, it will set the
              maximum number of outstanding writes allowed.  The
default value is 256.  A write-intent bitmap is required  in  order
to
              use write-behind mode, and write-behind is only
attempted on drives marked as write-mostly.

So you can do this:
(be carefull, this wipe your data)

mdadm --create --verbose --assume-clean /dev/md0 --level=1
--raid-devices=2 /dev/sda1 --write-mostly /dev/sdb1

Then you use BTRFS on top of /dev/md0, after mkfs.btrfs, of course.

Ciao,
Gelma

Thanks Gelma.

What happens when I poison one of the drives in the mdadm array using this command? Will all data come out OK?
dd if=/dev/urandom of=/dev/dev/sdb1 bs=1M count = 100?

When I do this test on a plain btrfs raid 1 with 2 drives, all the data comes out OK (while generating a lot of messages about correcting data in dmesg -w)

Cheers,
Cedric

---

Take your mailboxes with you. Free, fast and secure Mail &amp; Cloud: https://www.eclipso.eu - Time to change!


