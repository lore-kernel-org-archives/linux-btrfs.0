Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38428 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbcF3N6q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 09:58:46 -0400
Received: by mail-wm0-f52.google.com with SMTP id r201so120116240wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 06:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1fb4624c-4a2f-6076-0883-4a7bff395821@oracle.com>
References: <CAGqmi75KFyiCzF2J5Xa_a8S27iR6Kp1jxH4JcwHBe1pD8m1egg@mail.gmail.com>
 <1fb4624c-4a2f-6076-0883-4a7bff395821@oracle.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 30 Jun 2016 16:58:04 +0300
Message-ID: <CAGqmi75LfZRvcYfYSnsXXZgJtCHce=V38Shozkb0bQ2n42LsxA@mail.gmail.com>
Subject: Re: RAID1: if one disk failed, what errors are expected?
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-06-30 14:57 GMT+03:00 Anand Jain <anand.jain@oracle.com>:
>
>
> Thanks for reporting.
>
> Right. Application shouldn't notice the EIO. First of all,
> we are not stopping IO to the disk which is pulled out. The
> below patches 11/13 and 12/13 fixes it.
>
>  [PATCH 11/13] btrfs: introduce device dynamic state transition to offline
> or failed
>  [PATCH 12/13] btrfs: check device for critical errors and mark failed
>
>
> Next, if degraded mount fails, you will also need below patches.
> However there are two choices..
>
> Patch 1..5/13 are workaround fixes..
>  [PATCH 01/13] btrfs: Introduce a new function to check if all chunks a OK
> for degraded mount
>  [PATCH 02/13] btrfs: Do per-chunk check for mount time check
>  [PATCH 03/13] btrfs: Do per-chunk degraded check for remount
>  [PATCH 04/13] btrfs: Allow barrier_all_devices to do per-chunk device check
>  [PATCH 05/13] btrfs: Cleanup num_tolerated_disk_barrier_failures
>
> OR
>
> Below RFC patch which has the actual fix (lightly tested),
>  PATCH 0/2] [RFC] btrfs: create degraded-RAID1 chunks
>
> Could you please give it a try ?
>
> Thanks, Anand
>

Yes, i will, thanks.

-- 
Have a nice day,
Timofey.
