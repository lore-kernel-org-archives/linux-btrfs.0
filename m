Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48640 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbbHXCd3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Aug 2015 22:33:29 -0400
Message-ID: <55DA81B8.1030301@oracle.com>
Date: Mon, 24 Aug 2015 10:30:16 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Fujitsu pull part1: cleanup
References: <55D68A6C.3010107@cn.fujitsu.com> <55D775A0.8030207@giantdisaster.de>
In-Reply-To: <55D775A0.8030207@giantdisaster.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Stefan,

> Please send your patches to the mailing list for reviews by everybody.

   Do you see any patch below which wasn't posted to the mailing list. ?

Thanks, Anand


>> Qu Wenruo (1):
>>    btrfs: async_thread: Fix workqueue 'max_active' value when
>>      initializing
>>
>> Tsutomu Itoh (1):
>>    Btrfs: cleanup: remove unnecessary check before btrfs_free_path is
>>      called
>>
>> Zhao Lei (6):
>>    btrfs: Update out-of-date "skip parity stripe" comment
>>    btrfs: Remove noused chunk_tree and chunk_objectid from
>>      scrub_enumerate_chunks and scrub_chunk
>>    btrfs: Cleanup for btrfs_calc_num_tolerated_disk_barrier_failures
>>    btrfs: Add raid56 support for updating
>>      num_tolerated_disk_barrier_failures in btrfs_balance
>>    btrfs: Remove useless condition in start_log_trans
>>    btrfs: Remove unused arguments in tree-log.c



