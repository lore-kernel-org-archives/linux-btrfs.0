Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:33848 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754043AbcIIK5B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 06:57:01 -0400
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
To: linux-btrfs@vger.kernel.org, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Naohiro Aota <naohiro.aota@hgst.com>
References: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
 <pan$db9b8$41125892$42517798$e874738e@applied-asynchrony.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57D29579.1080700@applied-asynchrony.com>
Date: Fri, 9 Sep 2016 12:56:57 +0200
MIME-Version: 1.0
In-Reply-To: <pan$db9b8$41125892$42517798$e874738e@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/16 12:18, Holger Hoffstätte wrote:
> On Fri, 09 Sep 2016 16:17:48 +0800, Wang Xiaoguang wrote:
> 
>> cleaner_kthread() may run at any time, in which it'll call btrfs_delete_unused_bgs()
>> to delete unused block groups. Because this work is asynchronous, it may also result
>> in false ENOSPC error. 
> <snip>
> 
> With this v3 I can now no longer balance (tested only with metadata).
> New chunks are allocated (as balance does) but nothing ever shrinks, until
> after unmount/remount, when the cleaner eventually kicks in.
> 
> This might be related to the recent patch by Naohiro Aota:
> "btrfs: let btrfs_delete_unused_bgs() to clean relocated bgs"
> 
> which by itself doesn't seem to do any harm (i.e. everything still seems
> to work as expected).

Actually even that is not true; both patches seem to be wrong in subtle
ways. Naohiro's patch seems to prevent the deletion during balance, whereas
yours prevents the cleaner from kicking in.

As a simple reproducer you can convert from -mdup to -msingle (to create
bloat) and then balance with -musage=10. Depending on which of the two
patches are applied, you end with bloat that only grows and never shrinks,
or bloat that ends up in mixed state (dup and single).

Undoing both makes both balancing and cleaning work again.

-h

