Return-Path: <SRS0=ymi4=NB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E09CECDE43
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 14:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8EB20869
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Oct 2018 14:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0F63TANb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA8EB20869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbeJUW2H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Oct 2018 18:28:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbeJUW2H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Oct 2018 18:28:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9LE8v06080090;
        Sun, 21 Oct 2018 14:13:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qworgh2F+fd0RssSQAJNAQ8+d7rUhsy+TTeUwNYaOxw=;
 b=0F63TANbwLEy+P+rcPxMU4bNXyUl8BpQmXjl6H1dGJkaK739OsmJ0XXIOKyOUEmWFGgH
 /NZTf03E4D4+EP4zTK5fVr9zWFTFgE3ZtyUuD0lScIMbT2zzLaxSZWJtvAq+RcXMXvt+
 VcWomoOIxiKhAJ0Ol2tSWWxcIL7k/ozFQ99q3tAdUkH/BoNJndWU3mh9De6pedPgEYqQ
 SPmUipT3sf1jOEEnYXryPcjCjrgm5Gb0JUIGe3E56V+WPNcjp3IgC1Vu++wUWEn80m4U
 hhsx6WoOY6pH8E+4LHg7WK1hxXdGx0j8czFcKabQs9m3BV7mN9NI0X/CBl8iRkLrYxBM og== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2n7vapjsuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Oct 2018 14:13:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9LEDWbY004425
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 21 Oct 2018 14:13:32 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9LEDVpD006457;
        Sun, 21 Oct 2018 14:13:31 GMT
Received: from [172.20.10.2] (/183.90.36.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 21 Oct 2018 07:13:31 -0700
Subject: Re: [PATCH] btrfs/154: test for device dynamic rescan
To:     fdmanana@gmail.com, Nikolay Borisov <nborisov@suse.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20171113022541.7413-1-anand.jain@oracle.com>
 <CAL3q7H41dQpiVaCyre3sCgAaVXd19-cWbLO68z4ovJz2F1E2-g@mail.gmail.com>
 <a83fb0ce-dff8-9389-2371-f2e7a5164153@suse.com>
 <CAL3q7H7inq5UCgihaP8i+9NOGiSvDGc6ndphMyuONc6OTJFtiw@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <184cb50c-1504-039b-6792-b5a710296ded@oracle.com>
Date:   Sun, 21 Oct 2018 22:13:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7inq5UCgihaP8i+9NOGiSvDGc6ndphMyuONc6OTJFtiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9052 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810210133
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/21/2018 05:31 PM, Filipe Manana wrote:
> On Sun, Oct 21, 2018 at 10:20 AM Nikolay Borisov <nborisov@suse.com> wrote:
>>
>>
>>
>> On 21.10.2018 10:16, Filipe Manana wrote:
>>> On Mon, Nov 13, 2017 at 2:26 AM Anand Jain <anand.jain@oracle.com> wrote:
>>>>
>>>> Make sure missing device is included in the alloc list when it is
>>>> scanned on a mounted FS.
>>>>
>>>> This test case needs btrfs kernel patch which is in the ML
>>>>    [PATCH] btrfs: handle dynamically reappearing missing device
>>>> Without the kernel patch, the test will run, but reports as
>>>> failed, as the device scanned won't appear in the alloc_list.
>>>
>>> So that patch was never merged, at least not with that subject.
>>> What happened?

  The contending patch at V5 (with fixed comments as received) was
  working fine at the then latest kernel version, now its out dated,
  and I am not sure where to invest my time, it will be better to
  have David's comment, if he has any concern on the idea/approach
  in general. I am ok to revive the patch.

>> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/btrfs/154
>>
>> In my testing of misc-next this test has been failing for me.

  Don't bother about that patch I am sure its not good on the current
  kernel.

>  recent hole punch
> test, that doesn't have a corresponding kernel fix.

  Hole punching kernel patch, fixes a corner case, I tried but failed.
  Until my current priority list recedes I won't be able to look into
  it again. If you would like to pick this up pls go ahead. I think it
  will easy for you.

  Lastly, I think its a good idea to record the current known limitation
  as a test cases, even if it fails, in that way it gets documented.

Thanks, Anand
