Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A836FC43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 02:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7009021582
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 02:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vqaTnBbm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7009021582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbeKONFf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 08:05:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeKONFe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 08:05:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAF2xWW2026062;
        Thu, 15 Nov 2018 02:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Q0n3vXouigA1qguVFka+o+Fk7Ivm3YXKUluE7++dI60=;
 b=vqaTnBbmF5gNVEmxE4BglRymEDVD8wYA3YQa7Gldc97nU0kYee+SAHdoh/jHfQ5HFJFR
 NhongT/zZVuNnY7aIKjyWGlcYASJnDcbkR2uE3j23E3ymiwqr9+0rzQCJ7HWPU9ruqST
 g2chFqlFlUvKDM8onKcEtkE2nQ/pp6p/CV8MziVCz0lSx4mSgUqpbOPMuxRZM+jCzmeK
 OWq1DpMiXOet09R64deFX/Q/HVIWm//IS40iCevb+5Qa5WFAaHtVuxGFnKlDZGK3fRCi
 F8hV4yqA5zIWHFSreInEUuaH/qdedAnaKn4AtwG4rgoCnAnHwQ8/cCa9BZ+41SThSRdY Ow== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2nr7cs72mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Nov 2018 02:59:32 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAF2xVkr028239
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Nov 2018 02:59:31 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAF2xVkD025539;
        Thu, 15 Nov 2018 02:59:31 GMT
Received: from [10.186.50.4] (/10.186.50.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 18:59:31 -0800
Subject: Re: [PATCH RFC] btrfs: harden agaist duplicate fsid
From:   Anand Jain <anand.jain@oracle.com>
To:     dsterba@suse.cz
References: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
 <98cd974b-d817-c30b-5cd7-d69214f44f39@gmail.com>
 <d209b853-4c15-4ef6-58b5-e1b08d409aeb@oracle.com>
 <20181113153149.GD24115@twin.jikos.cz>
 <228b66c4-f85c-11dc-1a24-d46bc5493788@oracle.com>
Cc:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <a1683d86-91a7-2654-8f1a-06cc966652a3@oracle.com>
Date:   Thu, 15 Nov 2018 10:59:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <228b66c4-f85c-11dc-1a24-d46bc5493788@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9077 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=917
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811150025
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/13/2018 11:47 PM, Anand Jain wrote:
> 
> 
> On 11/13/2018 11:31 PM, David Sterba wrote:
>> On Mon, Oct 01, 2018 at 09:31:04PM +0800, Anand Jain wrote:
>>>>> +        /*
>>>>> +         * we are going to replace the device path, make sure its the
>>>>> +         * same device if the device mounted
>>>>> +         */
>>>>> +        if (device->bdev) {
>>>>> +            struct block_device *path_bdev;
>>>>> +
>>>>> +            path_bdev = lookup_bdev(path);
>>>>> +            if (IS_ERR(path_bdev)) {
>>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>>> +                return ERR_CAST(path_bdev);
>>>>> +            }
>>>>> +
>>>>> +            if (device->bdev != path_bdev) {
>>>>> +                bdput(path_bdev);
>>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>>> +                return ERR_PTR(-EEXIST);

  I have installed ubuntu with btrfs as root and with a subvol to be
  mounted at boot. Its working fine.

Thanks, Anand
