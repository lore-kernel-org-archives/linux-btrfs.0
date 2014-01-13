Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38911 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaAMN14 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 08:27:56 -0500
Message-ID: <52D3E9D6.2030104@oracle.com>
Date: Mon, 13 Jan 2014 21:27:50 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfstests: make btrfs/001.out in line with subvol
 delete output
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com> <5A6081D2-68E6-47BC-A534-6502B680DDDD@gmail.com>
In-Reply-To: <5A6081D2-68E6-47BC-A534-6502B680DDDD@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Wang,

 Ah yes. why did I miss that point earlier.
 Will fix it.

Thanks, Anand


On 13/01/2014 21:14, Wang Shilong wrote:
> Hello Anand,
> 
> I was noticing this problem when using the latest btrfs-progs to test ^_^
> 
> I think a better way is to filter message 'Transaction commit: none (default)'
> Rather than add it, otherwise, people will fail this test if they use previous
> btrfs-progs¡­¡­
> 
> Thanks,
> Wang
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> btrfs/001 is failing as below btrfs-progs patch changed the
>> output during subvol delete.
>> Patch :
>> btrfs-progs: add options to set commit mode after subvol delete
>>
>> so add it to the btrfs/001.out
>>
>> Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
>> ---
>> tests/btrfs/001.out | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/tests/btrfs/001.out b/tests/btrfs/001.out
>> index c782bde..a255614 100644
>> --- a/tests/btrfs/001.out
>> +++ b/tests/btrfs/001.out
>> @@ -33,6 +33,7 @@ subvol
>> Listing subvolumes
>> snap
>> subvol
>> +Transaction commit: none (default)
>> Delete subvolume 'SCRATCH_MNT/snap'
>> List root dir
>> subvol
>> -- 
>> 1.8.4.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
