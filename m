Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8F6C43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 13:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93D5821580
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 13:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2cz+gcwa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93D5821580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbeI1TsV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 15:48:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeI1TsV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 15:48:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8SDNi03077404;
        Fri, 28 Sep 2018 13:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Gpa659Cqrf0O+ibvAT+ocwN23zWmQop5+RTxhzzcH6A=;
 b=2cz+gcwa7AIMrAxjjkkO3VjJeEfbvNfBuzqs3/cdJeNvwX8o4DGdWRoPfK0DemnoQLRI
 z6J1Cu1PaHgEwddhiwoq2J2AnDSZW1RYIVI8g2r09mqOVgJPIPI3oVdeRpKIgU4R3fBr
 v6Rnem0HjzGlgxLHUWYErcnpHTfridX72bKXaLNOFYWG/XWCpcKm99ronBRqn85LTacf
 NTCGt/tAf/SBjHyjxz84yH7y4WOkCg+UVwreC2FupHjnfxDHedJuLbDcCWs300ugZcsd
 MXDt7vbWUNh8ZANDhd099VOz5ywvlFnq7Z2B7TSQlU3b3IS691dFuJExFNh3jbGIsLpP Lg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2mnvtv6xrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 13:24:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8SDOTe0006013
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Sep 2018 13:24:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8SDOSbg013518;
        Fri, 28 Sep 2018 13:24:29 GMT
Received: from [192.168.0.182] (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Sep 2018 06:24:26 -0700
Subject: Re: [PATCH v2 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
To:     Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-2-git-send-email-anand.jain@oracle.com>
 <b054a402-0507-4990-6752-8d75b02a97ed@suse.com>
 <68c6443f-6d2b-ba3a-40e1-994fa5ee32e3@oracle.com>
 <b6a81bfa-66f6-89e3-3c1e-2d5396f8bbf4@suse.com>
 <20180927200755.GC29754@vader>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <24327738-3749-e838-5b38-5e8b64f2bd3b@oracle.com>
Date:   Fri, 28 Sep 2018 21:23:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180927200755.GC29754@vader>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9029 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1809280136
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/28/2018 04:07 AM, Omar Sandoval wrote:
> On Wed, Sep 26, 2018 at 09:34:27AM +0300, Nikolay Borisov wrote:
>>
>>
>> On 26.09.2018 07:07, Anand Jain wrote:
>>>
>>>
>>> On 09/25/2018 06:51 PM, Nikolay Borisov wrote:
>>>>
>>>>
>>>> On 25.09.2018 07:24, Anand Jain wrote:
>>>>> As of now _scratch_mkfs_sized() checks if the requested size is below 1G
>>>>> and forces the --mixed option for the mkfs.btrfs. Well the correct size
>>>>> considering all possible group profiles at which we need to force the
>>>>> mixed option is roughly 256Mbytes. So fix that.
>>>>>
>>>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>>>
>>>> Have you considered the implications of this w.r.t commit
>>>> d4da414a9a9d ("common/rc: raise btrfs mixed mode threshold to 1GB")
>>>>
>>>> Initially this threshold was 100mb then Omar changed it to 1g. Does this
>>>> change affect generic/427?
>>>
>>> d4da414a9a9d does not explain what was the problem that Omar wanted to
>>> address, mainly what was the failure about.
>>
>> I just retested on upstream 4.19.0-rc3 with Omar's patch reverted (so
>> anything above 100m for fs size is created with non-mixed block groups)
>> and the test succeeded. So indeed your change seems to not make a
>> difference for this test.
>>
>>>
>>> And no it does not affect. I have verified generic/427 with kernel 4.1
>>> and 4.19-rc5 with  btrfs-progs 4.1, 4.9 and latest from kdave they all
>>> run fine. Good to integrate.
> 
> I had to double check, but it only happens with -m dup. If I apply the
> following patch:
> 
> diff --git a/common/rc b/common/rc
> index d5bb1fe..989b846 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -969,7 +969,7 @@ _scratch_mkfs_sized()
>   	;;
>       btrfs)
>   	local mixed_opt=
> -	(( fssize <= 1024 * 1024 * 1024 )) && mixed_opt='--mixed'
> +	(( fssize <= 100 * 1024 * 1024 )) && mixed_opt='--mixed'
>   	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
>   	;;
>       jfs)
> diff --git a/tests/generic/427 b/tests/generic/427
> index e8ebffe..206cf08 100755
> --- a/tests/generic/427
> +++ b/tests/generic/427
> @@ -65,6 +65,7 @@ fi
>   # start a background aio writer, which does several extending loops
>   # internally and check data integrality
>   $AIO_TEST -s $fsize -b 65536 $SCRATCH_MNT/tst-aio-dio-eof-race.$seq
> +btrfs fi usage $SCRATCH_MNT
>   status=$?
>   
>   kill $open_close_pid
> 
> And run with MKFS_OPTIONS="-m dup", then we don't have enough data space
> for the test:
> 
> --- /root/linux/xfstests/tests/generic/427.out	2017-11-28 16:05:46.811435644 -0800
> +++ /root/linux/xfstests/results/generic/427.out.bad	2018-09-27 13:01:00.540510385 -0700
> @@ -1,2 +1,24 @@
>   QA output created by 427
> -Success, all done.
> +pwrite: No space left on device

Thanks Omar. Unfortunately I can't reproduce with the diff as above + 
MKFS_OPTIONS="-m dup".

In any case the objective of this patch is to ensure 
_scratch_mkfs_sized() provides default group profile with the minimum 
disk size that's actually be required. And related to that there isn't 
any issue in this patch.

Thanks, Anand

> +Overall:
> +    Device size:		 256.00MiB
> +    Device allocated:		 255.00MiB
> +    Device unallocated:		   1.00MiB
> +    Device missing:		     0.00B
> +    Used:			 179.03MiB
> +    Free (estimated):		     0.00B	(min: 0.00B)
> +    Data ratio:			      1.00
> +    Metadata ratio:		      2.00
> +    Global reserve:		  16.00MiB	(used: 0.00B)
> +
> +Data,single: Size:175.00MiB, Used:175.00MiB
> +   /dev/nvme0n1p2	 175.00MiB
> +
> +Metadata,DUP: Size:32.00MiB, Used:2.00MiB
> +   /dev/nvme0n1p2	  64.00MiB
> +
> +System,DUP: Size:8.00MiB, Used:16.00KiB
> +   /dev/nvme0n1p2	  16.00MiB
> +
> +Unallocated:
> +   /dev/nvme0n1p2	   1.00MiB
> 
