Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E99C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 12:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB81A2087C
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 12:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EbB2lw0A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB81A2087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbeKPWSe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 17:18:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeKPWSe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 17:18:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAGBrVYh115923;
        Fri, 16 Nov 2018 12:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=vVkXinO3niArNVYPp+BgyAz4Yo9zbPmP3wkRVAG+zVk=;
 b=EbB2lw0AbUWw7LbDCwk0bc2dpZBVUJDxTMXDL6xG4Hmf1TXIPhCuc3j0LNJY7kDVSpfK
 sBLcnJLhG1hgVkJl38eu8ypSgPH7o/Smt3pBQ2K7pyY+EPzotIePYtusOFzQNF+Eu5xY
 CcqoNPAj7pWqeBJOt8LIJSqB/KeX6TiU/iYYcy9wrzMd+sVmgcPvQMEPXxYBDuP+NP+x
 Dyxr1mOWLMiNOgcKtedZaGXAGSvxBN7nWZH4iYwGek13p75CVa+UkZYIGLVVERDFFyLq
 HYwME7QrKMFqT+XJNppEzbOVe27rkKf4rVoLl5sFxUVG4boSRXWXy8V4v7hGic7yz3q0 gg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2nr7csev4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 12:06:25 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAGC6OES028684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 12:06:24 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAGC6OUo025246;
        Fri, 16 Nov 2018 12:06:24 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 04:06:24 -0800
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 7/9] btrfs: quiten warn if the replace is canceled at
 finish
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-8-git-send-email-anand.jain@oracle.com>
 <20181115153546.GU24115@twin.jikos.cz>
Message-ID: <ae7f7fc1-00de-8caa-a241-35e9dcad36cc@oracle.com>
Date:   Fri, 16 Nov 2018 20:06:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181115153546.GU24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=935
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160107
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/15/2018 11:35 PM, David Sterba wrote:
> On Sun, Nov 11, 2018 at 10:22:22PM +0800, Anand Jain wrote:
>> When we successfully cancel the replace its scrub returns -ECANCELED,
>> which then passed to btrfs_dev_replace_finishing(), it cleans up based
>> on the scrub returned status and propagates the same -ECANCELED back
>> the parent function. As of now only user can cancel the replace-scrub,
>> so its ok to quieten the warn here.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/dev-replace.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
>> index 1dc8e86546db..9031a362921a 100644
>> --- a/fs/btrfs/dev-replace.c
>> +++ b/fs/btrfs/dev-replace.c
>> @@ -497,7 +497,7 @@ static int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>>   	ret = btrfs_dev_replace_finishing(fs_info, ret);
>>   	if (ret == -EINPROGRESS) {
>>   		ret = BTRFS_IOCTL_DEV_REPLACE_RESULT_SCRUB_INPROGRESS;
>> -	} else {
>> +	} else if (ret != -ECANCELED) {
>>   		WARN_ON(ret);
> 
> While this looks ok, can you please rework it so there are no WARN_ON at
> random places in device-replace, poorly substituting error handling?
> 
> The code flow in this case could be changed to make explicit checks for
> the know codes and then a catch-all branch like:
> 
> if (ret == -EINPROGRESS) {
> ...
> } else (if == -ESOMETHINGELSE) {
> ...
> } else {
> 	unknown error, print error and do a proper cleanup
> }
> 

As below..

>>   	}
>>   
>> @@ -954,7 +954,7 @@ static int btrfs_dev_replace_kthread(void *data)
>>   			      btrfs_device_get_total_bytes(dev_replace->srcdev),
>>   			      &dev_replace->scrub_progress, 0, 1);
>>   	ret = btrfs_dev_replace_finishing(fs_info, ret);
>> -	WARN_ON(ret);
>> +	WARN_ON(ret && ret != -ECANCELED);
> 
> This one too, thanks.


  btrfs_dev_scrub() can return quite a lot of errno, which is passed
  here through the btrfs_dev_replace_finishing(), so it won't be
  possible to code them all.

  (we use -ECANCELED only in replace and balance).

Thanks, Anand

