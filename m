Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44222 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaG3Ggz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 02:36:55 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id A17143EE0B6
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:36:53 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id A4F3AAC0703
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:36:52 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 1BF831DB8049
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:36:52 +0900 (JST)
Received: from G01JPEXCHKW17.g01.fujitsu.local (G01JPEXCHKW17.g01.fujitsu.local [10.0.194.56])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id DB97C692598
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jul 2014 15:36:50 +0900 (JST)
Message-ID: <53D8927C.6000006@jp.fujitsu.com>
Date: Wed, 30 Jul 2014 15:36:44 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs-progs: adjust the return values for scrub
References: <1405564839-28702-1-git-send-email-guihc.fnst@cn.fujitsu.com> <53D88AA2.90804@jp.fujitsu.com>
In-Reply-To: <53D88AA2.90804@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Gui,

(2014/07/30 15:03), Satoru Takeuchi wrote:
> Hi Gui,
> 
> (2014/07/17 11:40), Gui Hecheng wrote:
>> o Return 0 to indicate success,
>>     when detected errors were corrected during scrubbing.
>>     P.s. This is also to facilitate scripting when return value
>>          is to be checked.
>> o Warn the users if there are uncorrectable errors detected.
>>
>> Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> ---
>>    cmds-scrub.c | 13 ++++++++-----
>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/cmds-scrub.c b/cmds-scrub.c
>> index 5265a2b..f9e2b40 100644
>> --- a/cmds-scrub.c
>> +++ b/cmds-scrub.c
>> @@ -1514,14 +1514,17 @@ out:
>>    	}
>>    	close_file_or_dir(fdmnt, dirstream);
>>    
>> -	if (nothing_to_resume)
>> -		return 2;
>>    	if (err)
>>    		return 1;
>> -	if (e_correctable)
>> +	if (nothing_to_resume)
>> +		return 2;
>> +	if (e_uncorrectable) {
>> +		ERR(!do_quiet, "ERROR: There are uncorrectable errors.\n");
>>    		return 3;
>> -	if (e_uncorrectable)
>> -		return 4;
>> +	}
>> +	if (e_correctable)
>> +		ERR(!do_quiet, "WARNING: errors detected during scrubbing, corrected.\n");
>> +
> 
> 1. ERR() messages are not necessary since start command
>     reports its status in the middle of scrub_start().
>     It includes both the number of correctable/uncorrectable errors.
> 
> 2. It prints messages even if this program runs as foreground mode.
>     Checking do_print is necessary.
> 
> 3. Whether correctable/uncorrectable error exists in a file system
>     is not related to the exist status of scrub. The role of this
>     program is
> 
>      a) reading all data from all devices and verify checksums, and
>      b) correct checksum errors "if possible".
> 
>     So, I consider scrub only returns error if this program itself
>     failed to finish.

Sorry, I understood what you said. It's no problem to exit with
error codes to detect whether correctable/uncorrectable errors happen
or not. Sorry for noise.

Thanks,
Satoru

> 
> Thanks,
> Satoru
> 
>>    	return 0;
>>    }
>>    
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

