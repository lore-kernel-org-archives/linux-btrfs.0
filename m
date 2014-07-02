Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21685 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbaGBC0L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 22:26:11 -0400
Message-ID: <53B36CBF.6020608@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 10:21:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: clear compress-force when remounting with compress
 option
References: <1404096685-10591-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140701160457.GM1553@twin.jikos.cz> <53B36756.5030601@jp.fujitsu.com>
In-Reply-To: <53B36756.5030601@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2014 09:58 AM, Satoru Takeuchi wrote:
> (2014/07/02 1:04), David Sterba wrote:
>> On Mon, Jun 30, 2014 at 10:51:25AM +0800, Wang Shilong wrote:
>>> Steps to reproduce:
>>>   # mkfs.btrfs -f /dev/sdb
>>>   # mount /dev/sdb /mnt -o compress-force=lzo
>>>   # mount /dev/sdb /mnt -o remount,compress=zlib
>>>   # cat /proc/mounts
>>>
>>> Remounting from compress-force to compress could not clear 
>>> compress-force
>>> option. The problem is there is no way for users to clear 
>>> compress-force
>>> option separately.
>>>
>>> Fix this problem by clearing @FORCE_COMPRESS flag when remounting to
>>> compress=xxx.
>>>
>>> Suggested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> I'm sorry for lack of answer in the V1 thread, V2 is the minimal bugfix
>> and I'm fine with it right away.
>>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
>
> Test result (I used your reproducer):
>   3.16-rc3:               FAIL
>   3.16-rc3 w/ your patch: PASS
>
> Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> Tested-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Satoru, Thanks for doing this. ^_^

Regards,
Wang
>
> Thanks,
> Satoru
>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>
> .
>

