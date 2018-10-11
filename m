Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64625C32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 03:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186AC2082B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 03:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="xCASxptW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 186AC2082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbeJKKw6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 06:52:58 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49674 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbeJKKw5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 06:52:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9B3Nioh150631;
        Thu, 11 Oct 2018 03:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jVugrqel5ryPoK/W0S2l0wEK+al5DvyQWHe8iC844sA=;
 b=xCASxptWhSOAmmA2QNtfV1yYBR4aj3rJeo+2vpL0wUdAis3Q79qPy0moeClwB6uLA1+V
 y2X2xAPA9jyQMtP2+UffIdskHKnPGJ6vp4Bb9D65nLyjkr3TYTn5niEoQFVn1XVBQn5f
 qtGk3ke8s+pc2E5hhTBcORlENF1HVhxo7nvGcKui5oLhmkfMxlxHzBqP5uMb1acKb/xG
 Nomg0bI1qfpED6miRKXEQui/WlfgSEEMvGilThNqI0AD0Ip6yRy61RuJAnJKofN9XOaR
 4mIPa0Joe+OJW4lCMT59liPhUFHR/cTX68y6Pgl1l7Rz1iW4hOOuY4C981jmI4BFDHWD 2g== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mxn0q8n3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 03:27:43 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9B3Rbq8008404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Oct 2018 03:27:37 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9B3Ranp017202;
        Thu, 11 Oct 2018 03:27:36 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Oct 2018 03:27:36 +0000
Subject: Re: [PATCH v2 3/9] geneirc/077 fix min size for btrfs
From:   Anand Jain <anand.jain@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-4-git-send-email-anand.jain@oracle.com>
 <20181006112507.GL17817@desktop>
 <7874ee99-960a-e6c4-b710-d7a24bd9d64c@oracle.com>
Message-ID: <5166dac1-a4d3-2a74-8520-38359aa1eed9@oracle.com>
Date:   Thu, 11 Oct 2018 11:27:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7874ee99-960a-e6c4-b710-d7a24bd9d64c@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9042 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810110031
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/11/2018 11:14 AM, Anand Jain wrote:
> 
> 
> On 10/06/2018 07:25 PM, Eryu Guan wrote:
>> On Tue, Sep 25, 2018 at 12:24:16PM +0800, Anand Jain wrote:
>>> If btrfs need to be tested at its default blockgroup which is non-mixed,
>>> then it needs at least 256mb.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>
>> (Sorry for the late review..)
> 
>   Its fine. Sorry for the delay at my end too.
> 
>>> ---
>>>   tests/generic/077 | 3 +--
>>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/tests/generic/077 b/tests/generic/077
>>> index ef6af18c83e3..ec236992513f 100755
>>> --- a/tests/generic/077
>>> +++ b/tests/generic/077
>>> @@ -49,8 +49,7 @@ rm -f $seqres.full
>>>   _scratch_unmount >/dev/null 2>&1
>>>   echo "*** MKFS ***"                         >>$seqres.full
>>>   echo ""                                     >>$seqres.full
>>> -SIZE=`expr 50 \* 1024 \* 1024`
>>> -_scratch_mkfs_sized $SIZE                   >>$seqres.full 2>&1 \
>>> +_scratch_mkfs_sized $((256 * 1024 *1024))   >>$seqres.full 2>&1 \
>>>       || _fail "mkfs failed"
>>
>> Hmm, this test copies "/lib/modules/" to fill the original 50M
>> filesystem (which seems a bad way to me)
> 
> Yep. I didn't like either. I started using the _populate_fs() but then 
> was doubtful if it still meets the objective of this test case as it 
> used the dd instead of cp. Moreover it kind of getting diverged from 
> what's the object of this patch. If needed we could fix the cp approach 
> in a separate patch so that we shall have better tracking.
> 
>> "
>> # Something w/ enough data to fill 50M of fs...
>> filler=/lib/modules/
>> ...
>> echo "*** populate filesystem, pass #1" | tee -a $seqres.full
>> cp -rf $filler $SCRATCH_MNT/subdir >$seqres.full 2>&1
>> ...
>> "
>>
>> It works most of the time as "/lib/modules" is usually larger than 50M,
>> but it may not fullfil the fs with 256M size.
>>
>> I think we should fix the way to fill the fs too.
> 
>   Right. There are two iterations of cp. So a check if the assigned 
> filler is big enough to fill the 256M will suffice, as we already 
> _notrun the test if empty filler.
> 
> Pls find v2 for review.

  Sorry for the typo it should be v3.

Thanks, Anand

> Thanks, Anand
> 
>> Thanks,
>> Eryu
>>
>>>   _scratch_mount
>>>   mkdir $SCRATCH_MNT/subdir
>>> -- 
>>> 1.8.3.1
>>>
