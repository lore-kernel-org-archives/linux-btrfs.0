Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.123.212]:52174 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdCHJUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:20:22 -0500
Date: Wed, 8 Mar 2017 11:00:05 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Chunk level degradable check
Message-ID: <20170308110005.106ce86a@fire>
In-Reply-To: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
References: <20170308024124.16899-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 8 Mar 2017 10:41:17 +0800
Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> This patchset will introduce a new per-chunk degradable check for
> btrfs, allow above case to succeed, and it's quite small anyway.

> v2:
>   Update after almost 2 years.
>   Add the last patch to enhance the kernel output, so user can know
>   it's missing devices prevent btrfs to mount.
> v3:
>   Remove one duplicated missing device output
>   Use the advice from Anand Jain, not to add new members in
> btrfs_device, but use a new structure extra_rw_degrade_errors, to
> record error when sending down/waiting device.

Tested raid1/raid10 cases for loosing 1 and more devices: behaviour of
the patchset in regard of allowing degraded mount is still correct.
