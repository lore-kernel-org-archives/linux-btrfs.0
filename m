Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:17741 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbbJUXjw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 19:39:52 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id D0351AC0261
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2015 08:39:49 +0900 (JST)
Subject: Re: [PATCH] Btrfs: add a check of whether fs_info->fs_root is NULL in
 btrfs_async_reclaim_metadata_space()
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <201510210720.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
 <20151021112742.GD13624@twin.jikos.cz>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <56282237.5090408@jp.fujitsu.com>
Date: Thu, 22 Oct 2015 08:39:35 +0900
MIME-Version: 1.0
In-Reply-To: <20151021112742.GD13624@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/10/21 20:27, David Sterba wrote:
> On Wed, Oct 21, 2015 at 04:20:00PM +0900, Tsutomu Itoh wrote:
>> Kernel panic occurred due to NULL pointer reference in can_overcommit().
>> Because btrfs_async_reclaim_metadata_space() passed NULL pointer to
>> btrfs_calc_reclaim_metadata_size().
>
>> fs_info->fs_root is referred in btrfs_async_reclaim_metadata_space()
>> when mount kicked kworker(btrfs_async_reclaim_metadata_space).
>>
>> But at this time, fs_info->fs_root had not been initialized yet,
>> so NULL pointer passed to btrfs_calc_reclaim_metadata_size().
>
> I don't think it's the right fix, the initialization sequence should
> take care of such situations. The fs_tree must exist at the time we
> reach the point where it crashed, the code expects it.

OK. I will try to change initialization sequence.

Thanks,
Tsutomu


