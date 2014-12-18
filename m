Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34621 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaLRHQV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 02:16:21 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E5B5F3EE0BD
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:16:19 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id DC92CAC06EE
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:16:18 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3F1D31DB804B
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:16:18 +0900 (JST)
Message-ID: <54927F36.6010701@jp.fujitsu.com>
Date: Thu, 18 Dec 2014 16:16:06 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        naota <naota@elisp.net>
Subject: Re: [PATCH 1/2] Fix wrong memory free on check_is_root
References: <54926FB4.6050604@jp.fujitsu.com> <1418886214.5832.6.camel@localhost.localdomain>
In-Reply-To: <1418886214.5832.6.camel@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 16:03, Gui Hecheng wrote:
> On Thu, 2014-12-18 at 15:09 +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> Date: Thu, 18 Dec 2014 14:35:22 +0900
>>
>> @tmp is freed even if its allocation fails.
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> ---
>>   cmds-property.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/cmds-property.c b/cmds-property.c
>> index a764293..a4bc127 100644
>> --- a/cmds-property.c
>> +++ b/cmds-property.c
>> @@ -140,31 +140,32 @@ static int check_is_root(const char *object)
>
> Hi Satoru,
> 	" tmp = malloc()
> 	  if (!tmp) {
> 		...
> 		goto out;
> 	  }
> 	"
> Actually, if the malloc() fails, it returns a NULL, and the free()
> handles the NULL internally.
> I think there is no special need to deal with this case by the prog
> itself.

Oh, sorry... my brain would be broken today.

Thanks,
Satoru

>
> Thanks,
> Gui
>
>>   	if (ret < 0) {
>>   		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", object,
>>   				strerror(-ret));
>> -		goto out;
>> +		goto free_tmp_out;
>>   	}
>>
>>   	ret = get_fsid(tmp, fsid2, 1);
>>   	if (ret == -ENOTTY) {
>>   		ret = 0;
>> -		goto out;
>> +		goto free_tmp_out;
>>   	} else if (ret == -ENOTDIR) {
>>   		ret = 1;
>> -		goto out;
>> +		goto free_tmp_out;
>>   	} else if (ret < 0) {
>>   		fprintf(stderr, "ERROR: get_fsid for %s failed. %s\n", tmp,
>>   			strerror(-ret));
>> -		goto out;
>> +		goto free_tmp_out;
>>   	}
>>
>>   	if (memcmp(fsid, fsid2, BTRFS_FSID_SIZE)) {
>>   		ret = 0;
>> -		goto out;
>> +		goto free_tmp_out;
>>   	}
>>
>>   	ret = 1;
>>
>> -out:
>> +free_tmp_out:
>>   	free(tmp);
>> +out:
>>   	return ret;
>>   }
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

