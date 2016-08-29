Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34457 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756125AbcH2LSl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 07:18:41 -0400
Received: by mail-lf0-f45.google.com with SMTP id l89so98339971lfi.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 04:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com> <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 29 Aug 2016 14:18:39 +0300
Message-ID: <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com>
Subject: Re: btrfs and systemd
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> I can't find any fstab setting for systemd to higher this timeout.
>>> There's just  the x-systemd.device-timeout but this controls how long to
>>> wait for the device and not for the mount command.
>>> Is there any solution for big btrfs volumes and systemd?
>>> Stefan

Switch to Runit.

First time I seriously consider another init on my
notebook is when I have a problem like yours.

Even when / (root) is mounted just fine, if there is
any problem with any other fstab entry, you'll
get into such a situation on systemd.

Give it a try, appending "init=/usr/bin/runit-init"
to your kernel command line on your bootloader.
You dont need to uninstall any package until
getting Runit behave "exactly" as you like.
