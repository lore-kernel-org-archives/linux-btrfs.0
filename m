Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50817 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751317AbaLSGXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 01:23:14 -0500
Message-ID: <5493C450.8060204@cn.fujitsu.com>
Date: Fri, 19 Dec 2014 14:23:12 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: WorMzy Tykashi <wormzy.tykashi@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-progs: integration-20141218 possible corruption test regression
References: <4A7D957D-FE36-452D-B6DB-12117FF75AB9@gmail.com> <719D86DC-BC2F-4A9C-9D17-F90AFFF3FFC2@gmail.com>
In-Reply-To: <719D86DC-BC2F-4A9C-9D17-F90AFFF3FFC2@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: btrfs-progs: integration-20141218 possible corruption test 
regression
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月19日 02:39
> On 18 December 2014 18:35:16 GMT+00:00, WorMzy Tykashi <wormzy.tykashi@gmail.com> wrote:
>> Hi guys,
>>
>> The latest integration fails 'make test' with the following output:
>>
>>      [TEST]    013-leaf-corruption-no-extent-data.tar.xz
>> btrfs check should have detected corruption
>> Makefile:144: recipe for target 'test' failed
>> make: *** [test] Error 1
>> rm btrfs-corrupt-block.o
>>
>>
>> I've only built the progs on a single machine so far, but it
>> consistently fails at this test.
>>
>> Cheers,
>>
>>
>> WorMzy
> Regression is present in the 3.18.x branch too.
>
> Cheers,
>
>
> WorMzy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
In fact, it's not a regression.

The 013 testcase is a special case that uses a script to corrupt the 
image and then do the btrfsck test.

There is a patch before the commit, to allow btrfs-progs test script 
call corruption script.
But since there is still some discussion about the corruption script and 
maybe later verify script,
the previous patch is not picked.

So btrfsck is ran on the *FINE* image without corrupting it, so you 
failed the test.

This testcase seems not to be included into 3.18.x soon, so it's not a 
problem.

If you still want to test it, please add the following patch as a 
temporary fix:
https://patchwork.kernel.org/patch/5490241/

Thanks,
Qu
