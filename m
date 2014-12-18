Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaLRHTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 02:19:33 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id AF1893EE1D7
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:19:31 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id ACB04AC0856
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:19:30 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 4462B1DB803C
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:19:30 +0900 (JST)
Message-ID: <54927FF8.1020803@jp.fujitsu.com>
Date: Thu, 18 Dec 2014 16:19:20 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        naota <naota@elisp.net>
Subject: Re: [PATCH 2/2] btrfs-progs: fix the file system root is regarded
 as non-root
References: <54926FB4.6050604@jp.fujitsu.com>	 <54927765.6060207@jp.fujitsu.com> <1418886575.5832.9.camel@localhost.localdomain>
In-Reply-To: <1418886575.5832.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/12/18 16:09, Gui Hecheng wrote:
> On Thu, 2014-12-18 at 15:42 +0900, Satoru Takeuchi wrote:
>> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>>
>> When "/" is Btrfs, "btrfs property <subcommand> /" regards it
>> as non-root by mistake.
>>
>> check_is_root() regards @object as a file system root if
>> the following two conditions are satisfied.
>>
>>   a) Both @object and its parent directory are Btrfs object
>>      (file system root, subvolume, inode, and device
>>      used for Btrfs).
>>   b) fsid of the above mentioned two objects are different.
>>
>> It doesn't work if @object is "/" because, in this case,
>> fsid of "/" and its parent (it's also "/"), are the same.
>>
>> * Test environment
>>
>> Two Btrfs file system (not subvolume) "/" and "/home/sat/mnt".
>>
>> * How to reproduce
>>
>> Submit "btrfs prop get" against the above mentioned file systems.
>>
>> * Test Result
>>
>> ** Actual result (without my patch)
>>
>> ==========================
>> # btrfs prop get /home/sat/mnt/
>> ro=false
>> label=                 # label is displayed because it's a file system root
>> # btrfs prop get /
>> ro=false               # label is not displayed even if it's a file system root
>> ==========================
>> ** Expected result (with my patch)
>>
>> ==========================
>> # ./btrfs-new prop get btrfs-auto-test/
>> # ./btrfs-new prop get /home/sat/mnt/
>> ro=false
>> label=
>> # ./btrfs-new prop get /
>> ro=false
>> label=foo            # label is displayed
>> ===========================
>>
>> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
>> Reported-by: Naohiro Aota <naota@elisp.net>
>>
>> ---
>>   cmds-property.c | 15 ++++++++++++++-
>>   1 file changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/cmds-property.c b/cmds-property.c
>> index a4bc127..640af99 100644
>> --- a/cmds-property.c
>> +++ b/cmds-property.c
>> @@ -125,11 +125,22 @@ static int check_is_root(const char *object)
>>   	u8 fsid[BTRFS_FSID_SIZE];
>>   	u8 fsid2[BTRFS_FSID_SIZE];
>>   	char *tmp;
>> +	char *rp;
>> +
>> +	rp = realpath(object, NULL);
>> +	if (!rp) {
>> +		ret = -ENOMEM;
> Hi Satoru，
>
> IMO, ret = -errno may be better, because there are many possible return
> values of realpath().

Thank you for point my mistake out.

I'll dispose 1/2 and submit 2/2 vs later.

Thanks,
Satoru

>
> Thanks,
> Gui
>
>> +		goto out;
>> +	}
>> +	if (!strcmp(rp, "/")) {
>> +		ret = 0;
>> +		goto free_rp_out;
>> +	}
>>
>>   	tmp = malloc(strlen(object) + 5);
>>   	if (!tmp) {
>>   		ret = -ENOMEM;
>> -		goto out;
>> +		goto free_rp_out;
>>   	}
>>   	strcpy(tmp, object);
>>   	if (tmp[strlen(tmp) - 1] != '/')
>> @@ -165,6 +176,8 @@ static int check_is_root(const char *object)
>>
>>   free_tmp_out:
>>   	free(tmp);
>> +free_rp_out:
>> +	free(rp);
>>   out:
>>   	return ret;
>>   }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

