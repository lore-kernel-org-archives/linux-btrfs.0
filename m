Return-Path: <SRS0=UqpE=RD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942BAC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 09:50:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 631572171F
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Feb 2019 09:50:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wYo+Dplq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732204AbfB1Jur (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:50:47 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58232 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfB1Jur (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Feb 2019 04:50:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1S9n9eg070000;
        Thu, 28 Feb 2019 09:50:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dUub27rFv6TwFtk4bfOtT9gbopN5okbGhUFEWOrJXwc=;
 b=wYo+DplqnYRmBGP4V9Y+DLOW0sofO2+5Ew5Hc72xbh38EbLPExlVJpXQB6S3ALvMIc+1
 zwkgbVYMi7qbI+Or4igsN9rK1uih4otEhpNQq1ct2mp+gKri/dS4UvwzAuzX3jRwfVRc
 pnpt+WzwZwaCJexHoDPaqw8IwGLrNZbRyOQDIXKFn8NF8S6oYwxiWN479Z2i0eG/Be5K
 4ror2J1GGYE7sKM2UL4NKW5/ppdnWkhbgKJlUe321SjnL5GwpcGhEmMwKeoDAYxC1Diy
 FXmLbDmXiSzOxquSiYnznQ4Ue3aLlu+DWU1bUVdT58A9dteuPKSQ3KhiOB1NJGkh/eb0 MA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2qtupeg6nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 09:50:43 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1S9ogKU022654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Feb 2019 09:50:42 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1S9ogF4005409;
        Thu, 28 Feb 2019 09:50:42 GMT
Received: from [172.20.10.2] (/183.90.37.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Feb 2019 01:50:42 -0800
Subject: Re: [PATCH v4 03/10] btrfs: trivial, fix c coding style
To:     dsterba@suse.cz
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-4-git-send-email-anand.jain@oracle.com>
 <20190227160523.GS24609@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <93a36575-31fb-dc3a-edc9-9eef6054f907@oracle.com>
Date:   Thu, 28 Feb 2019 17:50:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190227160523.GS24609@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9180 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902280070
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2/28/19 12:05 AM, David Sterba wrote:
> On Sat, Feb 23, 2019 at 01:39:45AM +0800, Anand Jain wrote:
>> Maintain the lines extented upto 80 char where possible, and indent the
>> argument.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> I don't think such patches are necessary, there's a lot of strange
> formatting from the past and we could fix the ugly ones but otherwise
> strive to fix everything before it gets merged.  I do a lot of fixups
> just before the final merge, but having everybody follow the same coding
> style is near to impossible.
> 

Ok. Will drop this.
