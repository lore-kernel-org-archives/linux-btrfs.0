Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:37397 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdIVGFu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 02:05:50 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id C2896AC00E5
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 15:05:43 +0900 (JST)
Subject: Re: [PATCH v2 3/3] btrfs: introduce new btrfs_mount()
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <anand.jain@oracle.com>
References: <afc0d4c0-e89c-9786-8583-e4bedaf9557e@jp.fujitsu.com>
 <66665dfc-2a24-8c34-8662-6b87ba681d06@jp.fujitsu.com>
Message-ID: <270278af-da8b-f6e0-cb5d-cf58366919f9@jp.fujitsu.com>
Date: Fri, 22 Sep 2017 15:05:38 +0900
MIME-Version: 1.0
In-Reply-To: <66665dfc-2a24-8c34-8662-6b87ba681d06@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> (1) parse subvol id related options for later use in mount_subtree()
> (3) return by calling mount_subtree()

Sorry, this is not mount_subtree(), but mount_subvol().

Thanks,
Tomohiro

