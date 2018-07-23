Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41314 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388308AbeGWP1A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 11:27:00 -0400
Received: from tux.wizards.de (p3EE2F74B.dip0.t-ipconnect.de [62.226.247.75])
        by mail02.iobjects.de (Postfix) with ESMTPSA id B384641608A8
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 16:25:29 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 80125F01612
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 16:25:29 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: python-btrfs & btrfs-heatmap ebuilds now available for Gentoo
Message-ID: <2356e8d0-3dcd-34c5-bfc7-b01340fc9cef@applied-asynchrony.com>
Date: Mon, 23 Jul 2018 16:25:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I wanted to migrate my collection of questionable shell scripts for btrfs
maintenance/inspection to a more stable foundation and therefore created
Gentoo ebuilds for Hans van Kranenburg's excellent python-btrfs [1] and
btrfs-heatmap [2] packages.

They can be found in my overlay at:

https://github.com/hhoffstaette/portage/tree/master/sys-fs/python-btrfs
https://github.com/hhoffstaette/portage/tree/master/sys-fs/btrfs-heatmap

Both are curently only available for python-3.6 since a change in 3.7
broke the existing python API [3]. As soon as that is fixed I'll add 3.7
to the PYTHON_COMPAT entries.

btrfs-heatmap properly uses the python-exec wrapper and therefore works
regardless of currently selected default python version.  :)

I hope this is useful to someone.

cheers,
Holger

[1] https://github.com/knorrie/python-btrfs
[2] https://github.com/knorrie/btrfs-heatmap
[3] https://github.com/knorrie/python-btrfs/issues/13
