Return-Path: <SRS0=2H/g=NY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0206BC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE0C82086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 13 Nov 2018 15:47:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G2M+hMDz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE0C82086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387902AbeKNBqA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 20:46:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:54154 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbeKNBqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 20:46:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wADFiPMv085570;
        Tue, 13 Nov 2018 15:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PtoWC3+euzvcIBJKqR1PbyXpgxSqB1ZkuxVZtXyGoRI=;
 b=G2M+hMDzXiLpT+Uf0ozrJO58Hv9/ty9j6f7Un8EKQURgQ843yWE+JlGvL6/Ip5G66P7D
 tJugUsfoWDgFhagHfsy7OTF3ruRfUKDsd+pg2LHunVd4qOPVyR7t3RzBZyIq8C+2RF/v
 DeNckR0KanNkZXX02kxQjAghYrqHZ6fLFMfg19tP/iXE2MYCOra6HO2MKXfFmKy8Nf/c
 JRqMSMYm5885rpsTInmrAXAbWNkg3fPUoHOTDfEGyljUeeu+rsBts2tDKcmlInLq83h9
 rZ35ssPXD+RhZl1B/OMfU1Ot+ZrwHr16OGZJ0Pj3wePt56K9smPD+2Qxz6icSO8z67Wl iA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2nnwc0kgp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 15:47:17 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wADFlGIG003111
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Nov 2018 15:47:16 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wADFlGnV007979;
        Tue, 13 Nov 2018 15:47:16 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Nov 2018 07:47:16 -0800
Subject: Re: [PATCH RFC] btrfs: harden agaist duplicate fsid
To:     dsterba@suse.cz, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <1538384164-3030-1-git-send-email-anand.jain@oracle.com>
 <98cd974b-d817-c30b-5cd7-d69214f44f39@gmail.com>
 <d209b853-4c15-4ef6-58b5-e1b08d409aeb@oracle.com>
 <20181113153149.GD24115@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <228b66c4-f85c-11dc-1a24-d46bc5493788@oracle.com>
Date:   Tue, 13 Nov 2018 23:47:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181113153149.GD24115@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1811130143
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/13/2018 11:31 PM, David Sterba wrote:
> On Mon, Oct 01, 2018 at 09:31:04PM +0800, Anand Jain wrote:
>>>> +        /*
>>>> +         * we are going to replace the device path, make sure its the
>>>> +         * same device if the device mounted
>>>> +         */
>>>> +        if (device->bdev) {
>>>> +            struct block_device *path_bdev;
>>>> +
>>>> +            path_bdev = lookup_bdev(path);
>>>> +            if (IS_ERR(path_bdev)) {
>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>> +                return ERR_CAST(path_bdev);
>>>> +            }
>>>> +
>>>> +            if (device->bdev != path_bdev) {
>>>> +                bdput(path_bdev);
>>>> +                mutex_unlock(&fs_devices->device_list_mutex);
>>>> +                return ERR_PTR(-EEXIST);
>>> It would be _really_ nice to have an informative error message printed
>>> here.  Aside from the possibility of an admin accidentally making a
>>> block-level copy of the volume,
>>
>>> this code triggering could represent an
>>> attempted attack against the system, so it's arguably something that
>>> should be reported as happening.
>>
>>>    Personally, I think a WARN_ON_ONCE for
>>> this would make sense, ideally per-volume if possible.
>>
>>    Ah. Will add an warn. Thanks, Anand
> 
> The requested error message is not in the patch you posted or I have
> missed that (https://patchwork.kernel.org/patch/10641041/) .

  No you didn't miss. I missed it. When you integrated this into
  for-next, I should have sent out v2. Sorry. Thanks for taking
  care of it.

> Austin, is the following ok for you?
> 
>    "BTRFS: duplicate device fsid:devid for %pU:%llu old:%s new:%s\n"
> 
>    BTRFS: duplicate device fsid:devid 7c667b96-59eb-43ad-9ae9-c878f6ad51d8:2 old:/dev/sda6 new:/dev/sdb6
> 
> As the UUID and paths are long I tried to squeeeze the rest so it's
> still comprehensible but this would be better confirmed. Thanks.

Thanks, Anand


