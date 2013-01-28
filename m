Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:41676 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3A1Mu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 07:50:59 -0500
Message-ID: <51067430.1070009@jan-o-sch.net>
Date: Mon, 28 Jan 2013 13:50:56 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org, jmwdev38@gmail.com,
        jbacik@fusionio.com, sensille@gmx.net
Subject: Re: [PATCH] Btrfs: fix ENOSPC in qgroups (metadata)
References: <1359374626-14109-1-git-send-email-list.btrfs@jan-o-sch.net> <510672B2.7000601@cn.fujitsu.com>
In-Reply-To: <510672B2.7000601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Miao,

On 28.01.2013 13:44, Miao Xie wrote:
> On mon, 28 Jan 2013 13:03:46 +0100, Jan Schmidt wrote:
>> When start_transaction() returns ENOSPC after btrfs_qgroup_reserve(), we
>> must call btrfs_qgroup_free() to avoid the qgroup counters increasing when
>> there's actually no data being written.
>>
>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>> ---
>> Josef: It looks like these places (except the first) are candidates for
>> btrfs_block_rsv_release, please check.
> 
> I didn't note that you have made a patch for the qgroup reservation problem, so I sent
> my fix patch.
> 
> But start_transaction() has reservation problems not only for qgroup, but also for
> the free space, your patch didn't fix the free space reservation problem.

I see, we better take your patch then. Although my commit message was
way more descriptive ;-)

Josef: You've been saved.

Thanks,
-Jan
