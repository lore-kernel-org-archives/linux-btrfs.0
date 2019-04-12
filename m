Return-Path: <SRS0=+qyB=SO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE08C10F14
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:39:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E055E2083E
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Apr 2019 07:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KOu4vim7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfDLHjk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Apr 2019 03:39:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfDLHjk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Apr 2019 03:39:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7Xf8U068227;
        Fri, 12 Apr 2019 07:39:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fkOZArKcpGXwTPSFa7ENWJJFw7hsbeiiJlfXOxHIC2w=;
 b=KOu4vim7ixkHtC+jX3IPPieK2lNx014lsOId0iNP+JK8ch8/Ev7SeqiYgdkVvjDH1c3R
 UjyfrhXe3PDYVi76e7Da2WoW+DgX2mqShlnSpcBAkTDKn54CQMkZj0J9kXx9Do6L31P4
 jsHSivI9g2eZryleJrUhIfNGEknkePqk7wnV70ZoU7MIQ3uRN/WCDoERBtGk8HYsZJrW
 xB8xnjWmH/JPaOq9RMkARZMR0kgqr+hJZ6TybIHuXE/9a1Uhs9TTC0t597p4z9aFjmTD
 mT/aoLYETg4WoYlHEhjp2f7GZVtbqiPO3+Uvgya0sfF2RK9O7LUIIxcN/B001jHHxB0c yA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2rpmrqmut1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 07:39:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3C7cbch003272;
        Fri, 12 Apr 2019 07:39:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2rph7u51p6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Apr 2019 07:39:32 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3C7dUZp009467;
        Fri, 12 Apr 2019 07:39:31 GMT
Received: from [10.190.130.106] (/192.188.170.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Apr 2019 00:39:30 -0700
Subject: Re: [PATCH RFC] fstests: generic/077: fix populate fs use _fill_fs()
To:     Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
References: <20190412052418.22206-1-anand.jain@oracle.com>
 <91949b01-d016-f732-265b-77a397a1efbe@gmx.com>
 <dd0e5f46-09b0-8be2-d909-2e011d72ff5e@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1586b0c1-c973-8ace-ca8b-e3f52298dd25@oracle.com>
Date:   Fri, 12 Apr 2019 15:39:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dd0e5f46-09b0-8be2-d909-2e011d72ff5e@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904120052
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9224 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904120052
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/4/19 3:27 PM, Nikolay Borisov wrote:
> 
> 
> On 12.04.19 г. 10:15 ч., Qu Wenruo wrote:
>>
>>
>> On 2019/4/12 下午1:24, Anand Jain wrote:
>>> Test case generic/077 uses files under /lib or /usr to fill SCRATCH_MNT.
>>> If /usr or /lib is below 256mb then test fails to run, or if these dirs
>>> are too large it takes a long time for the cp to finish. On my machine
>>> it takes 645sec.
>>
>> Wait for a minute, ths fs is only 256M sized, if it takes you over 10
>> minutes, there must be something else wrong.
> 
> I've had the same issue, the problem is that once the fs is full cp will
> continue happily trying to copy stuff and will just be failing with ENOSPC
> 
>>
>>>
>>> This patch propose to use the common/populate function _fill_fs() to
>>> write files into the target directory instead. However I am not too
>>> sure about the motivation of this test case in the first place, and
>>> why does it wanted to cp /usr or /lib,
>>
>> To my eyes, it's using /usr or /lib just for it's mostly full/contains a
>> lot of files for most systems.
>>
>>> and why fs should become full?
>>
>> Maybe to hit certain ENOSPC corner case for ACL/xattr, just my guess.
> 
> nod, I've used that test to test certain patches (latest this test was
> useful is when testing Anad's xattr/acl patches)
> 
>>
>>> Any idea? Thanks.
>>
>> Use populate_fs is definitely the right move.
>>
>> However I have some concern below.
>>
>> [snip]
>>>   echo "*** set default ACL"
>>>   setfacl -R -dm u:fsgqa:rwx,g::rwx,o::r-x,m::rwx $SCRATCH_MNT/subdir
>>>   
>>> -echo "*** populate filesystem, pass #1" | tee -a $seqres.full
>>> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>>> -
>>> -echo "*** populate filesystem, pass #2" | tee -a $seqres.full
>>> -cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>>> +blksz="$(_get_block_size $SCRATCH_MNT/subdir)"
>>> +echo "*** populate filesystem" | tee -a $seqres.full
>>> +echo "*** fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0" >> $seqres.full
>>> +_fill_fs $fs_size $SCRATCH_MNT/subdir $blksz 0 >> $seqres.full 2>&1
>>
>> Unlike the original behavior, which do 2 passes and the 2nd pass will
>> overwrite previous files.
>>
>> While after your modification, it's no longer the case.
>>
>> At least we should try to replay the 1st run to mimic the original behavior.
> 
> Looking at the test shouldn't the "set default acl" be done after the fs
> is completely full?

  Even by using a large /usr, the cp (2 iterations) was never been able
  to make the metadata full, (same with __full_fs() as well).

  After cp -r /usr <256mb fs> reported ENOSPC.
  stat -f -c "%f" /btrfs
   16488

Thanks, Anand

>>
>> Thanks,
>> Qu
>>
>>>   
>>>   _check_scratch_fs
>>>   
>>> diff --git a/tests/generic/077.out b/tests/generic/077.out
>>> index eae7226ab29c..9c143c902a2c 100644
>>> --- a/tests/generic/077.out
>>> +++ b/tests/generic/077.out
>>> @@ -1,7 +1,6 @@
>>>   QA output created by 077
>>>   *** create filesystem
>>>   *** set default ACL
>>> -*** populate filesystem, pass #1
>>> -*** populate filesystem, pass #2
>>> +*** populate filesystem
>>>   *** all done
>>>   *** unmount
>>>
>>
