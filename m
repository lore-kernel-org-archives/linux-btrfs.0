Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24728 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S939252AbdDTG2p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 02:28:45 -0400
Subject: Re: [PATCH 1/2] btrfs-progs: dump-super: check array_size in
 print_sys_chunk_array
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170405085915.21791-1-lufq.fnst@cn.fujitsu.com>
 <20170419154124.GC22319@twin.jikos.cz>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <a2461f6a-9957-10af-9a15-ec700b3a41e8@cn.fujitsu.com>
Date: Thu, 20 Apr 2017 14:28:39 +0800
MIME-Version: 1.0
In-Reply-To: <20170419154124.GC22319@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017年04月19日 23:41, David Sterba wrote:
>>   
>> -	buf = malloc(sizeof(*buf) + sizeof(*sb));
>> +	buf = malloc(sizeof(*buf) + BTRFS_SUPER_INFO_SIZE);
> This seems to be unnecessary, the super block structure should contain
> entier sys_array.
> 
Alright, I will remove it.

-- 
Thanks,
Lu


