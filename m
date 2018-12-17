Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB6FC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 07:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4572C2084D
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 07:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ajfuMhXk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbeLQHtU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 02:49:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbeLQHtU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 02:49:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wBH7nFRg186082;
        Mon, 17 Dec 2018 07:49:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QD3CMq73U9bO+ouNpigCuRn8+nJZYFCJ1qIjpzjw21E=;
 b=ajfuMhXkOVvc+pnT1pmriyCQ3aUADeRT4IAfuvxq1qyngkDXff24EeOlp7fi/3Ml81sx
 n4k6lq5UxisPcmHU9tsPwPkQt+U610kkUii+F/3+lS3S1OMB9djvnf+uXNV6QxKehQp2
 u4Beu87nDPEfO+7byZuysNPNuFPWQn7LdtweUErh0PpJNYG1/KUlEsxRnKV0BJcpOip4
 r9yZJ6qopG6yfM8qO6QBd5vZDwRSJhOMRrTrrdNpCb0xAYRcFfn+kCHrSwfkHuHSr4tY
 HAI4xJA3l7cVvWReLe8uE9h4uY5cHJPCNiGrwkNnLdWMta6sJfnMV8FieQawSe2rf+am KQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2pcs1tc9rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 07:49:15 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wBH7nAvK026812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Dec 2018 07:49:10 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wBH7n9sd012725;
        Mon, 17 Dec 2018 07:49:10 GMT
Received: from [172.20.10.2] (/157.49.131.71)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 16 Dec 2018 23:49:09 -0800
Subject: Re: [PATCH 1/2] btrfs-progs: check for no result before using results
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1545016436-4137-1-git-send-email-anand.jain@oracle.com>
 <d875811a-1030-18fe-fd55-fba8bafcc82a@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <126106a3-d1c7-462b-f813-6240eb9c22ad@oracle.com>
Date:   Mon, 17 Dec 2018 15:49:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <d875811a-1030-18fe-fd55-fba8bafcc82a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9109 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1812170074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/17/2018 02:55 PM, Nikolay Borisov wrote:
> 
> 
> On 17.12.18 г. 5:13 ч., Anand Jain wrote:
>> User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
>> using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
>> initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
>> this value in checking for the error.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   cmds-replace.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/cmds-replace.c b/cmds-replace.c
>> index b30e6c781e64..42de4de8c031 100644
>> --- a/cmds-replace.c
>> +++ b/cmds-replace.c
>> @@ -296,6 +296,8 @@ static int cmd_replace_start(int argc, char **argv)
>>   		}
>>   
>>   		if (start_args.result !=
>> +		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT &&
>> +		    start_args.result !=
> 
> While this change is OK, it really is redundant, since we do
> IOC_DEV_REPLACE with CMD_STATUS, meaning in kernel space we always call
> btrfs_dev_replace_status which always overwrites ->result member.

> Also looking at the other 3 cmds available for this IOCTL it's always
> guaranteed for ->result to be overwritten if it executes btrfs code.

> OTOH  if the capable, memdup or an unrecognised ->cmd  is detected then
> an ordinary error code is returned, in which case the ret < 0 check
> executes and laves via "leave_with_error" label.
> 
> While your patch is OK code wise it's really a no op

  Did you miss the point that BTRFS_FS_EXCL_OP can be set by some other
  thread such as balance?.
  So in this context BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS fails to
  report BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS and as the replace thread
  moves further ahead, the BTRFS_IOCTL_DEV_REPLACE_CMD_START will know
  that BTRFS_FS_EXCL_OP is set and the kernel does not reset the
  start_args.result value set by the user land which is
  BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT.

  Besides checking for BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT is a
  right thing in general.


>>   		    BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR) {
>>   			error("ioctl(DEV_REPLACE_START) on '%s' returns error: %s",
>>   				path,
>>
