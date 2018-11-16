Return-Path: <SRS0=S1wN=N3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B709CC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 13:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A3A32087A
	for <linux-btrfs@archiver.kernel.org>; Fri, 16 Nov 2018 13:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wjnX4M3Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A3A32087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389629AbeKPXwR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 18:52:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbeKPXwR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 18:52:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAGDXqfU186411;
        Fri, 16 Nov 2018 13:39:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=m5b0eER815Zb2q64Z3RNB8zRxxDtRNnfG6b4ZK5f5vA=;
 b=wjnX4M3ZjJoLM6sBO6aq1T3aaCDamOaIm5hapKGeR1XTV5cvxkBCZHZkRBjUsNvI34s8
 DiCrP3CJPOXVljAUm7ujjmtKzblIx3BfLuwdGUTzULmyq50R7GrJmR4Yl90pEW9y+K0J
 UQNoG4AYg8EBEVBiaLVKP0WejGQb4VOhW9MlATCmqhDmkgjFX8xyKKWin3Jvh7dDKp8I
 ZD/eYiEE+ow+ONIbHNt2a+C8bwy2jKmNKxBAAEN+WUx+OMQwgAhvNOd/CDMgHrhrAS7R
 LHzSiaZqD+cENqBgWaEa9gjQaa+W06WOHqjtqFuDuoszFI37Tbl7aVuxUo1XXeRH62uW ew== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2nr7csf8ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 13:39:46 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAGDddDT012170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Nov 2018 13:39:40 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAGDdd7b022665;
        Fri, 16 Nov 2018 13:39:39 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 16 Nov 2018 05:39:39 -0800
Subject: Re: BTRFS on production: NVR 16+ IP Cameras
To:     Nikolay Borisov <nborisov@suse.com>, jacirez@rdcsafety.com,
        linux-btrfs@vger.kernel.org
References: <bf338fb1-11fe-baea-4099-af9dc267e597@rdcsafety.com>
 <8bc60329-27fa-f7ec-1767-fd1a3c5823a4@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <14a0a0fe-a33f-5d0a-7cf7-fe2c17df27b7@oracle.com>
Date:   Fri, 16 Nov 2018 21:39:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <8bc60329-27fa-f7ec-1767-fd1a3c5823a4@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9078 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811160121
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/16/2018 03:51 AM, Nikolay Borisov wrote:
> 
> 
> On 15.11.18 г. 20:39 ч., Juan Alberto Cirez wrote:
>> Is BTRFS mature enough to be deployed on a production system to underpin
>> the storage layer of a 16+ ipcameras-based NVR (or VMS if you prefer)?
>>
>> Based on our limited experience with BTRFS (1+ year) under the above
>> scenario the answer seems to be no; but I wanted you ask the community
>> at large for their experience before making a final decision to hold off
>> on deploying BTRFS on production systems.
>>
>> Let us be clear: We think BTRFS has great potential, and as it matures
>> we will continue to watch its progress, so that at some future point we
>> can return to using it.
>>
>> The issue has been the myriad of problems we have encountered when
>> deploying BTRFS as the storage fs for the NVR/VMS in cases were the
>> camera count exceeds 10: Corrupted file systems, sudden read-only file
>> system, re-balance kernel panics, broken partitions, etc.
> 
> What version of the file system, how many of those issues (if any) have
> you reported to the upstream mailing list? I don't remember seeing any
> reports from you.
> 
>>
>> One specific case saw the btrfs drive pool mounted under the /var
>> partition so that upon installation the btrfs pool contained all files
>> under /var; /lib/mysql as well as the video storage. Needless to say
>> this was a catastrophe...
> 
> BTRFS is not suitable for random workloads, such as databases for
> example. In those cases it's recommended, at the very least, to disable
> COW on the database files. Note, disabling CoW doesn't preclude you from
> creating snapshots, it just means that not every 4k write (for example)
> will result in a CoW operation.
> 
>>
>> At the other end of the spectrum is a use case where ONLY the video
>> storage was on the btrfs pool; but in that case, the btrfs pool became
>> read-only suddenly and would not re-mount as rw despite all the recovery
>> trick btrfs-tools could throw at it. This, of course prevented the
>> NVR/VMS from recording any footage.
> 
> Again, you give absolutely no information about how you have configured
> the filesystem or versions of the software used.
> 
>>
>> So, again, the question is: is BTRFS mature enough to be used in such
>> use case and if so, what approach can be used to mitigate such issues.

  And..

   What is the blocksize used by the application to write into btrfs?
   And what type of write IO? async, directio or fsync?

Thanks, Anand


>>
>> Thank you all for your assistance
>>
>> -Ryan-
