Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:44264 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755495AbdCKQLD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Mar 2017 11:11:03 -0500
Received: from tux.wizards.de (pD953E66F.dip0.t-ipconnect.de [217.83.230.111])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 47C794160D7A
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Mar 2017 17:04:53 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id D458C11C099F
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Mar 2017 17:04:52 +0100 (CET)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Question re. <linux/sizes.h> required since btrfs-progs-4.10
Message-ID: <58C42024.6000401@applied-asynchrony.com>
Date: Sat, 11 Mar 2017 17:04:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm on Gentoo and wanted to update Docker to 17.03.0, which failed when it
couldn't build the btrfs driver due to a missing <linux/sizes.h>.
This worked fine on another machine the other day, so I dug in and found that
the only difference was an intermediate update to btrfs-progs 4.10.
Sure enough: since 4.10 ctree.h includes <linux/sizes.h>, which is nowhere
to be found in my package of linux-headers-4.10 (also not in 4.9).

Simply copying sizes.h from the 4.9 kernel sources made everything work,
but I'm curious whether this is actually correct - hence my question whether
<linux/sizes.h> _should_ actually be installed? Is this a bug with
Gentoo's kernel header package or a new problem with btrfs-progs?

I don't see any good reason why sizes.h should not be installed, but wanted
to verify since there are probably users of other distributions here as
well. :)

Thanks,
Holger
