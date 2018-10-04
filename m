Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01AA6C64EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 01:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8CF2098A
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 01:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3YbTt4lU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD8CF2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbeJDH5Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Oct 2018 03:57:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49588 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbeJDH5Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Oct 2018 03:57:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9414KBl024723;
        Thu, 4 Oct 2018 01:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 references : message-id : date : mime-version : in-reply-to : content-type
 : content-transfer-encoding; s=corp-2018-07-02;
 bh=yQz+mfU16eyUJ7WUQL7Z9PaS0YlpiVFg93BdjcD31b8=;
 b=3YbTt4lUKjXtoD4zJqkweZFOWhhmXGXi4eDBfnQujpNEOSE47oJn7lxTrHSoYcgDDQgw
 0d6ssW2w7PIChn8WrhLP0xDW8YyMdGTeSqpcBvTHVJJOavpkMBhoQhib7J1YwOK9Y1d+
 w38H/EMxA9VX0zRUD30CoOAS+i6OUEKegHreTGjOucf8uQnKYiKEuF9OGhZZNTcxGHJE
 tJezOMYrKcl3Fsg89F/Mq2ny92B6PCp6KQro+ef8T+3gpJCVqZxO+U3VAU5bMaNf60yd
 rjfcxFzovbnkMCd6dtPhTOhPgPek1Jw8Vw+tdZ6adVazgKyR5pXUzV/rcmIJxbgyoywA UQ== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mt21r7eqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Oct 2018 01:06:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9416Tb6004351
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Oct 2018 01:06:29 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9416SRZ010353;
        Thu, 4 Oct 2018 01:06:28 GMT
Received: from [192.168.0.120] (/202.156.138.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Oct 2018 01:06:28 +0000
From:   Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 00/11] Cleanup dev-replace locking
To:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1536331604.git.dsterba@suse.com>
 <20180927110646.GP3255@twin.jikos.cz>
Message-ID: <91a85e18-161f-5da0-825e-0468867af3f4@oracle.com>
Date:   Thu, 4 Oct 2018 09:06:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20180927110646.GP3255@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9035 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810040009
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 09/27/2018 07:06 PM, David Sterba wrote:
> On Fri, Sep 07, 2018 at 04:54:59PM +0200, David Sterba wrote:
>> The series peels off the custom locking that's used for dev-replace and
>> uses read-write semaphore in the end.
>>
>> I've mainly focused on correctness and haven't measured the performance
>> effects. There should be none as the blocking and waiting was merely
>> open coding what the rw semaphore does, but without the fairness. The
>> overall number of locks taken is low, there's a lots of IO in between so
>> even if new scheme is slower, I don't expect any dramatic change.
> 
> Mixed results. The btrfs/011 is a test that usually takes long time
> (around 1000 sec on my test box) and I have a long list of run times to
> compare. There this patchset does not show any problems. However on a VM
> with 8 CPUs, this goes from similar times (1000 sec) to several hours,
> without apparent reason. The is other low activity on the system, but so
> this is with testing other patchsets and the times are not that bad.
> 
> So, I'm going to merge the first part of the patchset that does not
> switch the locking primitives to the semaphores, more analysis needed.
> 

I have reviewed/tested all in this set and it looks good to me.

So Reviewed-by: Anand Jain <anand.jain@oracle.com>

I do observer btrfs/011 taking longer time to complete (200sec more) and 
Null pointer dereference even without this patch set, tracing back lead 
to conclusion, that

v4.17 is good.
v4.18-rc1 is bad.

And in particular these commit ids..

7a932516f55c Merge tag 'vfs-timespec64' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground
e7655d2b2546 Merge tag 'for-4.18-part2-tag' of 
git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
15eefe2a99b2 Merge branch 'vfs_timespec64' of 
https://github.com/deepa-hub/vfs into vfs-timespec64
6396bb221514 treewide: kzalloc() -> kcalloc()
