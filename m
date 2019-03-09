Return-Path: <SRS0=Falb=RM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7554C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 00:04:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3788204FD
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Mar 2019 00:04:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IQjJdeKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfCIAEQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:04:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37044 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfCIAEQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Mar 2019 19:04:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x29005ga077423;
        Sat, 9 Mar 2019 00:04:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XFFoH5eBvKISRjod/BFcdo6xHcAY/zrw9zNP8miaf+s=;
 b=IQjJdeKi7JBsy098IF65o9OxJ0TIBuzT1c7EmFRiETt2mU7LRWeqh+UWnjLeFUX3L5A2
 c9skY1CzVgiBllSyrbT3jVb6w2Ng6+5gZbLpHFnzxixES7p/TB/HRgL9V7AwEHnTB/WK
 cbJQWsrdsBbpZYwmzjkvf2ilVDaO91oLxd1uabKxdtvtL1sVgq2rQtm//VjizO/hSCNv
 CKoEaQygFIZRsM9WYLOSx2Wf3O17KjX0snq2u+jJTE+6P0Tj6w6Wtq6cREbU+x91i/eZ
 u0Y4LNBCe2BYnSpQytfDiLEKvMArp4H/DKQB8ImIGhE/XdbWnxJXYmupEYfMeDlSwHUN 5g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qyh8uu30n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Mar 2019 00:04:12 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x29046G8003449
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 Mar 2019 00:04:06 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x29045K1009515;
        Sat, 9 Mar 2019 00:04:06 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Mar 2019 16:04:04 -0800
Subject: Re: [PATCH v5 0/9] Misc props.c cleanups
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1551414895-22925-1-git-send-email-anand.jain@oracle.com>
 <20190308150111.GT31119@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <4008f7b2-c590-78c8-3004-0b635a5af688@oracle.com>
Date:   Sat, 9 Mar 2019 08:04:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190308150111.GT31119@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9189 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903080165
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/8/19 11:01 PM, David Sterba wrote:
> On Fri, Mar 01, 2019 at 12:34:46PM +0800, Anand Jain wrote:
>> v5: drops patch
>>      [PATCH v4 03/10] btrfs: trivial, fix c coding style
>>      Chanegs are mainly to use BUG_ON instead of ASSERT as in the
>>       original code in patches 5-7/9. Fix ASSERT in 8/9. And add
>>       a rename in 9/9. Each individual patches as the details of
>>       the changes.
> 
> The cleanup makes it easier to follow and the transaction semantics is
> more visible, good.
> 
> I've fixed up the small things commented under the patches, no need to
> resend. Patchset added to 5.2 queue, thanks.
> 

Thanks for the feedback, review and integration.

Just checked these branches scrub-misc, misc-next, for-next-20190307
any idea which branch these patches went to.

Thanks, Anand
