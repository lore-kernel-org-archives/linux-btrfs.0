Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F67C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 23:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89E3720811
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 23:41:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="2rrPsueN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfCSXlo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 19:41:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbfCSXln (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 19:41:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2JNdQqv128317;
        Tue, 19 Mar 2019 23:41:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=sA5fr/X2KKCs/nG7T7pzqDzefug0oM13AlKBPaeIRhA=;
 b=2rrPsueNJC3YQKFEOymxJK4ZNhNJNB23XBPH24FjxXf5TWbADiO80lC0Y4sgyjPl3wmp
 uryZvgqhY/bm5w0ao0w+JrRpryp0Dhzr+n+Nh2536lIeXXw4GZay47w6HnQecLxrw6LX
 ZYbqAUaLn5vToDOzmxd7QnuADFjt2nDKMGJYvZ3PbgaXMvn1LU2uyJKFs/EX6twWGxqv
 kl2o83sPAqx+yE1anamURVCQNkU/j7Jgr4DmCrQGvWJh/Qp8gNjZ1t7qiEJ4ZmOJsNt9
 fsQTAZDtC021Hx7z9ggCNkn7ZCHrKAETvfEZOqpIBi3XgwCza5UL0my7BrF0mgwUMvoz 4w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2r8rjuqsk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 23:41:40 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x2JNfdcV009600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Mar 2019 23:41:39 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2JNfdKC013145;
        Tue, 19 Mar 2019 23:41:39 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Mar 2019 16:41:38 -0700
Subject: Re: [PATCH RFC] btrfs: fix read corrpution from disks of different
 generation
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1552995330-28927-1-git-send-email-anand.jain@oracle.com>
 <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <055cad22-76be-1547-c7f7-4de54dd1049c@oracle.com>
Date:   Wed, 20 Mar 2019 07:41:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b458f22f-9833-27bd-dd06-ba2862aa59c4@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9200 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=957 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903190162
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


>>   But csum verification is a point in verification and its not a
>>   tree based transid verification. Which means if there is a stale data
>>   with matching csum we may return a junk data silently.
> 
> Then the normal idea is to use stronger but slower csum in the first
> place, to avoid the csum match case.

  This is just a general observational comment, its ok lets assume
  current point in csum verification works (as opposed to tree based
  parent transid verification).

>>   This problem is
>>   easily reproducible when csum is disabled but not impossible to achieve
>>   when csum is not disabled as well.
> 
> Under this case, it's the user to be blamed for the decision to disable
> the csum in the first place.

  The point here is. The logic isn't aware of the write hole on the other
  disk on which the metadata is not verified. I disagree that nocsum or
  the user to be blamed.

> 
>> A tree based integrity verification
>>   is important for all data, which is missing.
>>   
>>   Fix:
>>     In this RFC patch it proposes to use same disk from with the metadata
>>   is read to read the data.
> 
> The obvious problem I found is, the idea only works for RAID1/10.
> 
> For striped profile it makes no sense, or even have a worse chance to
> get stale data.
> 
> 
> To me, the idea of using possible better mirror makes some sense, but
> very profile limited.

  Yep. This problem and fix is only for the mirror based profiles
  such as raid1/raid10.

> 
> Another idea I get inspired from the idea is, make it more generic so
> that bad/stale device get a lower priority.

  When it comes to reading junk data, its not about the priority its
  about the eliminating. When the problem is only few blocks, I am
  against making the whole disk as bad.

> Although it suffers the same problem as I described.
> 
> To make the point short, the use case looks very limited.

  It applies to raid1/raid10 with nodatacow (which implies nodatasum).
  In my understanding that's not rare.

  Any comments on the fix offered here?

Thanks, Anand


> Thanks,
> Qu
