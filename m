Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3485FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 11:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0657206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 11:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UIFIazoL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfCLLMW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:12:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46566 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfCLLMW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 07:12:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2CB91ja173953;
        Tue, 12 Mar 2019 11:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+y91jX6AGtWUCQ1CEIC3+GE9R/FnKEFxLQkft+59UPM=;
 b=UIFIazoLatjUqI+duC1xCeBS5RFISUhEXQrp9eH18YkHtM5m7LJJ2nNFjQmaCvJ61OoA
 4H1lOjuTMVVDG12fSV6zmZ/hEKk0jdEbA17Jsekpsud1vvh07BK/+XgQa6vo1uTXGw71
 qOqX7XYSRp2r7euMOv9ssuqwTICe2pyBjGJDzWZn4eElVrYq/+7zSJeX3ZDCErpGvq4q
 7FSoCM1Cw5uYFmm2WWTnXkcX2VAtwdOg5zXBMqMJQsYZ6vPaksXQoSR0xgQqrJPrjv+Z
 p8J4IGglXmh5ZCUmq79gxjRqN/kzN0s+O02QBbOSO5Ac5X0w7AyAY3LSuJIFvsxkNJ3c yQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2r44wu3wt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Mar 2019 11:12:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2CBCCcJ009981
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Mar 2019 11:12:12 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2CBCCTo032250;
        Tue, 12 Mar 2019 11:12:12 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Mar 2019 04:12:12 -0700
Subject: Re: [PATCH v5 0/9] Misc props.c cleanups
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <20190308150111.GT31119@twin.jikos.cz>
 <4008f7b2-c590-78c8-3004-0b635a5af688@oracle.com>
 <20190311144116.GW31119@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <d32bb7bd-e588-76ce-c07b-b263eb63f8cd@oracle.com>
Date:   Tue, 12 Mar 2019 19:12:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190311144116.GW31119@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9192 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903120080
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/11/19 10:41 PM, David Sterba wrote:
> On Sat, Mar 09, 2019 at 08:04:14AM +0800, Anand Jain wrote:
>> On 3/8/19 11:01 PM, David Sterba wrote:
>>> On Fri, Mar 01, 2019 at 12:34:46PM +0800, Anand Jain wrote:
>>>> v5: drops patch
>>>>       [PATCH v4 03/10] btrfs: trivial, fix c coding style
>>>>       Chanegs are mainly to use BUG_ON instead of ASSERT as in the
>>>>        original code in patches 5-7/9. Fix ASSERT in 8/9. And add
>>>>        a rename in 9/9. Each individual patches as the details of
>>>>        the changes.
>>>
>>> The cleanup makes it easier to follow and the transaction semantics is
>>> more visible, good.
>>>
>>> I've fixed up the small things commented under the patches, no need to
>>> resend. Patchset added to 5.2 queue, thanks.
>>>
>>
>> Thanks for the feedback, review and integration.
>>
>> Just checked these branches scrub-misc, misc-next, for-next-20190307
>> any idea which branch these patches went to.
> 
> It's in a local topic branch and will appear in for-next once the merge
> window is over. I've pushed it out now as ext/anand/cleanup-props-v5 so
> you can have a look.

Thanks. Patches [1-9]/9 Looks good.

