Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:23316 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725743AbeIGHkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 03:40:11 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id BAC8FAC0171
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 12:01:27 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] btrfs: extent-tree.c: Remove redundant variable from
 btrfs_cross_ref_exist()
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1535593351.git.misono.tomohiro@jp.fujitsu.com>
 <90c3c33c-0f7d-7121-feb8-4a74e5e78b93@jp.fujitsu.com>
 <20180906155757.GC24025@twin.jikos.cz>
Message-ID: <ed103469-264b-f556-c34b-81ab8e64e509@jp.fujitsu.com>
Date: Fri, 7 Sep 2018 12:01:21 +0900
MIME-Version: 1.0
In-Reply-To: <20180906155757.GC24025@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/09/07 0:57, David Sterba wrote:
> On Thu, Aug 30, 2018 at 10:59:16AM +0900, Misono Tomohiro wrote:
>> Since commit d7df2c796d7e ("Btrfs attach delayed ref updates to
>> delayed ref heads"), check_delaed_ref() won't return -ENOENT.
>>
>> In btrfs_cross_ref_exist(), two variable 'ret' and 'ret2' is
>> originally used to handle -ENOENT error case.
>>
>> Since the code is not needed anymore, let's just remove 'ret2'.
> 
> Good cleanup and the patch would be ok as-is. I've noticed that
> check_delayed_ref now returns only two values so it might make sense to
> turn it to bool and update the name of check_delayed_ref to make it
> clear what the return value means in the loop.

check_delaed_ref()'s return value is:
 0       ... no cross ref found in delayed ref
 1       ... cross ref found in delayed ref
 -EAGAIN ... cannot acquire lock and try again later

so I don't think we can convert it to bool directly or
do you mean we should handle -EAGAIN in check_delayed_ref()?

> The concern here is that adding another error code in check_delayed_ref
> in the future will not be caught in btrfs_cross_ref_exist. Adding an
> assert filtering only EAGAIN would be sufficient as this might miss the
> extra value in case it'd be an uncommon case.
