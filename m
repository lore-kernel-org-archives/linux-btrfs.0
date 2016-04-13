Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:32931 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031049AbcDMMDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 08:03:00 -0400
Received: by mail-lf0-f51.google.com with SMTP id e190so66409648lfe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2016 05:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570D19D9.8030702@googlemail.com>
References: <570CCCFB.5000104@googlemail.com>
	<570D19D9.8030702@googlemail.com>
Date: Wed, 13 Apr 2016 13:56:16 +0200
Message-ID: <CAPmG0jae+4LML6oVWnrFnosyamXtBkSHiO12_s==ZecMAULv5g@mail.gmail.com>
Subject: Re: enospace regression in 4.4
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2016 at 5:52 PM, Julian Taylor
<jtaylor.debian@googlemail.com> wrote:
> smaller testcase that shows the immediate enospc after fallocate -> rm,
> though I don't know if it is really related to the full filesystem
> bugging out as the balance does work if you wait a few seconds after the
> balance.
> But this sequence of commands did work in 4.2.
>
>  $ sudo btrfs fi show /dev/mapper/lvm-testing
> Label: none  uuid: 25889ba9-a957-415a-83b0-e34a62cb3212
>         Total devices 1 FS bytes used 225.18MiB
>         devid    1 size 5.00GiB used 788.00MiB path /dev/mapper/lvm-testing
>
>  $ fallocate -l 4.4G test.dat
>  $ rm -f test.dat
>  $ sudo btrfs fi balance start -dusage=0 .
> ERROR: error during balancing '.': No space left on device
> There may be more info in syslog - try dmesg | tail

The effect is the same with kernel / progs  v4.6.0-rc3 / v4.5.1
It also doesn't matter if   fallocate -l 4400M test.dat   or   dd
if=/dev/zero of=test.dat bs=1M count=4400   is used to create test.dat
(I was looking at --dig-holes and --punch-hole options earlier and was
wondering if the use of fallocate would make a difference).
