Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43853C10F0E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CBC2171F
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="itOncbhG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfDLHaS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 03:30:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47922 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfDLHaS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 03:30:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7TYpA056947;
        Fri, 12 Apr 2019 07:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=bq5YLNHu2PVmp00Qp6J8xymNXBIQN+nuReNWwrVPQ3c=;
 b=itOncbhGr0HA7sUwZKI4i4TnasP2d15DnV0eUnoeFuH1obgTO2pwGzUHJTJe6KEqKcFu
 lmuy6mGkny6m3t4+qGT0xjUyAre+beecvHoKhnk+18N7pi/rUyz6tJ0cc34P1UkC3L8E
 cRATq1IUh7NandEv3rclx5NHf+8sFtSTSjOSMrbZo8vJuY6Kn8Dv2HBV/I/jBXwLqotZ
 JF1x6mTOtVxarSP77ykGRoOHeeNMjXcurCVoK5DXr9lgOwtYNFqfVu/isMnaWvG7vbdG
 f0UGIwIon39HeoXR9iEpfU42KA3HG9ow+6H8nSg6Xjbrr0P67l5rPlFopFuf866sZt6N uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2rpkhtcwu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 07:30:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7Sekc180562;
        Fri, 12 Apr 2019 07:30:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2rph7u4xpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 07:30:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C7UCAD004697;
        Fri, 12 Apr 2019 07:30:13 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 00:30:12 -0700
Subject: Re: [PATCH RFC] fstests: generic/077: fix populate fs use _fill_fs()
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <20190412052418.22206-1-anand.jain@oracle.com>
 <91949b01-d016-f732-265b-77a397a1efbe@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <b92da32a-d991-f86d-7b85-b1dd33f92b61@oracle.com>
Date:   Fri, 12 Apr 2019 15:30:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <91949b01-d016-f732-265b-77a397a1efbe@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120051
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120051
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/4/19 3:15 PM, Qu Wenruo wrote:
> 
> 
> On 2019/4/12 下午1:24, Anand Jain wrote:
>> Test case generic/077 uses files under /lib or /usr to fill SCRATCH_MNT.
>> If /usr or /lib is below 256mb then test fails to run, or if these dirs
>> are too large it takes a long time for the cp to finish. On my machine
>> it takes 645sec.
> 
> Wait for a minute, ths fs is only 256M sized, if it takes you over 10
> minutes, there must be something else wrong.

  What's happening is cp -r fails (ENOSPC) for each file, so the
  cp -r runs for a long time.

>>
>> This patch propose to use the common/populate function _fill_fs() to
>> write files into the target directory instead. However I am not too
>> sure about the motivation of this test case in the first place, and
>> why does it wanted to cp /usr or /lib,
> 
> To my eyes, it's using /usr or /lib just for it's mostly full/contains a
> lot of files for most systems.

  A lot of files. At the same time its not consistent across systems.

>> and why fs should become full?
> 
> Maybe to hit certain ENOSPC corner case for ACL/xattr, just my guess.

ok.

>> Any idea? Thanks.
> 
> Use populate_fs is definitely the right move.
> 
> However I have some concern below.
> 
> [snip]
>>   echo "*** set default ACL"
>>   setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx $SCRATCH_MNT/subdir
>>   
>> -echo "*** populate filesystem, pass #1" | tee -a $seqres.full
>> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>> -
>> -echo "*** populate filesystem, pass #2" | tee -a $seqres.full
>> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>> +blksz="$(_get_block_size $SCRATCH_MNT/subdir)"
>> +echo "*** populate filesystem" | tee -a $seqres.full
>> +echo "*** fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0" >> $seqres.full
>> +_fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0 >> $seqres.full 2>&1
> 
> Unlike the original behavior, which do 2 passes and the 2nd pass will
> overwrite previous files.
> 
> While after your modification, it's no longer the case.
> 
> At least we should try to replay the 1st run to mimic the original behavior.

  yep.

Thanks, Anand

> Thanks,
> Qu
> 
>>   
>>   _check_scratch_fs
>>   
>> diff --git a/tests/generic/077.out b/tests/generic/077.out
>> index eae7226ab29c..9c143c902a2c 100644
>> --- a/tests/generic/077.out
>> +++ b/tests/generic/077.out
>> @@ -1,7 +1,6 @@
>>   QA output created by 077
>>   *** create filesystem
>>   *** set default ACL
>> -*** populate filesystem, pass #1
>> -*** populate filesystem, pass #2
>> +*** populate filesystem
>>   *** all done
>>   *** unmount
>>
> 
