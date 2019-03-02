Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2318C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 10:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65E1020838
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 10:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a1cC0vAE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfCBKTm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Mar 2019 05:19:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42744 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfCBKTm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Mar 2019 05:19:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x22AIuuc143766;
        Sat, 2 Mar 2019 10:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ShGhbJpAnuR1IBgmNGS1K4ExGEFso57jmDyogOHNeQs=;
 b=a1cC0vAE/ikhjwAC2dkuKfsKw4MWt63+pYN6kS2X2twT0/aWLGZ1o5unjf+YoLWnibR8
 0kjiqfZKzDC00AbOcFza34QnA7onix9/EsIYfrGzvwffEVFVqJcgA0Ssj59PIRFML3td
 0a/Bh9bFt/mQ0shI4sJROjaclXZN9ojh5TScA4WDsfzEAhKWr8u10N23xl7Z69XcO08Z
 kMOWxOjNj63wh7KFDffZrRBKbgrnoqjQRxOg2eHBE0evCHSD0ltbIajnGygS52xnhXqU
 4TesB80Dvby+SIgzhb34FxutHfXwUIDFw5pNrPuQ98/IKUKoaBes7bFGBkZ6vWtuWp9P SA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qyh8trph7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Mar 2019 10:19:38 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x22AJbDg031593
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 2 Mar 2019 10:19:37 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x22AJaCh007340;
        Sat, 2 Mar 2019 10:19:36 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 02 Mar 2019 02:19:36 -0800
Subject: Re: [PATCH RESEND 1/2] btrfs-progs: check for no result before using
 results
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1548929141-10695-1-git-send-email-anand.jain@oracle.com>
 <20190301164156.GT31119@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <0b5529a7-f8e3-9bff-6f4d-eb70c4b96d91@oracle.com>
Date:   Sat, 2 Mar 2019 18:19:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190301164156.GT31119@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9182 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903020076
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3/2/19 12:41 AM, David Sterba wrote:
> On Thu, Jan 31, 2019 at 06:05:40PM +0800, Anand Jain wrote:
>> User space understands the ioctl BTRFS_IOC_DEV_REPLACE command status
>> using the struct btrfs_ioctl_dev_replace_args::result, and so userspace
>> initializes this to BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT, so exclude
>> this value in checking for the error.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> 1 and 2 applied, thanks.
> 

Thanks.

  While at btrfs-progs you could include [1] as well.

[1]
  [PATCH v4] btrfs-progs: dump-tree: add noscan option
  https://patchwork.kernel.org/patch/10832585/

-Anand
